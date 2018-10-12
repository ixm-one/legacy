include(FindPackageHandleStandardArgs)
include(ImportProgram)
include(PushFindState)
include(Breakout)
include(Hide)

push_find_state(CCache)
find_program(CCache_EXECUTABLE NAMES ccache ${FIND_OPTIONS})
pop_find_state()

find_package_handle_standard_args(CCache REQUIRED_VARS CCache_EXECUTABLE)

breakout(CCache_EXECUTABLE)
import_program(ccache LOCATION ${CCache_EXECUTABLE} GLOBAL)
hide(CCache EXECUTABLE)
