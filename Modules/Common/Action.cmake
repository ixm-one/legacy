include_guard(GLOBAL)

function (ixm_action_find out-var)
  parse(${ARGN} @ARGS=1 COMMAND ACTION)
  string(TOLOWER "${ACTION}" action)
  string(TOLOWER "${COMMAND}" COMMAND)

  get_property(actions GLOBAL PROPERTY ixm::command::${COMMAND})
  if (NOT action IN_LIST actions)
    log(FATAL "${COMMAND}(${action}) is not a valid subcommand")
  endif()

  get_property(command GLOBAL PROPERTY ixm::${COMMAND}::${action})
  if (NOT command OR NOT COMMAND ${command})
    log(FATAL "'ixm::${COMMAND}::${action}' does not refer to a valid command")
  endif()
  set(${out-var} ${command} PARENT_SCOPE)
endfunction()
