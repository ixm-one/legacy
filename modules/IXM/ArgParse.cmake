include_guard(GLOBAL)

include(ParentScope)
include(Print)
include(Dump)

function(argparse)
  cmake_parse_arguments(_ "" "PREFIX" "OPTIONS;VALUES;LISTS;ARGS" ${ARGN})
  if (NOT DEFINED __ARGS)
    error("Did not pass ARGS to argparse")
  endif()
  if (NOT DEFINED __PREFIX)
    set(__PREFIX ARG)
  endif()
  if (NOT DEFINED __OPTIONS)
    set(__OPTIONS)
  endif()
  if (NOT DEFINED __VALUES)
    set(__VALUE)
  endif()
  if (NOT DEFINED __LISTS)
    set(__LISTS)
  endif()

  cmake_parse_arguments(
    ${__PREFIX}
    "${__OPTIONS}"
    "${__VALUES}"
    "${__LISTS}"
    ${__ARGS})
  
  foreach (arg IN LISTS __OPTIONS __VALUES __LISTS ITEMS __UNPARSED_ARGUMENTS)
    if (DEFINED ${__PREFIX}_${arg})
      list(APPEND vars ${__PREFIX}_${arg})
    endif()
  endforeach()

  parent_scope(${vars})
endfunction()
