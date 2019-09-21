include_guard(GLOBAL)

import(IXM::Common::Action)
import(IXM::Common::Dict)
import(IXM::Common::Glob)

#[[
All commands contained in this API file are for authoring commands with.
Hence the file's name :)
]]

# Used to locate a command's subactions
function (action @action:result)
  parse(${ARGN} @ARGS=1 FIND FOR)
  aspect(GET "${FOR}:${FIND}" AS @action:command)
  if (NOT @action:command)
    log(FATAL "${FOR}(${FIND}) is not a valid subcommand")
  endif()
  if (NOT COMMAND "${\@action\:command}")
    log(FATAL "Aspect for ${FOR}(${FIND}) does not refer to a valid command")
  endif()
  set(${\@action\:result} ${\@action\:command} PARENT_SCOPE)
endfunction()

#[[
set(), but with fallbacks. Fancier ternary
assign(<var> ? LOOKUP1 LOOKUP2 [: "DEFAULT" "VALUES"])
]]
function (assign @assign:result)
  void(? :)
  parse(${ARGN} @ARGS=* ? :)
  foreach (@assign:value IN LISTS ?)
    if (DEFINED ${\@assign\:value})
      set(${\@assign\:result} ${${\@assign\:value}} PARENT_SCOPE)
      return()
    endif()
  endforeach()
  if (DEFINED :)
    set(${\@assign\:result} ${\:} PARENT_SCOPE)
  endif()
endfunction()

#[[
Unsets all variables in the calling scope
]]
macro(void)
  foreach (@void ${ARGV})
    unset(${\@void})
  endforeach()
endmacro()

#[[
This function is used to condense a multiline generator expression into a
single line. If a newline is needed make sure the entire generator expression
section is a "quoted" argument

TODO: Consider expanding its usage to generate two TARGET_PROPERTY expressions.
This could be done by having a [PROPERTY <property>] argument. If present,
we can run string(CONFIGURE @ONLY) on the expression. This would allow us to
generate an interface and private property lookup in one statement.
This would save a TON of time.
]]
function (genexp @genexp:result)
  if (NOT ARGN)
    log(FATAL "genexp() requires at least one parameter")
  endif()
  string(REPLACE ";" "" genexp ${ARGN})
  set(${\@genexp\:result} "${genexp}" PARENT_SCOPE)
endfunction()

#[[ Allows dynamically calling a CMake command ]]
function (invoke name)
  if (NOT COMMAND ${name})
    log(FATAL "Cannot call invoke() with non-existant command '${name}'")
  endif()
  aspect(GET path:invoke AS @invoke:directory)
  set(call "${\@invoke\:directory}/${name}.cmake")
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
  set(multi @FLAGS
            @ARGS=? @ARGS=* @ARGS=+
            @ARGS=1 @ARGS=2 @ARGS=3
            @ARGS=4 @ARGS=5 @ARGS=6
            @ARGS=7 @ARGS=8 @ARGS=9)
  if (ARGC EQUAL 0)
    log(FATAL "Did you forget to pass ARGN to parse?")
  endif()
  cmake_parse_arguments(_ "" "@PREFIX" "${multi}" ${ARGN})

  set(ARGS ${__\@ARGS\=1} ${__\@ARGS\=\?})
  foreach (N RANGE 2 9)
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

  foreach (arg IN LISTS __\@ARGS\=\+)
    list(LENGTH ARG_${arg} length)
    if (length LESS 1)
      log(FATAL "argument '${arg}': expected *at least one* argument")
    endif()
    set(${__\@PREFIX}${arg} ${ARG_${arg}} PARENT_SCOPE)
  endforeach()

  foreach (N RANGE 1 9)
    foreach (arg IN LISTS __\@ARGS\=${N})
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
  print("${.lime}${ARGN}${.reset}")
endfunction()

#[[ Used to indicate failure within the check() API ]]
function (failure)
  print("${.crimson}${ARGN}${.reset}")
endfunction()

# [[ It's been kept around for a while, but we don't *really* need it ]]
#[[ Use log(NOTICE) instead ]]
function(print)
  list(JOIN ARGN " " text)
  message(STATUS "${text}")
endfunction()
