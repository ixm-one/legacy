include_guard(GLOBAL)

include(TargetSetting)
include(Algorithm)

find_package(Sphinx REQUIRED)

option(BUILD_DOCS "Build documentation with Sphinx Documentation Generator")

set(placeholder "." ".")

list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_CURRENT_LIST_DIR}/Sphinx)
include(HTML)

include(APPLE)
include(PAGE)
include(CHM)
list(REMOVE_AT CMAKE_MODULE_PATH 0)

setting(INTERFACE_SPHINX_LATEX_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_HTML_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_EPUB_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_MAN_OUTPUTS ${placeholder})

setting(INTERFACE_SPHINX_JSON_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_XML_OUTPUTS ${placeholder})

setting(INTERFACE_SPHINX_APPLE_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_GNOME_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_INFO_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_PAGE_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_CHM_OUTPUTS ${placeholder})
setting(INTERFACE_SPHINX_QT_OUTPUTS ${placeholder})

function (add_documentation name type)
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
      INTERFACE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
      INTERFACE_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})

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
  add_custom_target(${name}
    DEPENDS BUILDDIR/docs/*.html
    SOURCES $<TARGET_PROPERTY:${name},INTERFACE_SOURCES>)
endfunction ()

function (target_documents name)
  #.doctrees/*.doctrees
endfunction ()

function (target_link_documents name)
endfunction ()
