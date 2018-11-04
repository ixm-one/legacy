include_guard(GLOBAL)

include(ParentScope)

function(argparse)
  cmake_parse_arguments(_ "" "PREFIX" "OPTIONS;VALUES;GROUPS;ARGS" ${ARGN})
  if (NOT DEFINED __ARGS)
  if (NOT DEFINED __PREFIX)
    set(__PREFIX ARG)
  endif()
  if (NOT DEFINED __OPTIONS)
    set(__OPTIONS)
  endif()
  if (NOT DEFINED __VALUES)
    set(__VALUE)
  endif()
  if (NOT DEFINED __GROUPS)
    set(__GROUPS)
  endif()

  cmake_parse_arguments(
    ${__PREFIX}
    "${__OPTIONS}"
    "${__VALUES}"
    "${__GROUPS}"
    ${_ARGS})
  
  foreach (arg IN LISTS __OPTIONS __VALUES __GROUPS ITEMS __UNPARSED_ARGUMENTS)
    if (DEFINED ${_PREFIX}_${arg})
      list(APPEND vars ${_PREFIX}_${arg})
    endif()
  endforeach()

  parent_scope(${vars})
endfunction()
