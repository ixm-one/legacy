include_guard(GLOBAL)

# Will create a test via `add_test`
# If no program/command is given, we look for the target with the same name
# if not target exists, we create it. 
# TODO: We need to override how CTest works so that we can have `test` depend
# on building all tests!
function (ixm_target_test name)
  void(ALIAS WORKING_DIRECTORY CONFIGURATIONS COMMAND)
  parse(${ARGN}
    @ARGS=? ALIAS WORKING_DIRECTORY
    @ARGS=* CONFIGURATIONS COMMAND)
  assign(alias ? ALIAS : ${name})
  add_executable(${name})
  add_test(NAME ${alias} COMMAND ${name})
  if (NOT "${alias}" STREQUAL "${name}")
    add_executable(${alias} ALIAS ${name})
  endif()
  event(EMIT targe:test ${alias})
endfunction()
