include(CheckFindPackage)
include(ImportProgram)
include(PushFindState)
include(Halt)
include(Hide)

find_package(Python COMPONENTS Interpreter QUIET REQUIRED)

push_find_state(Poetry)
find_program(Poetry_EXECUTABLE NAMES poetry ${FIND_OPTIONS})
pop_find_state()

check_find_package(Poetry EXECUTABLE)
halt_unless(Poetry EXECUTABLE)
hide(Poetry EXECUTABLE)
import_program(poetry LOCATION ${Poetry_EXECUTABLE} GLOBAL)
add_executable(Python::Poetry ALIAS poetry)
