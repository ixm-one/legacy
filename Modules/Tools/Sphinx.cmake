include_guard(GLOBAL)

include(IXM)

find_package(Sphinx)

halt_unless(Sphinx FOUND)

option(BUILD_DOCS "Build documentation with Sphinx Documentation Generator")

function (sphinx_property name)
  #  var(brief ${ARGV1} "<none>")
  #  var(full ${ARGV2} "<none>")
  set(brief ${ARGV1})
  set(full ${ARGV2})
  if (NOT brief)
    set(brief "<none>")
  endif()
  if (NOT full)
    set(full "<none>")
  endif()

  define_property(TARGET
    PROPERTY INTERFACE_SPHINX_${name}
    BRIEF_DOCS "${brief}"
    FULL_DOCS "${full}")
endfunction()

function (add_sphinx_target name type)
  set(common HTML EPUB MAN LATEX)
  set(special APPLE GNOME INFO PAGE CHM QT)
  set(data JSON XML)
  any_of(valid "${type} STREQUAL" ${common} ${data} ${special})
  if (NOT valid)
    error("add_documentation takes one of: ${common}|${data}|${special}")
    return()
  endif()
  add_library(${name} INTERFACE)

  set_target_properties(${name}
    PROPERTIES
      INTERFACE_SPHINX_DOCTREES_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/doctrees/${type}
      INTERFACE_SPHINX_BUILDER_TYPE ${type}
      INTERFACE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
      INTERFACE_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/${type})

  if (NOT BUILD_DOCS)
    return()
  endif()
  set(defines $<TARGET_PROPERTY:${name},INTERFACE_COMPILE_DEFINITIONS>)
  set(options $<TARGET_PROPERTY:${name},INTERFACE_COMPILE_OPTIONS>)
  set(sources $<TARGET_PROPERTY:${name},INTERFACE_SOURCES>)
  set(SOURCEDIR $<TARGET_PROPERTY:${name},INTERFACE_SOURCE_DIR>)
  set(BUILDDIR $<TARGET_PROPERTY:${name},INTERFACE_BINARY_DIR>)
  set(OUTPUTS $<TARGET_PROPERTY:${name},INTERFACE_SPHINX_${type}_OUTPUTS>)

  add_custom_command(
    COMMAND Python::Sphinx
    -b $<LOWER_CASE:${type}>
    -d $<TARGET_PROPERTY:${name},INTERFACE_SPHINX_DOCTREES_DIR>
      $<$<BOOL:${defines}>:-D$<JOIN:${defines},$<SEMICOLON>-D>>
      $<$<BOOL:${options}>:$<JOIN:${options},$<SEMICOLON>>>
      ${SOURCEDIR}
      ${BUILDDIR}
    MAIN_DEPENDENCY $<TARGET_PROPERTY:${name},INTERFACE_SPHINX_CONFIG>
    DEPENDS $<$<BOOL:${sources}>:${sources}>
    OUTPUT ${OUTPUTS}
    MAIN_DEPENDENCY 
    COMMAND_EXPAND_LISTS
    USES_TERMINAL
    VERBATIM)
  add_custom_target(sphinx-build-${name}
    DEPENDS BUILDDIR/docs/*.html
    SOURCES $<TARGET_PROPERTY:${name},INTERFACE_SOURCES>)
endfunction ()

# Currently wraps target_sources
function (target_documents name)
endfunction ()

push_module_path(Sphinx)
include(General)
include(Project)
include(i18n)
include(Math)

include(CXX)

include(LATEX)
include(HTML)
include(EPUB)
include(MAN)
include(XML)
pop_module_path()


# All Sphinx properties
# XXX: some may not work due to CMake's lack of dictionary
sphinx_property(CONFIG)
sphinx_property(DOCTREES_DIR)

sphinx_property(LATEX_OUTPUTS)
sphinx_property(HTML_OUTPUTS)
sphinx_property(EPUB_OUTPUTS)
sphinx_property(MAN_OUTPUTS)

sphinx_property(JSON_OUTPUTS)
sphinx_property(XML_OUTPUTS)
