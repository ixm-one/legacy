include(CheckFindPackage)
include(ImportProgram)
include(PushFindState)
include(Halt)
include(Hide)

push_find_state(CppCheck)
find_program(CppCheck_EXECUTABLE NAMES cppcheck ${FIND_OPTIONS})
pop_find_state()

check_find_package(CppCheck EXECUTABLE)
halt_unless(CppCheck EXECUTABLE)
hide(CppCheck EXECUTABLE)
import_program(cppcheck LOCATION ${CppCheck_EXECUTABLE} GLOBAL)
