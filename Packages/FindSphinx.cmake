find_package(Python COMPONENTS Interpreter QUIET)
if (NOT TARGET Python::Interpreter)
  return()
endif()

find(PROGRAM sphinx-build)
if (TARGET Sphinx::Sphinx)
  add_executable(Python::Sphinx ALIAS Sphinx::Sphinx)
endif()

function (target_sphinx_sources target)
  target_source_files(${target} ${ARGN} FILETYPE "SPHINX")
endfunction ()

function (add_sphinx_target name type)
  set(possible HTML EPUB MAN LATEX JSON XML)
  if (NOT ${type} IN_LIST possible)
    log(FATAL "add_sphinx_target: ${type} is invalid. Use one of ${possible}")
  endif()
  set(definitions $<TARGET_PROPERTY:${name},INTERFACE_COMPILE_DEFINITIONS>)
  set(options $<TARGET_PROPERTY:${name},INTERFACE_COMPILE_OPTIONS>)
  set(sources $<TARGET_PROPERTY:${name},INTERFACE_SPHINX_SOURCES>)
  # TODO: Move ${name} to an INTERFACE target, then create a sphinx-${name}
  # target that pulls in the INTERFACE libraries' dependencies.
  add_custom_target(${name})
  set_target_properties(${name}
    PROPERTIES
      SPHINX_DOCTREES_DIR "${CMAKE_CURRENT_BINARY_DIR}/sphinx/doctrees/${type}"
      SPHINX_BUILDER_TYPE "${type}"
      BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/sphinx/${type}"
      SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
  set(definitions $<$<BOOL:${definitions}>:-D$<JOIN:${definitions},$<SEMICOLON>-D>>)
  set(options $<$<BOOL:${options}>:$<JOIN:${options},$<SEMICOLON>>>)
  set(sources $<$<BOOL:${sources}>:${sources}>)
  set(source-dir $<TARGET_PROPERTY:${name},SOURCE_DIR>)
  set(binary-dir $<TARGET_PROPERTY:${name},BINARY_DIR>)
  set(outputs $<TARGET_PROPERTY:${name},SPHINX_${type}_OUTPUTS>)

  add_custom_command(
    COMMAND Python::Sphinx
      -b $<LOWER_CASE:${type}>
      -d $<TARGET_PROPERTY:${name},SPHINX_DOCTREES_DIR>
      ${definitions}
      ${options}
      ${source-dir}
      ${binary-dir}
      ${sources}
    MAIN_DEPENDENCY $<TARGET_PROPERTY:${name},SPHINX_CONFIG>
    OUTPUT index.html
    DEPENDS ${sources}
    COMMAND_EXPAND_LISTS
    USES_TERMINAL
    VERBATIM)
endfunction()
