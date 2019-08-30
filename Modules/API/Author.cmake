include_guard(GLOBAL)

import(IXM::Common::Action)
import(IXM::Common::Dict)
import(IXM::Common::Glob)

#[[
All commands contained in this API file are for authoring commands with.
Hence the file's name :)
]]

#[[
set(), but with fallbacks. Fancier ternary
assign(<var> ? LOOKUP1 LOOKUP2 : "DEFAULT" "VALUES")
]]
function (assign out-var)
  parse(${ARGN} @ARGS=* ? :)
  foreach (@value IN LISTS ?)
    if (DEFINED ${\@value})
      set(${out-var} ${${\@value}} PARENT_SCOPE)
      return()
    endif()
  endforeach()
  set(${out-var} ${\:} PARENT_SCOPE)
endfunction()

#[[
This function is used to condense a multiline generator expression into a
single line. If a newline is needed make sure the entire generator expression
section is a "quoted" argument
]]
function (genexp out-var)
  if (NOT ARGN)
    log(FATAL "genexp() requires at least one parameter")
  endif()
  string(REPLACE ";" "" genexp ${ARGN})
  set(${out-var} "${genexp}" PARENT_SCOPE)
endfunction()

#[[ Allows dynamically calling a CMake command ]]
function (invoke name)
  if (NOT COMMAND ${name})
    log(FATAL "Cannot call invoke() with non-existant command '${name}'")
  endif()
  attribute(GET directory NAME path:invoke DOMAIN ixm)
  set(call "${directory}/${name}.cmake")
  if (NOT EXISTS "${call}")
    string(CONFIGURE [[@name@(${ARGN})]] content @ONLY)
    file(WRITE "${call}" "${content}")
  endif()
  locals(old-locals)
  include(${call})
  locals(current)
  list(REMOVE_ITEM current ${old-locals} old-locals)
  foreach (var IN LISTS current)
    set(${var} ${${var}} PARENT_SCOPE)
  endforeach()
endfunction()

#[[
DESCRIPTION
  All arguments passed to parse follow the same style of naming found in
  python's nargs for it's parse, except the 'nargs=' is declared with an '@'
  Types are ignored, as are settings such as METAVAR or --help guides. Them's
  the breaks!

  OPTIONS
    ${ARGN} -- Write this to specify the ARGS passed to parse...
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
function(parse)
  get_property(max GLOBAL PROPERTY ixm::parse::max)
  if (NOT max)
    set(max 9)
  endif()
  list(APPEND multi "@FLAGS")
  foreach (N RANGE 1 ${max})
    list(APPEND multi "@ARGS=${N}")
  endforeach()
  foreach (var IN ITEMS + ? *)
    list(APPEND multi "@ARGS=${var}")
  endforeach()
  if (ARGC EQUAL 0)
    log(FATAL "Did you forget to pass ARGN to parse?")
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
    if (NOT DEFINED ARG_${arg}) # This is needed to mimic the python parse
      continue()
    endif()
    list(LENGTH ARG_${arg} length)
    if (length LESS 1)
      log(FATAL "argument '${arg}': expected at least one argument")
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
        log(FATAL "argument '${arg}': expected ${N} argument(s)")
      endif()
    endforeach()
  endforeach()

  unset(${__\@PREFIX}REMAINDER PARENT_SCOPE)
  if (DEFINED ARG_UNPARSED_ARGUMENTS)
    set(${__\@PREFIX}REMAINDER ${ARG_UNPARSED_ARGUMENTS} PARENT_SCOPE)
  endif()
endfunction()

#[[ Used to indicate success within the check() API ]]
function(success)
  print("${.lime}${ARGN}${.default}")
endfunction()

#[[ Used to indicate failure within the check() API ]]
function (failure)
  print("${.crimson}${ARGN}${.default}")
endfunction()

# [[ It's been kept around for a while, but we don't *really* need it ]]
function(print)
  list(JOIN ARGN " " text)
  message(STATUS "${text}")
endfunction()
