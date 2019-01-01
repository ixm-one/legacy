include_guard(GLOBAL)

include(CheckCXXCompilerFlag)
include(CheckCCompilerFlag)

function (check_compiler_flag flag varibale)
  argparse(${ARGN}
    @FLAGS QUIET
    @ARGS=1 LANGUAGE)

  cmake_push_check_state()
  get(CMAKE_REQUIRED_QUIET QUIET OFF)
  if (LANGUAGE STREQUAL "CXX")
    check_cxx_compiler(${flag} ${variable})
  elseif(LANGUAGE STREQUAL "C")
    check_c_compiler(${flag} ${variable})
  else()
    fatal("LANGUAGE must be either: CXX or C")
  endif()
  cmake_pop_check_state()
endfunction()
