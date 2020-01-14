blueprint(Coven)
import(Coven::*)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(CMakeDependentOption)
include(GNUInstallDirs)
include(CTest)

set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED ON) # Removes CDash targets
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if (PROJECT_STANDALONE)
  option(BUILD_PACKAGE "Configure the project for producing packages")
endif()

if (NOT DEFINED CMAKE_MSVC_RUNTIME_LIBRARY)
  set(CMAKE_MSVC_RUNTIME_LIBRARY
    MultiThreaded<$<$CONFIG:Debug>:Debug>$<$<BOOL:${BUILD_SHARED_LIBS}>:DLL>)
endif()

coven_detect_directory(benchmarks "benches")
coven_detect_directory(examples "examples")
coven_detect_directory(tests "tests")
coven_detect_directory(docs "docs")
coven_detect_launchers()

coven_project_init()

#coven_program_init()
#coven_library_init()

coven_benchmark_init()
coven_examples_init()
coven_tests_init()
coven_docs_init()

coven_options_init()
coven_install_init()
coven_package_init()
