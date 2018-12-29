include(PackageSearch)

find_program(SCCache_EXECUTABLE NAMES sccache ${FIND_OPTIONS})

check_find_package(SCCache EXECUTABLE)
return(NOT SCCache_EXECUTABLE)
hide(SCCache EXECUTABLE)
import_program(sccache LOCATION ${SCCache_EXECUTABLE} GLOBAL)
