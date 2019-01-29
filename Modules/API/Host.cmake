include_guard(GLOBAL)

import(IXM::Check::*)
import(IXM::Find::*)

# Meant for packages and items stored on the host system
function(Find action)
  verify_actions(Find ${action})
  invoke(${Find} ${ARGN})
endfunction()

# Meant for checking the current state of the compiler
function (Check action)
  verify_actions(Check ${action})
  invoke(${Check} ${ARGN})
endfunction()
