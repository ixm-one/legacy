include(PackageSearch)

push_find_state(DistCC)
find_program(DistCC_EXECUTABLE NAMES distcc ${FIND_OPTIONS})
pop_find_state()

check_find_package(DistCC EXECUTABLE)
halt_unless(DistCC EXECUTABLE)
hide(DistCC EXECUTABLE)
import_program(distcc LOCATION ${DistCC_EXECUTABLE} GLOBAL)
