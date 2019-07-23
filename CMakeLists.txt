set(IXM_ROOT "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "IXM installation root")
set(IXM_MODULE_ROOT "${IXM_ROOT}/Modules" CACHE INTERNAL "Root module for IXM")
include("${IXM_ROOT}/Modules/Common/Import.cmake")
import(IXM::API::*)