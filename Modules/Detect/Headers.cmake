include_guard(GLOBAL)

include(CMakePushCheckState)
include(CheckIncludeFiles)

function (ixm_check_header header)
  ixm_parse(${ARGN}
    @FLAGS QUIET
    @ARGS=1 LANGUAGE
    @ARGS=* FLAGS DEFINITIONS INCLUDES LIBRARIES)
  string(MAKE_C_IDENTIFIER ${header} variable)
  cmake_push_check_state()
  set(CMAKE_REQUIRED_DEFINITIONS ${DEFINITIONS})
  set(CMAKE_REQUIRED_LIBRARIES ${LIBRARIES})
  set(CMAKE_REQUIRED_INCLUDES ${INCLUDES})
  set(CMAKE_REQUIRED_FLAGS ${FLAGS})
  ixm_var(CMAKE_REQUIRED_QUIET QUIET OFF)
  check_include_files(${header} ${variable} LANGUAGE ${LANGUAGE})
  cmake_pop_check_state()
endfunction()
