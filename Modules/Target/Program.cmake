include_guard(GLOBAL)

# TODO: Should support being given a project and package component
# TODO: emit a signal
function (ixm_target_program name)
  parse(${ARGN} @ARGS=? ALIAS)
  add_executable(${name})
  if (ALIAS)
    add_executable(${ALIAS} ALIAS ${name})
  endif()
endfunction()