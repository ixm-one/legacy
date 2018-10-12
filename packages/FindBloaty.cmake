include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Breakout)
include(Hide)

push_find_state(Bloaty)
find_program(Bloaty_EXECUTABLE NAMES bloaty ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(Bloaty
  REQUIRED_VARS Bloaty_EXECUTABLE)

breakout(Bloaty_EXECUTABLE)
import_program(Bloaty LOCATION ${IWYU_EXECUTABLE} GLOBAL)
hide(Bloaty EXECUTABLE)
