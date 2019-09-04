include_guard(GLOBAL)

import(IXM::Attribute::*)


#[[
This is used to get/set attributes in the given execution context. It is *not*
used to set properties on targets. We keep that separate.
When getting a property, there are several layers of lookup used for when a
property isn't set. This is done to permit more granular customization of an
API.

The entire lookup is:

DIRECTORY
PROJECT
IXM

Additionally, when we define an attribute we can set an "initial" setting.
This can be used to "restore" the attribute to its initial state in a given
scope.

The way we add these two scopes is by simply prepending a "magic string" to
each property. One is set to the directory where `project` is called.

Internally, we do:

get_property(directory DIRECTORY PROPERTY 🈯::attr:<attribute>)
get_property(project DIRECTORY ${PROJECT_SOURCE_DIR} PROPERTY 🈯::attr:<attribute>)
get_property(ixm GLOBAL PROPERTY 🈯::attr:<attribute>)
assign(value ? directory project ixm : $CACHE{🈯::attr:<attribute>})

This keeps them separated from properties

The default scope is IXM when defining an attribute
The default scope is the current directory when defining an attribute

attribute(DEFINE <name> [DEFAULT <value>...] [HELP <docs>])
attribute(RESTORE <name> [FOR <scope>])
attribute(GET <name> [FOR <target|scope>] <out-var>)
# Refinement of set_property
attribute(ASSIGN <values...> TO <name> [FOR <target|scope>])
attribute(APPEND <values...> TO <name> [FOR <target|scope>])
attribute(CONCAT <values...> TO <name> [FOR <target|scope>])
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