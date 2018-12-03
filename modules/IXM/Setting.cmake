include_guard(GLOBAL)

include(CMakeDependentOption)
include(Get)

function (setting variable)
  argparse(ARGS ${ARGN}
    VALUES DESCRIPTION
    LISTS REQUIRES)
  get(desc ARG_DESCRIPTION "${variable}")
  if (NOT ARG_REQUIRES)
    fatal("IXM::DL: setting must be passed a 'REQUIRES' parameter list")
  endif()
  cmake_dependent_option(${PROJECT_NAME}_${variable} ${desc} ON "${ARG_REQUIRES}" OFF)
endfunction()
