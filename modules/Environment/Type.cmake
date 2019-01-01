include_guard(GLOBAL)

include(CheckTypeSize)

function (check_type_size type variable)
  argparse(${ARGN}
    @FLAGS QUIET BUILTIN_ONLY
    @ARGS=1 LANGUAGE
    @ARGS=* FLAGS DEFINITIONS INCLUDES LIBRARIES HEADERS)
  cmake_push_check_state()
  set(CMAKE_REQUIRED_DEFINITIONS ${DEFINITIONS})
  set(CMAKE_REQUIRED_LIBRARIES ${LIBRARIES})
  set(CMAKE_REQUIRED_INCLUDES ${INCLUDES})
  set(CMAKE_REQUIRED_FLAGS ${FLAGS})
  set(CMAKE_EXTRA_INCLUDE_FILES ${HEADERS})

  if (BUILTIN)
    set(BUILTIN BUILTIN_TYPES_ONLY)
  endif()
  _check_type_size(${type} ${variable} ${BUILTIN} LANGUAGE ${LANGUAGE})
  cmake_pop_check_state()
endfunction()
