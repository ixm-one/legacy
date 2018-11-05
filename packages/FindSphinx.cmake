include(PackageSearch)
include(PushState)
include(IXM)

find_package(Python COMPONENTS Interpreter QUIET REQUIRED)

push_find_state(Sphinx)
find_program(Sphinx_EXECUTABLE NAMES sphinx-build ${FIND_OPTIONS})
pop_find_state()

check_find_package(Sphinx EXECUTABLE)
halt_unless(Sphinx EXECUTABLE)
hide(Sphinx EXECUTABLE)
import_program(sphinx LOCATION ${Sphinx_EXECUTABLE} GLOBAL)
add_executable(Python::Sphinx ALIAS sphinx)
