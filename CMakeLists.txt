#[[
This is basically our bootstrap file. All statements placed here are done so
specifically so once we are included, we can not only rely on ourselves (and
thus dogfood our behavior!) but we are also able to set a few cache vars and
work *around* some of CMake's proclivities.
]]
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/languages)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/packages)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Modules)

set(IXM_ROOT "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "IXM installation root")

# These files do not depend on each other and *thus* we do not care about their
# order of inclusion except as to make them look nice.
# Additonally, each function inside *is* now namespace with the exception of
# a few macros. These macros can be disabled by users by setting the 
# IXM_ENABLE_MACRO option to false.
# Each macro can also be disabled on a case by case basis. This could
# potentially cause problems with dependencies downstream, so please be careful
include("${IXM_ROOT}/Modules/Internal/Import.cmake")
include("${IXM_ROOT}/Modules/Internal/Invoke.cmake")
include("${IXM_ROOT}/Modules/Internal/Enable.cmake")
include("${IXM_ROOT}/Modules/Internal/Parse.cmake") # The "new" ArgParse
include("${IXM_ROOT}/Modules/Internal/Scope.cmake") # DONE (for now~)
include("${IXM_ROOT}/Modules/Internal/Macro.cmake") # Options and macro wrappers

# Now we can start using them "safely".
# We do our DAMNDEST to never let this be overriden
ixm_internal(IXM_MODULE_ROOT
  "${CMAKE_CURRENT_LIST_DIR}/modules/IXM.cmake"
  "Root module for the IXM library")
ixm_internal(IXM_BINARY_DIR
  "${CMAKE_CURRENT_BINARY_DIR}"
  "Directory for generated files for the IXM Library")
