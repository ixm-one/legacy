include(CheckFindPackage)
include(ImportProgram)
include(PushFindState)
include(Halt)
include(Hide)

find_package(Python COMPONENTS Interpreter QUIET REQUIRED)

push_find_state(Cython)
find_program(Cython_EXECUTABLE NAMES cython ${FIND_OPTIONS})
pop_find_state()

check_find_package(Cython EXECUTABLE)
halt_unless(Cython EXECUTABLE)
hide(Cython EXECUTABLE)
import_program(cython LOCATION ${Cython_EXECUTABLE} GLOBAL)
add_executable(Python::Cython ALIAS cython)
