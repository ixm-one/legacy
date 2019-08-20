include_guard(GLOBAL)
include(FindPackageHandleStandardArgs)

function (ixm_find_package_constructor name)
  set_property(GLOBAL PROPERTY ixm::find ${name})
endfunction()

function (ixm_find_package_destructor)
  get_property(name GLOBAL PROPERTY ixm::find)
  dict(JSON ixm::find::${name} INTO "IXM/Find/${name}.json")
  dict(GET ixm::find::${name} REQUIRED required-vars)
  foreach (var IN LISTS required-vars)
    # TODO: need to make it so that the "required component" is set but NOT
    # with the specific target. In other words, we need some way to say "for
    # each item in COMPONENT, check if true. If they are, set the component_FOUND
    # to true. Right now we're setting X_<TARGET>_FOUND to true :/
    if (${var})
      string(REPLACE "_EXECUTABLE" "" var ${var})
      set(${var}_FOUND ON)
    endif()
  endforeach()
  if (NOT required-vars)
    return()
  endif()
  find_package_handle_standard_args(${name}
    REQUIRED_VARS ${required-vars}
    VERSION_VAR "${name}_VERSION"
    HANDLE_COMPONENTS)
  set(${name}_FOUND ${${name}_FOUND} PARENT_SCOPE)
endfunction()
