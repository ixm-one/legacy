include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Breakout)
include(Hide)

push_find_state(IWYU)
find_program(IWYU_EXECUTABLE NAMES include-what-you-use ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(IWYU
  REQUIRED_VARS IWYU_EXECUTABLE)

breakout(IWYU_EXECUTABLE)
import_program(iwyu LOCATION ${IWYU_EXECUTABLE} GLOBAL)
hide(IWYU EXECUTABLE)

