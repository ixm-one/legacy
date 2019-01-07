include_guard(GLOBAL)

function (target_properties target)
  alias_of(${target} target)
  set_target_properties(${target} PROPERTIES ${ARGN})
endfunction()

function (set_target_properties)
  argparse(${ARGN} @ARGS=* PROPERTIES)
  foreach (target IN LISTS REMAINDER)
    alias_of(${target} target)
    list(APPEND targets ${target})
  endforeach()
  list(LENGTH PROPERTIES length)
  return(length EQUAL 1)
  _set_target_properties(${targets} PROPERTIES ${PROPERTIES})
endfunction()

