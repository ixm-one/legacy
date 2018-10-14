include(CheckLanguauge)

check_language(CXX)
check_language(C)

if (NOT C AND NOT CXX)
  message(FATAL_ERROR "Cython cannot be enabled without C or C++ support")
endif()

if (CMAKE_C_COMPILER)
  set(CMAKE_Cython_CXX)
  set(CMAKE_Cython_COMPILE_SOURCE ${CMAKE_C_COMPILE_OBJECT})
endif()

if (CMAKE_CXX_COMPILER)
  set(CMAKE_Cython_CXX "--cplus")
  set(CMAKE_Cython_COMPILE_SOURCE ${CMAKE_CXX_COMPILE_OBJECT})
endif()


# CMake doesn't let us automatically set up the compiler dependencies, but
# luckily those files will stick around and if they change they need to be
# recompiled anyhow. So we just *append* another execution rule to ours.
# (Special thanks to Rob Maynard for pointing this out)
# Also, we're only ever going to support Python 3 or later :P
# OK, maybe not :v
set(CMAKE_Cython_COMPILE_OBJECT
  "<CMAKE_Cython_COMPILER> -3 ${CMAKE_Cython_CXX} <INCLUDES> <FLAGS> -o <OBJECT>")

list(APPEND CMAKE_Cython_COMPILER_OBJECT ${CMAKE_Cython_COMPILE_SOURCE})
