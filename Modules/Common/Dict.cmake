include_guard(GLOBAL)

#[[
A few small notes on serialization:

Because we are treating this data in a hierarchical way, we need to specify
a way to "escape" the way that CMake handles lists. This, as it turns out,
is quite easy, since we can simply use the FS, GS, RS, US control codes from
ascii/unicode. Thus, if we wanted, we can generate a massive database file.
We aren't doing this *yet* but suffice to say, most of this could be done at
generation time, minus a few housekeeping tricks. This "database" file could
then be passed off to additional build tools if desired by the user, as it's
all just bytes and therefore quite simple to parse out. This might turn out to
be unwiedly in large projects, but that's not really my problem now.

I should note, this is separate from a user's ability to just dump a dict() to
disk without giving a damn.

Effectively, the layout of a database file looks like so:

␜${filename}␝${target::name}␞${key}␟value␟value␟value␟value␞${key}␟value␟value
␟value␟value␞${key}␟value␟value␟value␟value␞${key}␟value␟value␞${key}␟value
␟value␟value␟value␞${key}␟value␟value␞${key}␟value␟value␟value␟value␞${key}
␟value␟value␞${key}␟value␟value␟value␟value␞${key}␟value␟value␞${key}␟value
␟value␟value␟value␞${key}␟value␟value␞${key}␟value␟value␟value␟value␞${key}
␟value␟value␞${key}␟value␟value␟value␟value␞${key}␟value␟value␝${target::name}
␞${key}␟value␟value␟value␟value␞${key}␟value␟value
␟value␟value␞${key}␟value␟value␟value␟value␞${key}␟value␟value␞${key}␟value
␟value␟value␟value␞${key}␟value␟value␞${key}␟value␟value␟value␟value␞${key}
␟value␟value␞${key}␟value␟value␟value␟value␞${key}␟value␟value␞${key}␟value
␟value␟value␟value␞${key}␟value␟value␞${key}␟value␟value␟value␟value␞${key}
␟value␟value␞${key}␟value␟value␟value␟value␞${key}␟value␟value

This is quite easy to work with in the space of CMake's control flow
capabilities and builtin data structures.
]]

function (dict action name)
  if (action STREQUAL LOAD)
    ixm_dict_load(${name} ${ARGN})
  elseif (action STREQUAL SAVE)
    ixm_dict_save(${name} ${ARGN})
  elseif (action STREQUAL TRANSFORM)
    error("dict(TRANSFORM) is not yet implemented")
  elseif (action STREQUAL INSERT)
    ixm_dict_insert(${name} ${ARGN})
  elseif (action STREQUAL REMOVE)
    ixm_dict_remove(${name} ${ARGN})
  elseif (action STREQUAL MERGE)
    ixm_dict_merge(${name} ${ARGN})
  elseif (action STREQUAL KEYS)
    ixm_dict_keys(${name} ${ARGN})
  elseif (action STREQUAL GET)
    ixm_dict_get(${name} ${ARGN})
  else()
    error("dict(${action}) is an invalid operation")
  endif()
  set(returns KEYS GET)
  if (action IN_LIST returns)
    list(GET ARGN -1 out)
    upvar(${out})
  endif()
endfunction()

macro (ixm_dict_noop name)
  if (NOT TARGET ${name})
    return()
  endif()
endmacro()

function (ixm_dict_create name)
  if (NOT TARGET ${name})
    add_library(${name} INTERFACE IMPORTED)
  endif()
endfunction()

function (ixm_dict_filepath out path)
  if (NOT path MATCHES ".+[.]ixm$")
    set(path "${path}.ixm")
  endif()
  if (NOT IS_ABSOLUTE "${path}")
    set(path "${CMAKE_CURRENT_BINARY_DIR}/${path}")
  endif()
  set(${out} "${path}" PARENT_SCOPE)
endfunction()

function (ixm_dict_how var message)
  if (NOT ARGN)
    error("${message}")
  endif()
  set(valid APPEND ASSIGN STRING)
  list(GET ARGN 0 possible)
  if (NOT possible IN_LIST valid)
    unset(${var} PARENT_SCOPE)
    return()
  endif()
  list(REMOVE_AT ARGN 0)
  upvar(ARGN)
  if (possible STREQUAL STRING)
    set(possible APPEND_STRING)
  elseif (possible STREQUAL ASSIGN)
    set(possible)
  endif()
  set(${var} ${possible} PARENT_SCOPE)
endfunction()

function (ixm_dict_load name)
  parse(${ARGN} @ARGS=1 FROM)
  ixm_dict_create(${name})
  if (NOT FROM)
    error("dict(LOAD) missing 'FROM' parameter")
  endif()
  ixm_dict_filepath(FROM "${FROM}")
  if (NOT EXISTS "${FROM}")
    return()
  endif()
  file(READ "${FROM}" data)
  string(ASCII 2 STX)
  string(ASCII 3 ETX)
  string(ASCII 25 EM)
  set(HEADER "${STX}IXM${ETX}${STX}([^${ETX}]+)${ETX}${EM}")
  string(REGEX MATCH "^${HEADER}\n(.*)$" matched "${data}")
  if (NOT matched)
    error("Could not read IXM file format from ${FROM}")
  endif()
  set(data "${CMAKE_MATCH_2}")
  string(ASCII 29 group)
  string(ASCII 30 record)
  string(ASCII 31 unit)
  string(REPLACE "${group}" ";" data "${data}")
  foreach (entry IN LISTS data)
    string(REPLACE "${record}" ";" entry "${entry}")
    list(GET entry 0 key)
    list(GET entry 1 val)
    string(REPLACE "${unit}" ";" val "${val}")
    dict(INSERT ${name} ${key} ${val})
  endforeach()
endfunction()

function (ixm_dict_save name)
  parse(${ARGN} @ARGS=1 INTO)
  if (NOT INTO)
    error("dict(SAVE) missing 'INTO' parameter")
  endif()
  ixm_dict_noop(${name})
  dict(KEYS ${name} keys)
  string(ASCII 29 group)
  string(ASCII 30 record)
  string(ASCII 31 unit)
  foreach (key IN LISTS keys)
    dict(GET ${name} ${key} value)
    if (value)
      string(REPLACE ";" "${unit}" value "${value}")
      list(APPEND output "${key}${record}${value}")
    endif()
  endforeach()
  list(JOIN output "${group}" output)
  ixm_dict_filepath(INTO "${INTO}")
  string(ASCII 2 STX)
  string(ASCII 3 ETX)
  string(ASCII 25 EM)
  file(WRITE ${INTO} "${STX}IXM${ETX}${STX}v1${ETX}${EM}\n${output}")
endfunction()

# Like list(TRANSFORM), but on a key
# TODO: Add parent-scope to dict() for transform command
function (ixm_dict_transform name key)
  if (NOT TARGET ${name})
    return()
  endif()
  dict(GET ${name} ${key} values)
  if (NOT values)
    return()
  endif()
  list(TRANSFORM values ${ARGN})
  dict(INSERT ${name} ${key} ASSIGN ${values})
  parse(${ARGN} @ARGS=? OUTPUT_VARIABLE)
  if (OUTPUT_VARIABLE)
    set(${OUTPUT_VARIABLE} ${${OUTPUT_VARIABLE}} PARENT_SCOPE)
  endif()
endfunction()

#dict(INSERT <dict> key [STRING|APPEND|ASSIGN] <value> [<value>...])
function (ixm_dict_insert name key)
  set(message "dict(INSERT) requires at least one value to be inserted")
  ixm_dict_how(action "${message}" ${ARGN})
  ixm_dict_create(${name})
  set_property(TARGET ${name} ${action} PROPERTY "INTERFACE_${key}" ${ARGN})
  # This is for some basic bookkeeping.
  dict(KEYS ${name} keys)
  list(FIND keys ${key} index)
  if (index EQUAL -1)
    string(ASCII 192 c0)
    set_property(TARGET ${name} APPEND PROPERTY "INTERFACE_${c0}" "${key}")
  endif()
endfunction()

function (ixm_dict_remove name)
  if (NOT ARGN)
    error("dict(REMOVE) requires at least one key to be removed")
  endif()
  ixm_dict_noop(${name})
  dict(KEYS ${name} keys)
  list(REMOVE_ITEM keys ${$ARGN})
  set_property(TARGET ${name} PROPERTY "INTERFACE_${c0}" ${keys})
  foreach (key IN LISTS ARGN)
    set_property(TARGET ${name} PROPERTY "INTERFACE_${key}")
  endforeach()
endfunction()

function (ixm_dict_merge name)
  set(message "dict(MERGE) requires at least one existing to be merged in")
  ixm_dict_how(action "${message}" ${ARGN})
  ixm_dict_create(${name})
  foreach (target IN LISTS ARGN)
    dict(KEYS ${target} keys)
    foreach (key IN LISTS keys)
      dict(GET ${target} ${key} value)
      dict(INSERT ${name} "${key}" ${action} "${value}")
    endforeach()
  endforeach()
endfunction()

function (ixm_dict_keys name var)
  ixm_dict_noop(${name})
  # This is a valid *byte* but is an invalid utf-8 character :)
  string(ASCII 192 c0)
  dict(GET ${name} ${c0} value)
  set(${var} ${value} PARENT_SCOPE)
endfunction()

function (ixm_dict_get name key var)
  ixm_dict_noop(${name})
  get_property(value TARGET ${name} PROPERTY "INTERFACE_${key}")
  set(${var} ${value} PARENT_SCOPE)
endfunction()
