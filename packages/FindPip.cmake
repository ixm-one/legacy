include(CheckFindPackage)
include(ImportProgram)
include(PushFindState)
include(Halt)
include(Hide)

find_package(Python COMPONENTS Interpreter QUIET REQUIRED)

push_find_state(Pip)
find_program(Pip_EXECUTABLE
  NAMES
    pip${Python_VERSION_MAJOR}${Python_VERSION_MINOR}
    pip${Python_VERSION_MAJOR}
    pip
  ${FIND_OPTIONS})
pop_find_state()

check_find_package(Pip EXECUTABLE)
halt_unless(Pip EXECUTABLE)
hide(Pip EXECUTABLE)
import_program(pip LOCATION ${Pip_EXECUTABLE} GLOBAL)
add_executable(Python::Pip ALIAS pip)
