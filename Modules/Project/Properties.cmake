include_guard(GLOBAL)

define_property(GLOBAL PROPERTY IXM_CURRENT_LAYOUT_NAME
  BRIEF_DOCS "Name of value passed to `project(... LAYOUT <name>)`"
  FULL_DOCS [[
Name of the current value passed to the IXM `project()` function override.
When set, it is just the name of the layout. This can be useful for debugging.
]])

define_property(GLOBAL PROPERTY IXM_CURRENT_LAYOUT_FILE
  BRIEF_DOCS "Path to layout file specified in `project(... LAYOUT <name>)`"
  FULL_DOCS [[
Path to the layout file loaded based on the name passed to the IXM `project()`
function override. When set, it means that `project()` was given the argument
`LAYOUT` and a file based on the given argument was discovered. This property
is provided for debugging purposes in the event that another tool has overriden
the project scoped variable
]])
