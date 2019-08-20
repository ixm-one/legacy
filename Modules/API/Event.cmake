include_guard(GLOBAL)

import(IXM::Event::*)

function (event action name)
  ixm_action_find(command COMMAND event ACTION ${action})
  invoke(${command} ${ARGN})
endfunction()
