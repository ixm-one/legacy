include_guard(GLOBAL)

import(IXM::Event::*)

function (event action name)
  action(command FIND ${action} FOR event)
  invoke(${command} ${name} ${ARGN})
endfunction()