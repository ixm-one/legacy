# These are hardcoded property fallbacks during the "bootstrap" phase.
# They become irrelevant later on, but are needed early for some operations.
set_property(GLOBAL PROPERTY imx::🈯::parse::max 9)

set(IXM_ROOT "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "IXM installation root")
set(IXM_MODULE_ROOT "${IXM_ROOT}/Modules" CACHE INTERNAL "Root module for IXM")
set(CMake_MODULE_ROOT "${CMAKE_ROOT}/Modules" CACHE INTERNAL "Root module for CMake")
include("${IXM_ROOT}/Modules/API/Import.cmake")

import(IXM::API::Attribute)
import(IXM::API::Prelude)

import(IXM::API::*)

if (NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  string(TOLOWER "${CMAKE_SYSTEM_NAME}" cmake-system-name)
  get_property(CMAKE_TOOLCHAIN_FILE GLOBAL PROPERTY ixm:toolchain:${cmake-system-name})
  unset(cmake-system-name)
endif()