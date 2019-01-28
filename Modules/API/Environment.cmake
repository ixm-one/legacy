include_guard(GLOBAL)

import(IXM::Check::*)
import(IXM::Find::*)

function(Find action)
  verify_actions(Find ${action})
  invoke(${Find} ${ARGN})
endfunction()

function (Check action)
  verify_actions(Check ${action})
  invoke(${Check} ${ARGN})
endfunction()
