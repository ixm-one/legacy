include_guard(GLOBAL)

find_package(Sphinx)

if (NOT Sphinx_FOUND)
  return()
endif()

#[[ TODO: Some verification of use is still needed ]]
function (add_documentation name type)
  set(possible HTML EPUB MAN LATEX JSON XML)
  if (${type} NOT IN_LIST possible)
    error("add_documentation takes one of: ${possible}")
  endif()
  add_library(${name} INTERFACE)
  set_target_properties(${name}
    PROPERTIES
      INTERFACE_SPHINX_DOCTREES_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/doctrees/${type}
      INTERFACE_SPHINX_BUILDER_TYPE ${type}
      INTERFACE_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/${type}
      INTERFACE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  set(defines $<TARGET_PROPERTY:${name},INTERFACE_COMPILE_DEFINITIONS>)
  set(options $<TARGET_PROPERTY:${name},INTERFACE_COMPILE_OPTIONS>)
  set(sources $<TARGET_PROPERTY:${name},INTERFACE_SOURCES>)
  set(SOURCEDIR $<TARGET_PROPERTY:${name},INTERFACE_SOURCE_DIR>)
  set(BINARYDIR $<TARGET_PROPERTY:${name},INTERFACE_BINARY_DIR>)
  set(OUTPUTS $<TARGET_PROPERTY:${name},INTERFACE_SPHINX_${type}_OUTPUTS>)

  add_custom_command(
    COMMAND Python::Sphinx
      -b $<LOWER_CASE:${type}>
      -d $<TARGET_PROPERTY:${name},INTERFACE_SPHINX_DOCTREES_DIR>
      $<$<BOOL:${defines}>:-D$<JOIN:${defines},$<SEMICOLON>-D>>
      $<$<BOOL:${options}>:$<JOIN:${options},$<SEMICOLON>>>
      ${SOURCEDIR}
      ${BINARYDIR}
    MAIN_DEPENDENCY $<TARGET_PROPERTY:${name},INTERFACE_SPHINX_CONFIG>
    DEPENDS $<$<BOOL:${sources}>:${sources}>
    OUTPUT ${OUTPUTS}
    COMMAND_EXPAND_LISTS
    USES_TERMINAL
    VERBATIM)
  add_custom_target(${PROJECT_NAME}-sphinx-build-${name}
    DEPENDS $<TARGET_PROPERTY:${name},INTERFACE_SPHINX_${type}_OUTPUTS>
    SOURCES $<TARGET_PROPERTY:${name},INTERFACE_SOURCES>)
endfunction()
