include_guard(GLOBAL)

# Handles setting/resetting IXM layout support
function (ixm_project_layout_prepare name)
  parse(${ARGN} @ARGS=? LAYOUT)
  upvar(REMAINDER)
  # This resets the layout so subprojects don't accidentally use the wrong
  # layout, thus breaking the *shit* out of everything
  set(IXM_CURRENT_LAYOUT_NAME ${LAYOUT} PARENT_SCOPE)
endfunction()

function (ixm_project_layout_find name)
  ixm_project_common_search(paths ${name})
  foreach (path IN LISTS paths)
    if (EXISTS "${path}")
      set_property(GLOBAL PROPERTY IXM_CURRENT_LAYOUT_NAME ${name})
      set_property(GLOBAL PROPERTY IXM_CURRENT_LAYOUT_FILE ${path})
      return()
    endif()
  endforeach()
  error("Could not discover layout '${name}'")
endfunction()

function (ixm_project_layout_load name)
  if (NOT name)
    return()
  endif()
  set(IXM_CURRENT_LAYOUT_NAME ${name})
  ixm_project_layout_find(${name})

  get_property(IXM_CURRENT_LAYOUT_FILE GLOBAL PROPERTY IXM_CURRENT_LAYOUT_FILE)
  get_property(IXM_CURRENT_LAYOUT_NAME GLOBAL PROPERTY IXM_CURRENT_LAYOUT_NAME)
  string(TOLOWER "${name}" project)

  dict(INSERT ixm::${project} LAYOUT_FILE "${IXM_CURRENT_LAYOUT_FILE}")
  dict(INSERT ixm::${project} LAYOUT_NAME "${IXM_CURRENT_LAYOUT_NAME}")
  set(IXM_CURRENT_LAYOUT_FILE "${IXM_CURRENT_LAYOUT_FILE}" PARENT_SCOPE)
endfunction()
