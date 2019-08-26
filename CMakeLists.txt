set(IXM_ROOT "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "IXM installation root")
set(IXM_MODULE_ROOT "${IXM_ROOT}/Modules" CACHE INTERNAL "Root module for IXM")
include("${IXM_ROOT}/Modules/Common/Import.cmake")
import(IXM::API::*)

if (DEFINED CMAKE_TOOLCHAIN_FILE)
  return()
endif()

string(TOLOWER "${CMAKE_SYSTEM_NAME}" system-name)
get_property(CMAKE_TOOLCHAIN_FILE GLOBAL PROPERTY ixm::toolchain::${system-name})
unset(system-name)