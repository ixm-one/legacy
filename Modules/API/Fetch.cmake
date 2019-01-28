include_guard(GLOBAL)

import(IXM::Fetch::*)
#[[
NOTES:
We need to overhaul the syntax we use for getting dependencies via
FetchContent. Basically, we want to do something like ExternalData's
DATA{} variables.
Current variable types are (in order of supported priority):
SSH{user@domain:~/path@rev-parse} -> Git Clone
URL{Path/To/File} -> Direct Download
ADD{Path/In/Local/Project} -> add_subdirectory
USE{Path/To/Script.cmake} -> Executes script 
BIN{subject/repo@version:file} -> BinTray

S3B{S3 storage compatible info...} -> S3 Bucket access

#[[
This does all the work of extracting the provider name, getting the command
itself, and then invoking said provider command with the requested arguments.
]]
function (Fetch)
  ixm_fetch_prepare_parameters("${ARGN}")
  ixm_fetch_prepare_command(command ${command})
  ixm_fetch_prepare_options(options "${options}")
  invoke(${command} ${package} ${options})
endfunction()
