include_guard(GLOBAL)

import(IXM::Check::*)

#[[
Meant for checking the current state of the compiler and code
There are several types of checks
1) Exists (does an include file exist, symbol, compiler flag, linker flag, etc)
2) Is a given entity a specific "type", i.e., what trait does it meet? (std::is_*)
3) If the given entity *exists*, is an attribute of said entity true? (sizeof, alignof)
4) Does my code compile?
5) Does my code run? (not available when cross-compiling)
]]
function (check action)
  action(command FIND ${action} FOR check)
  invoke(${command} ${ARGN})
endfunction()
