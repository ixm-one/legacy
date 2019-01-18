include(FindPackageHandleStandardArgs)

find_package(Python COMPONENTS Interpreter Development QUIET REQUIRED)
find_program(Cython_EXECUTABLE NAMES cython)

find_package_handle_standard_args(Cython REQUIRED_VARS Cython_EXECUTABLE)

if (NOT Cython_FOUND)
  return()
endif()

add_executable(cython IMPORTED GLOBAL)
add_executable(Python::Cython ALIAS cython)
set_target_properties(cython PROPERTIES IMPORTED_LOCATION ${Cython_EXECUTABLE})
