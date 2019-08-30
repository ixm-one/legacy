set(IXM_ROOT "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "IXM installation root")
set(IXM_MODULE_ROOT "${IXM_ROOT}/Modules" CACHE INTERNAL "Root module for IXM")
set(CMake_MODULE_ROOT "${CMAKE_ROOT}/Modules" CACHE INTERNAL "Root module for CMake")
include("${IXM_ROOT}/Modules/API/Import.cmake")

import(IXM::API::*)

if (DEFINED CMAKE_TOOLCHAIN_FILE)
  return()
endif()

string(TOLOWER "${CMAKE_SYSTEM_NAME}" system-name)
#attribute(GET CMAKE_TOOLCHAIN_FILE NAME toolchain:${CMAKE_SYSTEM_NAME})
get_property(CMAKE_TOOLCHAIN_FILE GLOBAL PROPERTY ixm::toolchain::${system-name})
unset(system-name)