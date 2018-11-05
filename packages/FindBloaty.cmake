include(PackageSearch)

push_find_state(Bloaty)
find_program(Bloaty_EXECUTABLE NAMES bloaty ${FIND_OPTIONS})
pop_find_state()

check_find_package(Bloaty EXECUTABLE)
halt_unless(Bloaty EXECUTABLE)
import_program(Bloaty LOCATION ${Bloaty_EXECUTABLE} GLOBAL)
hide(Bloaty EXECUTABLE)
