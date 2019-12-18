include_guard(GLOBAL)

#[[
All commands contained in this API file are for authoring commands with.
Hence the file's name :)
]]

#[[
  aspect(GET <aspect> AS <variable>)
  aspect(SET <aspect> WITH <value>...)
]]
function(aspect action name)
  void(WITH AS)
  if (action STREQUAL "SET")
    parse(${ARGN} @ARGS=+ WITH)
    string(TOLOWER "${name}" name)
    set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY 🈯::${name} ${WITH})
  elseif (action STREQUAL "GET")
    parse(${ARGN} @ARGS=? AS)
    assign(as ? AS : "${name}")
    string(TOLOWER "${name}" name)
    get_property(current DIRECTORY PROPERTY 🈯::${name})
    get_property(root DIRECTORY "${CMAKE_SOURCE_DIR}" PROPERTY 🈯::${name})
    if (DEFINED PROJECT_SOURCE_DIR)
      get_property(project DIRECTORY "${PROJECT_SOURCE_DIR}" PROPERTY 🈯::${name})
    endif()
    get_property(ixm DIRECTORY "${ixm_SOURCE_DIR}" PROPERTY 🈯::${name})
    assign(value ? root project current ixm)
    if (NOT DEFINED value)
      return()
    endif()
    set(${as} ${value} PARENT_SCOPE)
  endif()
endfunction()
#[[
set(), but with fallbacks. Fancier ternary
assign(<var> ? LOOKUP1 LOOKUP2 [: "DEFAULT" "VALUES"])
]]
function (assign result)
  void(? :)
  parse(${ARGN} @ARGS=* ? :)
  matches(?)
  foreach (value IN LISTS ?)
    if (DEFINED ${value})
      if ("${value}" MATCHES "^ENV{([^}]+)}$")
        set(${result} $ENV{${CMAKE_MATCH_1}} PARENT_SCOPE)
      elseif (value MATCHES "^CACHE{([^}]+)}$")
        set(${result} $CACHE{${CMAKE_MATCH_1}} PARENT_SCOPE)
      else()
        set(${result} ${${value}} PARENT_SCOPE)
      endif()
      return()
    endif()
  endforeach()
  if (DEFINED :)
    set(${result} ${\:} PARENT_SCOPE)
  endif()
endfunction()

#[[ Unsets all variables in the calling scope ]]
macro(void)
  foreach (@void ${ARGV})
    unset(${\@void})
  endforeach()
endmacro()

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
