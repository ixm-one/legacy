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
  set(CMAKE_REQUIRED_QUIET OFF)
  if (ARG_QUIET)
    set(CMAKE_REQUIRED_QUIET ON)
  endif()
  check_include_files(${header} ${variable} LANGUAGE ${ARG_LANGUAGE})
  cmake_pop_check_state()
  parent_scope(${variable})
endfunction()
