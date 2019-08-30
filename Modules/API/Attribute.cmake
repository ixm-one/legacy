include_guard(GLOBAL)

import(IXM::Attribute::*)

# This is the only command that truly can't be dynamic due to restrictions
#[[
TODO: This can be extended to take multiple NAMEs and TARGETs
attribute(NAME <name> [DOMAIN <domain>] [<ACTION>] <values...>)
attribute(TARGET <target> PROPERTY <property> [<ACTION>] <values...>)
attribute(RESTORE <name> [DOMAIN <domain>])
attribute(DEFINE <name>...) # TODO: Finish this part up
attribute(GET <out-var> (NAME <name> [DOMAIN <domain>] | TARGET <target> PROPERTY <property>))
]]
function (attribute action)
  if (action STREQUAL "NAME")
    ixm_attribute_name(${ARGN})
  elseif (action STREQUAL "TARGET")
    ixm_attribute_target(${ARGN})
  elseif (action STREQUAL "RESTORE")
    ixm_attribute_restore(${ARGN})
  elseif (action STREQUAL "DEFINE")
    ixm_attribute_define(${ARGN})
  elseif (action STREQUAL "GET")
    ixm_attribute_get(${ARGN})
    list(GET ARGN 0 out-var)
    set(${out-var} ${${out-var}} PARENT_SCOPE)
  else ()
    log(FATAL "attribute(${action}) is not a valid subcommand")
  endif()
endfunction()