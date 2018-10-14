set(CMAKE_Cython_COMPILER "C:/Program Files/Python37/Scripts/cython.exe")

configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeCythonCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeCythonCompiler.cmake
  @ONLY)
set(CMAKE_Cython_COMPILER_ENV_VAR "CYTHON")


