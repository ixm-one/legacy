include_guard(GLOBAL)
include(FindPackageHandleStandardArgs)

variable_watch(CMAKE_FIND_PACKAGE_NAME ixm::find::package)

# Event handler for entering (and exiting) find_package call
function (ixm::find::package variable access value current stack)
  if (access STREQUAL MODIFIED_ACCESS)
    ixm_find_package_constructor(${value})
  elseif (access STREQUAL REMOVED_ACCESS)
    ixm_find_package_destructor()
    get_property(name GLOBAL PROPERTY ixm::find::package)
    string(TOUPPER ${name} upper)
    upvar(${name}_FOUND)
  endif()
endfunction()

function (ixm_find_package_constructor name)
  set_property(GLOBAL PROPERTY ixm::find::package ${name})
endfunction()

function (ixm_find_package_destructor)
  get_property(name GLOBAL PROPERTY ixm::find::package)
  dict(GET ixm::find::${name} REQUIRED required-vars)
  if (NOT required-vars)
    return()
  endif()
  find_package_handle_standard_args(${name}
    REQUIRED_VARS ${required-vars}
    VERSION_VAR "${name}_VERSION"
    HANDLE_COMPONENTS)
  upvar(${name}_FOUND)
endfunction()
