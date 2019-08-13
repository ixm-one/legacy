include_guard(GLOBAL)

# TODO: Handle setting colors via properties
# XXX: log settings should be stored as global properties, not variables?
# to make logging easier, each of error/warn/info/debug/trace should call the
# logging equivalent
# the current `debug` function should be renamed to `inspect`

# ERROR > WARN > INFO > DEBUG > TRACE
# FATAL | NOTICE are always shown
function (log level)
  list(APPEND levels NOTICE WARN ERROR FATAL INFO DEBUG TRACE)
  if (NOT level IN_LIST levels)
    log(FATAL "log(${level}) is not a supported logging level")
  endif()
  if (level STREQUAL "NOTICE")
    ixm_log_prepare(text ${ARGN})
    ixm_log_notice("${text}")
    return()
  elseif (level STREQUAL "FATAL")
    ixm_log_prepare(text ${ARGN})
    ixm_log_fatal("${text}")
    return()
  elseif (NOT ixm::log::level)
    return()
  endif()
  ixm_log_prepare(text ${ARGN})
  # XXX: There has to be a better way to check if we can log
  set(trace-levels DEBUG INFO WARN ERROR)
  set(debug-levels INFO WARN ERROR)
  set(info-levels WARN ERROR)
  set(warn-levels ERROR)
  if (level STREQUAL "TRACE" AND NOT (ixm::log::level IN_LIST trace-levels))
    ixm_log_trace(${text})
  elseif (level STREQUAL "DEBUG" AND NOT (ixm::log::level IN_LIST debug-levels))
    ixm_log_debug(${text})
  elseif (level STREQUAL "INFO" AND NOT (ixm::log::level IN_LIST info-levels))
    ixm_log_info(${text})
  elseif (level STREQUAL "WARN" AND NOT (ixm::log::level IN_LIST warn-levels))
    ixm_log_warn(${text})
  elseif (level STREQUAL "ERROR" AND ixm::log::level)
    ixm_log_error(${text})
  endif()
endfunction()

function (ixm_log_file text)
  file(APPEND "${CMAKE_BINARY_DIR}/IXM/Logs/${PROJECT_NAME}.log" "${text}\n")
endfunction()

function (ixm_log_out type color text)
  if (NOT ixm::log::color)
    unset(.${color})
    unset(.default)
  endif()
  message(${type} "${.${color}}${text}${.default}")
endfunction ()

function (ixm_log_prepare out-var)
  if (ixm::log::style STREQUAL "JSON")
    message(FATAL_ERROR "IXM does not currently support logging to JSON")
  elseif (ixm::log::style STREQUAL "STRUCTURED")
    message(FATAL_ERROR "IXM does not currently support structured logging")
  elseif (ixm::log::style STREQUAL "TEXT")
    list(JOIN ARGN " " string)
    set(${out-var} "${string}" PARENT_SCOPE)
  else()
    message(FATAL_ERROR "IXM does not currently support logging ${ixm\:\:log\:\:style}")
  endif()
endfunction()

function (ixm_log_debug text)
  ixm_log_file("[DEBUG]: ${text}")
  set(type "STATUS")
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.15)
    set(type DEBUG)
  endif()
  ixm_log_out(${type} cyan "DEBUG: ${text}")
endfunction()

function (ixm_log_warn text)
  string(TIMESTAMP time "[%Y-%m-%dT%H:%M:%S]")
  file(RELATIVE_PATH file "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_LIST_FILE}")
  ixm_log_file("${time} WARN: ${text}")
  ixm_log_out(STATUS default "${time} ${.gold}level${.default}=WARN ${.gold}file${.default}=${file} ${.gold}message${.default}=${text}")
endfunction()

# Prevents generation but *does not* stop processing
function (ixm_log_error)
  #ixm_log_file(${text})
endfunction()

# Immediately stops CMake from continuing
function (ixm_log_fatal text)
  ixm_log_file("${text}")
  ixm_log_out(FATAL_ERROR crimson "${text}")
endfunction()
