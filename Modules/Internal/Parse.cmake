include_guard(GLOBAL)

# TODO: Verify a difference between ARGS=* and ARGS=+
#[[
SYNOPSIS
  ixm_parse(${ARGN}
    [@PREFIX prefix] # if not given, default arg prefix is actually "", not _
    [@FLAGS args...] # Flags
    [@ARGS=? args...] # single values
    [@ARGS=1 args...] # single values with VERIFICATION on being passed
    [@ARGS=* args...] # Optional lists
    [@ARGS=+ args...] # Lists of at LEAST one argument. Will hard error if no arguments
    [@ARGS=N args...] # Args of exactly N arguments. Fatal if N is not exactly passed.
  )
DESCRIPTION
  All arguments passed to argparse follow the same style of naming found in
  python's nargs for it's argparse, except the 'nargs=' is declared with an '@'
  Types are ignored, as are settings such as METAVAR or --help guides. Them's
  the breaks!

  OPTIONS
    ${ARGN} -- Write this to specify the ARGS passed to argparse...
    @PREFIX -- Prefix all arguments variables with this value. Regardless of
               whether it is given, we break from CMake's previous behavior and
               don't prefix variables with an underscore ever.
    @FLAGS -- These are just boolean flags. If there was a better syntax to
              represent true/false as arguments, I would use it

    @ARGS=1 -- Required single value arguments.
    @ARGS=N -- N (where N is 1 < N < 10) number of arguments. These are
               collected into a list
    @ARGS=+ -- Required multi value arguments.
    @ARGS=? -- Optional single value arguments. These usually have a default if
               not set.
    @ARGS=* -- Optional multi value arguments. These usually have a default if
               not set.
]]
function(ixm_parse)
  get(max IXM_MAX_NARGS 9)
  list(APPEND multi "@FLAGS")
  foreach (N RANGE 1 ${max})
    list(APPEND multi "@ARGS=${N}")
  endforeach()
  foreach (var IN ITEMS + ? *)
    list(APPEND multi "@ARGS=${var}")
  endforeach()
  if (ARGC EQUAL 0)
    error("Did you forget to pass ARGN to argparse?")
  endif()
  cmake_parse_arguments(_ "" "@PREFIX" "${multi}" ${ARGN})

  set(ARGS ${__\@ARGS\=1} ${__\@ARGS\=\?})

  foreach (N RANGE 2 ${max})
    list(APPEND NARGS ${__\@ARGS\=${N}})
  endforeach()
  list(APPEND NARGS ${__\@ARGS\=\*} ${__\@ARGS\=\+})

  cmake_parse_arguments(
    ARG
    "${__\@FLAGS}"
    "${ARGS}"
    "${NARGS}"
    ${__UNPARSED_ARGUMENTS})

  foreach (arg IN LISTS __\@FLAGS ARGS __\@ARGS\=\*)
    if (DEFINED ARG_${arg})
      set(${__\@PREFIX}${arg} ${ARG_${arg}} PARENT_SCOPE)
    endif()
  endforeach()

  # TODO: Might want to make this a macro, given its complexity
  foreach (arg IN LISTS __\@ARGS\=\+)
    if (NOT DEFINED ARG_${arg}) # This is needed to mimic the python argparse
      continue()
    endif()
    list(LENGTH ARG_${arg} length)
    if (length LESS 1)
      error("argument '${arg}': expected at least one argument")
    endif()
  endforeach()

  foreach (N RANGE 1 ${max})
    foreach (arg IN LISTS __\@ARGS\=${N})
      if (NOT DEFINED ARG_${arg})
        continue()
      endif()
      list(LENGTH ARG_${arg} length)
      if (length EQUAL ${N})
        set(${__\@PREFIX}${arg} ${ARG_${arg}} PARENT_SCOPE)
      else()
        error("argument '${arg}': expected ${N} argument(s)")
      endif()
    endforeach()
  endforeach()

  if (DEFINED ARG_UNPARSED_ARGUMENTS)
    set(${__\@PREFIX}REMAINDER ${ARG_UNPARSED_ARGUMENTS} PARENT_SCOPE)
  endif()
endfunction()
