include_guard(GLOBAL)

import(IXM::Generate::*)

function (generate subcommand)
  ixm_action_find(command COMMAND generate ACTION ${subcommand})
  invoke(${command} ${ARGN})
endfunction()
