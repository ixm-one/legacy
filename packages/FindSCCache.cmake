include(CheckFindPackage)
include(ImportProgram)
include(PushFindState)
include(Halt)
include(Hide)

push_find_state(SCCache)
find_program(SCCache_EXECUTABLE NAMES sccache ${FIND_OPTIONS})
pop_find_state()

check_find_package(SCCache EXECUTABLE)
halt_unless(SCCache EXECUTABLE)
hide(SCCache EXECUTABLE)
import_program(sccache LOCATION ${SCCache_EXECUTABLE} GLOBAL)
