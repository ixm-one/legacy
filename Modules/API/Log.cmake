include_guard(GLOBAL)

import(IXM::Log::*)

#[[
ERROR > WARN > INFO > DEBUG > TRACE
PANIC, FATAL, NOTICE are always shown in the log. Whether they are displayed
is dependent on the ixm::print::quiet property

# TODO: We should use the event system for logging. It'll be more flexible this
# way.
]]

# TODO:
event(ADD ixm_log_info_output ixm_log_info_file TO log:info)
event(ADD ixm_log_warn_output ixm_log_file TO log:warn)

function (log level)
  attribute(GET current NAME log:level)
  list(APPEND levels PANIC FATAL NOTICE ERROR WARN INFO DEBUG TRACE)
  if (NOT level IN_LIST levels)
    log(FATAL "log(${level}) is not a supported logging level")
  endif()
  if (level STREQUAL "NOTICE")
    ixm_log_prepare(text ${ARGN})
    ixm_log_notice("${text}")
# IXM API Directory Locations
    return()
  elseif (level STREQUAL "FATAL")
    #event(EMIT log:fatal ${ARGN})
    ixm_log_prepare(text ${ARGN})
    ixm_log_fatal("${text}")
  elseif (level STREQUAL "PANIC")
    #event(EMIT log:panic ${ARGN})
    ixm_log_panic(${ARGN})
    return()
  elseif (NOT current)
    return()
  endif()
  ixm_log_prepare(text ${ARGN})
  # XXX: There has to be a better way than this...
  set(trace-levels DEBUG INFO WARN ERROR)
  set(debug-levels INFO WARN ERROR)
  set(info-levels WARN ERROR)
  set(warn-levels ERROR)
  if (level STREQUAL "TRACE" AND NOT (current IN_LIST trace-levels))
    ixm_log_trace(${text})
  elseif (level STREQUAL "DEBUG" AND NOT (current IN_LIST debug-levels))
    ixm_log_debug(${text})
  elseif (level STREQUAL "INFO" AND NOT (current IN_LIST info-levels))
    event(EMIT log:info "${text}")
  elseif (level STREQUAL "WARN" AND NOT (current IN_LIST warn-levels))
    event(EMIT log:warn "${text}")
  elseif (level STREQUAL "ERROR")
    ixm_log_error(${text})
  endif()
endfunction()

function (ixm_log_rotate)
endfunction()

function (ixm_log_out type color text)
  get_property(pretty-output GLOBAL PROPERTY ixm::log::color)
  if (NOT pretty-output)
    unset(.${color})
    unset(.default)
  endif()
  message(${type} "${.${color}}${text}${.default}")
endfunction ()

#[[TODO: Handle rotation of files]]
function (ixm_log_file text)
  attribute(GET directory NAME path:log DOMAIN ixm)
  file(APPEND "${directory}/${PROJECT_NAME}.log" "${text}\n")
endfunction()

# TODO:
# 1) Add support for JSON
# 2) Add support for 'structured' (x=y) logging
# 3) Add support for CSV output
function (ixm_log_prepare out-var)
  get_property(strftime GLOBAL PROPERTY ixm::log::strftime)
  get_property(format GLOBAL PROPERTY ixm::log::format)
  string(TIMESTAMP time "${strftime}")
  file(RELATIVE_PATH file "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_LIST_FILE}")
  list(JOIN ARGN " " string)
  if (format STREQUAL "JSON")
    message(FATAL_ERROR "IXM does not currently support logging to JSON")
  elseif (format STREQUAL "STRUCTURED")
    message(FATAL_ERROR "IXM does not currently support structured logging")
  elseif (format STREQUAL "TEXT")
    set(${out-var} "[${time}] ${level}: ${string}" PARENT_SCOPE)
  else()
    message(FATAL_ERROR "IXM does not currently support logging to '${format}'")
  endif()
endfunction()

function (ixm_log_info_output text)
  ixm_log_out(STATUS steel-blue "${text}")
endfunction()

function (ixm_log_warn_output text)
  ixm_log_out(STATUS gold "${text}")
endfunction()

function (ixm_log_info_file text)
  ixm_log_file("${text}")
endfunction()

function (ixm_log_info text)
  event(EMIT log:info "steel-blue" "${text}")
#  ixm_log_file("${text}")
#  ixm_log_out(STATUS steel-blue "${text}")
endfunction()

function (ixm_log_warn text)
  ixm_log_file("${text}")
  ixm_log_out(STATUS gold "${text}")
endfunction()

function (ixm_log_error text)
endfunction ()

function (ixm_log_notice text)
  ixm_log_file("${text}")
endfunction()
