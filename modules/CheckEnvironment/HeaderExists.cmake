include_guard(GLOBAL)

include(CMakePushCheckState)
include(CheckIncludeFiles)

function (check_header header variable)
  argparse(OPTIONS QUIET
    VALUES LANGUAGE
    GROUPS FLAGS DEFINITIONS INCLUDES LIBRARIES ${ARGN})
  cmake_push_check_state()
  set(CMAKE_REQUIRED_DEFINITIONS ${ARG_DEFINITIONS})
  set(CMAKE_REQUIRED_LIBRARIES ${ARG_LIBRARIES})
  set(CMAKE_REQUIRED_INCLUDES ${ARG_INCLUDES})
  set(CMAKE_REQUIRED_FLAGS ${ARG_FLAGS})
  get(CMAKE_REQUIRED_QUIET ARG_QUIET OFF)
  check_include_files(${header} ${variable} LANGUAGE ${ARG_LANGUAGE})
  cmake_pop_check_state()
  parent_scope(${variable})
endfunction()
