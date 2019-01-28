include_guard(GLOBAL)

import(IXM::Check::*)
import(IXM::Find::*)

#[[ Used for checking the current system's environment ]]
function(Find action)
  verify_actions(Find ${action})
  invoke(${Find} ${ARGN})
endfunction()

#[[ Used for checking the current compiler's environment ]]
function (Check action)
  verify_actions(Check ${action})
  invoke(${Check} ${ARGN})
endfunction()
