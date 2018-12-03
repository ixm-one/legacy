include_guard(GLOBAL)

include(ParentScope)
include(Print)
include(Dump)

function(argparse)
  cmake_parse_arguments(_ "" "ARGPREFIX" "OPTIONS;VALUES;LISTS;ARGS" ${ARGN})
  if (NOT DEFINED __ARGS)
    error("Did not pass ARGS to argparse")
  endif()
  if (NOT DEFINED __ARGPREFIX)
    set(__ARGPREFIX ARG)
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
    ${__ARGPREFIX}
    "${__OPTIONS}"
    "${__VALUES}"
    "${__LISTS}"
    ${__ARGS})

  foreach (arg IN LISTS __OPTIONS __VALUES __LISTS ITEMS UNPARSED_ARGUMENTS)
    if (DEFINED ${__ARGPREFIX}_${arg})
      list(APPEND vars ${__ARGPREFIX}_${arg})
    endif()
  endforeach()

  parent_scope(${vars})
endfunction()
