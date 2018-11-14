include_guard(GLOBAL)

include(CMakePushCheckState)
include(CheckTypeSize)

function (check_type_exists type variable)
  argparse(OPTIONS QUIET BUILTIN
    VALUES LANGUAGE
    GROUPS FLAGS DEFINITIONS INCLUDES LIBRARIES HEADERS)
  cmake_push_check_state()
  set(CMAKE_REQUIRED_DEFINITIONS ${ARG_DEFINITIONS})
  set(CMAKE_REQUIRED_LIBRARIES ${ARG_LIBRARIES})
  set(CMAKE_REQUIRED_INCLUDES ${ARG_INCLUDES})
  set(CMAKE_REQUIRED_FLAGS ${ARG_FLAGS})
  set(CMAKE_EXTRA_INCLUDE_FILES ${ARG_HEADERS})
  get(CMAKE_REQUIRE_QUIET ARG_QUIET OFF)

  if (ARG_BUILTIN)
    set(ARG_BUILTIN BUILTIN_TYPES_ONLY)
  endif()
  check_type_size(${type} ${variable} ${ARG_BUILTIN} LANGUAGE ${ARG_LANGUAGE})
  cmake_pop_check_state()
  parent_scope(${variable})
endfunction()
