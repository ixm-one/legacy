include_guard(GLOBAL)

include(CMakeDependentOption)

function (option variable description)
  ixm_parse(${ARGN}
    @FLAGS PROJECT
    @ARGS=* REQUIRES)
  if (PROJECT)
    set(variable ${PROJECT_NAME}_${variable})
  endif()
  if (NOT REQUIRES)
    _option(${variable} ${description} ${REMAINDER})
  else()
    cmake_dependent_option(${variable} ${description} ON "${REQUIRES}" OFF)
  endif()
endfunction()
