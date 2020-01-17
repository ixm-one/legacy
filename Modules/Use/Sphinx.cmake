include_guard(GLOBAL)

find_package(Sphinx)

#[[TODO: Some verification of use is still needed]]
function (add_documentation name type)
  set(possible HTML EPUB MAN LATEX JSON XML)
  if (NOT TARGET Python::Sphinx)
    error("Cannot create documentation target without Sphinx")
  endif()
  if (NOT ${type} IN_LIST possible)
    error("add_documentation(${type} is invalid. Use one of: ${possible}")
  endif()
  string(CONCAT compile-definitions
    $<TARGET_PROPERTY:${name},INTERFACE_COMPILE_DEFINITIONS>)
  string(CONCAT compile-options $<TARGET_PROPERTY:${name},COMPILE_OPTIONS>)
  string(CONCAT sphinx-sources $<TARGET_PROPERTY:${name},SPHINX_SOURCES>)
  add_custom_target(${name})
  set_target_properties(${name}
    PROPERTIES
      SPHINX_DOCTREES_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/doctrees/${type}
      SPHINX_BUILDER_TYPE ${type}
      BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/${type}
      SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  string(CONCAT COMPILE_DEFINITIONS $<
    $<BOOL:${compile-definitions}>:
    -D$<JOIN:${compile-definitions},$<SEMICOLON>-D>
  >)
  string(CONCAT COMPILE_OPTIONS $<
    $<BOOL:${compile-options}>:$<JOIN:${compile-options},$<SEMICOLON>>
  >)
  string(CONCAT SOURCES $<$<BOOL:${sphinx-sources}>:${sphinx-sources}>)
  string(CONCAT source-dir $<TARGET_PROPERTY:${name},SOURCE_DIR>)
  string(CONCAT binary-dir $<TARGET_PROPERTY:${name},BINARY_DIR>)
  set(OUTPUTS $<TARGET_PROPERTY:${name},SPHINX_${type}_OUTPUTS>)

  add_custom_command(
    COMMAND Python::Sphinx
      -b $<LOWER_CASE:${type}>
      -d $<TARGET_PROPERTY:${name},SPHINX_DOCTREES_DIR>
      ${COMPILE_DEFINITIONS}
      ${COMPILE_OPTIONS}
      ${SOURCEDIR}
      ${BINARYDIR}
      ${SOURCES}
    MAIN_DEPENDENCY $<TARGET_PROPERTY:${name},SPHINX_CONFIG>
    OUTPUT index.html
    DEPENDS ${SOURCES}
    COMMAND_EXPAND_LISTS
    USES_TERMINAL
    VERBATIM)
  add_custom_target(${PROJECT_NAME}-sphinx-build-${name}
    DEPENDS $<TARGET_PROPERTY:${name},SPHINX_${type}_OUTPUTS>
    SOURCES $<TARGET_PROPERTY:${name},SOURCES>)
endfunction()
