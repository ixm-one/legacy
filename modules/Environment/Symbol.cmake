include_guard(GLOBAL)

include(CheckCXXSymbolExists)
include(CheckSymbolExists)

function (check_symbol_exists symbol variable)
  argparse(
    @FLAGS QUIET
    @ARGS=1 LANGUAGE
    @ARGS=* FLAGS DEFINITIONS INCLUDES LIBRARIES HEADERS)
  cmake_push_check_state()
  set(CMAKE_REQUIRED_DEFINITIONS ${DEFINITIONS})
  set(CMAKE_REQUIRED_LIBRARIES ${LIBRARIES})
  set(CMAKE_REQUIRED_INCLUDES ${INCLUDES})
  set(CMAKE_REQUIRED_FLAGS ${FLAGS})
  get(CMAKE_REQUIRED_QUIET QUIET OFF)
  if (LANGUAGE STREQUAL "CXX")
    check_cxx_symbol_exists(${symbol} "${HEADERS}" ${variable})
  elseif (LANGUAGE STREQUAL "C")
    _check_symbol_exists(${symbol} "${HEADERS}" ${variable})
  else()
    fatal("LANGUAGE parameter must be either: CXX or C")
  endif()
  cmake_pop_check_state()
endfunction()
