include_guard(GLOBAL)

#[[
Supports the following syntax

import(${name}) -> Import ${IXM_CURRENT_MODULE}/${name} or ${name}_MODULE_ROOT
import(${name}::*) -> Import ${IXM_CURRENT_MODULE}/${name}/*.cmake
import(${name}::Submodule) -> Import ${IXM_CURRENT_MODULE}/${name}/Submodule.cmake
import(${name}::Submodule::*) -> Import ${IXM_CURRENT_MODULE}/${name}/Submodule/*.cmake

Adding a :: in front of the name says "Treat this first path name as ${name}_MODULE_ROOT
This can be useful if wanting to avoid the CMAKE_MODULE_PATH lookup ruleset, as those
are partially taken into account when using an import.
]]
function (ixm_import name)

endfunction()

#[[
This is just a simple wrapper to let a user declare a module, *and* set it's
${name}_MODULE_ROOT all in one go.
]]
macro(ixm_module name)
  include_guard(GLOBAL)
  ixm_internal(${name}_MODULE_ROOT
    ${CMAKE_CURRENT_LIST_FILE}
    "Module Root for '${name}'")
  list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
endmacro()
