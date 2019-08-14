include_guard(GLOBAL)

# Handles setting/resetting IXM blueprint support

function (ixm_project_blueprint_prepare name)
  parse(${ARGN} @ARGS=? BLUEPRINT)
  upvar(REMAINDER)
  # This resets the current blueprint so subprojects don't accidentally use
  # the blueprints when they didn't intend to. Otherwise, it'd break the shit
  # out of everything
  set(IXM_CURRENT_BLUEPRINT_NAME ${BLUEPRINT} PARENT_SCOPE)
endfunction()

function (ixm_project_blueprint_find name)
  string(TOLOWER "${name}" lower)
  # Construct all possible path names to search for
  foreach (dir IN LISTS IXM_PROJECT_BLUEPRINT_PATH CMAKE_MODULE_PATH IXM_ROOT)
    list(APPEND paths "${dir}/Blueprints/${name}/Init.cmake")
    list(APPEND paths "${dir}/blueprints/${lower}/init.cmake")
    list(APPEND paths "${dir}/Blueprints/${name}.cmake")
    list(APPEND paths "${dir}/blueprints/${lower}.cmake")
    list(APPEND paths "${dir}/${lower}-blueprint.cmake")
    list(APPEND paths "${dir}/${name}Blueprint.cmake")
  endforeach()
  # First one to exist is set as the current blueprint.
  foreach (path IN LISTS paths)
    if (EXISTS "${path}")
      set_property(GLOBAL PROPERTY IXM_CURRENT_BLUEPRINT_NAME ${name})
      set_property(GLOBAL PROPERTY IXM_CURRENT_BLUEPRINT_FILE ${path})
      return()
    endif()
  endforeach()
  error("Could not discover blueprint '${name}'")
endfunction ()

function (ixm_project_blueprint_load name)
  if (NOT name)
    return()
  endif()
  set(IXM_CURRENT_BLUEPRINT_NAME ${name})
  ixm_project_blueprint_find(${name})

  get_property(file GLOBAL PROPERTY IXM_CURRENT_BLUEPRINT_FILE)
  get_property(path GLOBAL PROPERTY IXM_CURRENT_BLUEPRINT_NAME)

  # TODO: change this to ${PROJECT_NAME}::blueprint FILE/NAME
  dict(SET ixm::${PROJECT_NAME}
    BLUEPRINT_FILE "${file}"
    BLUEPRINT_NAME "${name}")
  set(IXM_CURRENT_BLUEPRINT_FILE "${file}" PARENT_SCOPE)
endfunction()

