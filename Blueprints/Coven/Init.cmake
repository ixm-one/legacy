blueprint(Coven)
import(Coven::*)

include(CMakeDependentOption)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/.cmake")
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

coven_detect_directory(BENCHMARKS "benches")
coven_detect_directory(EXAMPLES "examples")
coven_detect_directory(TESTS "tests")
coven_detect_directory(DOCS "docs")

coven_detect_launchers()

coven_program_init()
coven_library_init()

coven_benchmark_init()
coven_examples_init()
coven_tests_init()
coven_docs_init()

coven_options_init()
coven_install_init()
coven_package_init()

include(${Coven_MODULE_ROOT}/../Coven.cmake)
