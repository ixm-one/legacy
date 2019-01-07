include_guard(GLOBAL)

include(CheckCXXCompilerFlag)
include(CheckCCompilerFlag)
include(CMakePushCheckState)

function (check_compiler_flag flag var)
  argparse(${ARGN}
    @FLAGS QUIET
    @ARGS=1 LANGUAGE)

  cmake_push_check_state()
  if (LANGUAGE STREQUAL "CXX")
    check_cxx_compiler(${flag} ${var})
  elseif (LANGUAGE STREQUAL "C")
    check_c_compiler(${flag} ${var})
  else()
    error("LANGUAGE must be either: CXX or C")
  endif()
  cmake_pop_check_state()
endfunction()
