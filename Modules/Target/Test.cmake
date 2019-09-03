include_guard(GLOBAL)

# Will create a test via `add_test`
# If no program/command is given, we look for the target with the same name
# if not target exists, we create it. 
# TODO: We need to override how CTest works so that we can have `test` depend
# on building all tests!
function (ixm_target_test name)
  parse(${ARGN}
    @ARGS=? ALIAS WORKING_DIRECTORY
    @ARGS=* CONFIGURATIONS COMMAND)
  assign(alias ? ALIAS : ${name})
  add_executable(${name})
  add_test(NAME ${alias} COMMAND ${name})
  event(EMIT targe:test ${alias})
endfunction()