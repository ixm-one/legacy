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

############

find_dependency(Python COMPONENTS Interpreter QUIET REQUIRED)

list(APPEND NAMES pip${Python_VERSION_MAJOR}${Python_VERSION_MINOR})
list(APPEND NAMES pip${Python_VERSION_MAJOR})
list(APPEND NAMES pip)

find_program(Pip NAMES ${NAMES})
find_check(Pip) # Auto import occurs HERE
add_executable(Python::Pip ALIAS pip)

############
# Current Style, different function names

find_dependency(Python COMPONENTS Interpreter QUIET REQUIRED)

find_program(Pip NAMES ${NAMES})
find_check(Pip EXECUTABLE)
find_import(pip LOCATION ${Pip_EXECUTABLE}) # GLOBAL by default
add_executable(Python::Pip ALIAS pip)


###################
# Different Library

find_library(mbedTLS NAMES mbedtls)
find_component(mbedTLS Crypto NAMES mbedcrypto)
find_component(mbedTLS X509 NAMES mbedx509)
find_header(mbedTLS NAMES mbedtls/version.h)
# Auto imports, marks as advanced, etc.
find_check(mbedTLS COMPONENTS Crypto X509)
