include_guard(GLOBAL)

include(PushModulePath)
include(TargetProperty)
include(Algorithm)

find_package(Sphinx REQUIRED)

option(BUILD_DOCS "Build documentation with Sphinx Documentation Generator")

function (sphinx_property name)
  define_property(TARGET
    PROPERTY INTERFACE_SPHINX_${name}
    BRIEF_DOCS "${ARGV1}"
    FULL_DOCS "${ARGV2}")
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
      INTERFACE_DOCTREES_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/doctrees/${type}
      INTERFACE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
      INTERFACE_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/sphinx/${type})

  if (NOT BUILD_DOCS)
    return()
  endif()

  add_custom_command(
    OUTPUT $<GENEX_EVAL:$<TARGET_PROPERTY:${name},INTERFACE_SPHINX_${type}_OUTPUTS>>
    BYPRODUCTS $<GENEX_EVAL:$<TARGET_PROPERTY:${name},
    MAIN_DEPENDENCY $<TARGET_PRPOERTY:${name},${type}_CONFIG>
    COMMAND_EXPAND_LISTS
    USES_TERMINAL
    VERBATIM)
  add_custom_target(sphinx-build-${name}
    DEPENDS BUILDDIR/docs/*.html
    SOURCES $<TARGET_PROPERTY:${name},INTERFACE_SOURCES>)
endfunction ()

function (target_documents name)
endfunction ()

# All Sphinx properties
# XXX: some may not work due to CMake's lack of dictionary
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

include(APPLE)
include(INFO)
include(PAGE)
include(CHM)
include(QT)
pop_module_path()

sphinx_property(LATEX_OUTPUTS)
sphinx_property(HTML_OUTPUTS)
sphinx_property(EPUB_OUTPUTS)
sphinx_property(MAN_OUTPUTS)

sphinx_property(JSON_OUTPUTS)
sphinx_property(XML_OUTPUTS)

sphinx_property(APPLE_OUTPUTS)
sphinx_property(GNOME_OUTPUTS)
sphinx_property(INFO_OUTPUTS)
sphinx_property(PAGE_OUTPUTS)
sphinx_property(CHM_OUTPUTS)
sphinx_property(QT_OUTPUTS)
