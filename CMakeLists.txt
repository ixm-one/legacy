#[[
This is basically our bootstrap file. All statements placed here are done so
specifically so once we are included, we can not only rely on ourselves (and
thus dogfood our behavior!) but we are also able to set a few cache vars and
work *around* some of CMake's proclivities (aka, its bullshit).

This file used to be much bigger but with some work we were able to knock it
down to basically nothing at all!
]]
set(IXM_ROOT "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "IXM installation root")
set(IXM_MODULE_ROOT "${IXM_ROOT}/Modules" CACHE INTERNAL "Root module for IXM")
include("${IXM_ROOT}/Modules/Internal/Import.cmake")

import(IXM::Internal::*)
import(IXM::API::*)
