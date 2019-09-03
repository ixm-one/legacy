include_guard(GLOBAL)
#[[
This file marks all the "builtin" events that come from CMake operations.
This is done because we don't really have control over some CMake builtin
commands. We do for others however :)

# TODO: Move this to API/CMake.cmake
]]

variable_watch(CMAKE_FIND_PACKAGE_NAME cmake::package)
variable_watch(CMAKE_CURRENT_LIST_DIR cmake::directory)

function (cmake::package variable access value current stack)
  if (NOT variable STREQUAL "CMAKE_FIND_PACKAGE_NAME")
    log(FATAL "cmake::package may only be used on CMAKE_FIND_PACKAGE_NAME")
  endif()
  if (access STREQUAL "MODIFIED_ACCESS")
    ixm_find_package_constructor(${value})
    get_property(events GLOBAL PROPERTY ixm::events::find-package::begin)
  elseif (access STREQUAL "REMOVED_ACCESS")
    ixm_find_package_destructor()
    get_property(name GLOBAL PROPERTY ixm::find)
    string(TOUPPER ${name} upper)
    set(${name}_FOUND ${${name}_FOUND} PARENT_SCOPE)
  endif()
endfunction()

function (cmake::directory variable access value current stack)
  if (NOT variable STREQUAL "CMAKE_CURRENT_LIST_DIR")
    log(FATAL "cmake::directory may only be used on CMAKE_CURRENT_LIST_DIR")
  endif()
  if (access STREQUAL "MODIFIED_ACCESS" AND value)
    get_property(events GLOBAL PROPERTY ixm::events::configure::begin)
    foreach (event IN LISTS events)
      invoke(${event} ${value})
    endforeach()
  elseif (access STREQUAL "MODIFIED_ACCESS" AND value STREQUAL "")
    get_property(events GLOBAL PROPERTY ixm::events::configure::end)
    foreach (event IN LISTS events)
      invoke(${event})
    endforeach()
  endif()
endfunction()
