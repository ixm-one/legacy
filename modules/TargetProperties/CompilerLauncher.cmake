include_guard(GLOBAL)

define_property(GLOBAL
  PROPERTY IXM_COMPILER_LAUNCHERS
  BRIEF_DOCS "List of possible COMPILER_LAUNCHERS to set on a target"
  FULL_DOCS
[=[
This list of COMPILER_LAUNCHERS is used by `target_compiler_launcher` to
propertly select from any number of launchers to set. Each launcher name should
correspond to an executable, preferably one that has been imported to the
project.

These will be split apart when passed in, and set correctly. 

This property makes no attempt at enforcing the names set. It is up to the
command that reads from it to validate and verify its contents.
]=])

function (target_compiler_launcher target)
  set_target_properties(${target}
    PROPERTIES
      ${CXX_LAUNCHER}
      ${CC_LAUNCHER})
endfunction ()
