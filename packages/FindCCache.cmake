include(PackageSearch)

push_find_state(CCache)
find_program(CCache_EXECUTABLE NAMES ccache ${FIND_OPTIONS})
pop_find_state()

check_find_package(CCache EXECUTABLE)
halt_unless(CCache EXECUTABLE)
hide(CCache EXECUTABLE)
import_program(ccache LOCATION ${CCache_EXECUTABLE} GLOBAL)
