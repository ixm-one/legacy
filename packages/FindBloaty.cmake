include(CheckFindPackage)
include(ImportProgram)
include(PushFindState)
include(Halt)
include(Hide)

push_find_state(Bloaty)
find_program(Bloaty_EXECUTABLE NAMES bloaty ${FIND_OPTIONS})
pop_find_state()

check_find_package(Bloaty EXECUTABLE)
halt_unless(Bloaty_EXECUTABLE)
import_program(Bloaty LOCATION ${IWYU_EXECUTABLE} GLOBAL)
hide(Bloaty EXECUTABLE)
