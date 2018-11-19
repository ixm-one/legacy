# DefaultLayout is the primary layout to use when using IXM. Another layout,
# Pitchfork, is also planned for support. Their behavior is intended to be the
# same, minus a few specific details. In those cases, we simply document their
# different approaches.
# TODO: Come up with a different name for DefaultLayout
# We don't add an include_guard so subprojects may use this as well
# This project is used like so:
# cmake_minimum_required(VERSION 3.12+)
# include(FetchContent)
# FetchContent_Declare(ixm ...)
# ...
# project(my-project)
# include(DefaultLayout)
# Congrats. A basic target design has been added. Make sure to link libraries
# and acquire dependencies as needed.
# This default layout will:
#  [x] Create per-project build options
#  [ ] Generate a library target and X executables based on how Rust's cargo does it
#  [x] Generate examples if necessary
#  [x] Generate benchmark tests if necessary
#  [ ] Generate documentation if necessary
#  [x] Generate unit tests if necessary
#  [ ] Generate install targets for said project
#  [ ] Set various CPack settings if necessary
#  [ ] Generate ${PROJECT_NAME}-config.cmake files
#  [ ] Generate additional build targets for things like ClangCheck/Bloaty
#  [ ] Automatically sets certain values based on the system to improve build
#      times

include(CMakePackageConfigHelpers)
include(PushState)
include(CTest)

push_module_path(DefaultLayout)
include(Support)
include(Targets)
include(Docs)
pop_module_path()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/.cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

list(APPEND IXM_SOURCE_EXTENSIONS ${CMAKE_CXX_SOURCE_FILE_EXTENSIONS})
list(APPEND IXM_SOURCE_EXTENSIONS ${CMAKE_C_SOURCE_FILE_EXTENSIONS})
list(REMOVE_DUPLICATES IXM_SOURCE_EXTENSIONS)

setting(BUILD_TESTING
  DESCRIPTION "Build tests for ${PROJECT_NAME}"
  REQUIRES BUILD_TESTING AND EXISTS "${PROJECT_SOURCE_DIR}/tests")

setting(BUILD_BENCHMARKS
  DESCRIPTION "Build benchmarks for ${PROJECT_NAME}"
  REQUIRES BUILD_TESTING AND EXISTS "${PROJECT_SOURCE_DIR}/bench")

settinng(BUILD_EXAMPLES
  DESCRIPTION "Build examples for ${PROJECT_NAME}"
  REQUIRES EXISTS "${PROJECT_SOURCE_DIR}/examples")

setting(BUILD_DOCS
  DESCRIPTION "Build documentation for ${PROJECT_NAME}"
  REQUIRES EXISTS "${PROJECT_SOURCE_DIR}/docs")

# TODO: Add a verbose option to inject the project name at the front of every
# message printed...
option(${PROJECT_NAME}_QUIET "Suppress output for ${PROJECT_NAME}")

# TODO: Put these into a PushState stack for AcquireDependencies
# Have them be set on a per-package basis
set(IXM_BUILD_DIR "${PROJECT_BINARY_DIR}")

set(IXM_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/include")
set(IXM_SRC_DIR "${PROJECT_SOURCE_DIR}/src")

set(IXM_EXAMPLES_DIR "${PROJECT_SOURCE_DIR}/examples")
set(IXM_EXTERNAL_DIR "${PROJECT_SOURCE_DIR}/extern")
set(IXM_BENCH_DIR "${PROJECT_SOURCE_DIR}/bench")
set(IXM_TEST_DIR "${PROJECT_SOURCE_DIR}/tests")

set(IXM_TOOLS_DIR "${PROJECT_SOURCE_DIR}/tools")
set(IXM_DATA_DIR "${PROJECT_SOURCE_DIR}/data")
set(IXM_DOCS_DIR "${PROJECT_SOURCE_DIR}/docs")

set(IXM_EXTRAS_DIR "${PROJECT_SOURCE_DIR}/extras")
set(IXM_LIBS_DIR "${PROJECT_SOURCE_DIR}/libs")

check_standalone() # Sets standalone variable

#[[ Generate primary targets ]]
ixm_layout_add_library() # [[ Attempt to generate static/shared library ]]
ixm_layout_add_program() # [[ Attempt to generate main ]]

ixm_layout_add_interface() # [[ Attempt to generate interface library ]]

ixm_layout_add_srcdirs() # [[ Generate programs from src/*/<main> ]]
ixm_layout_add_srcbin() # [[ Generate programs from src/bin ]]
ixm_layout_add_benchmarks() #[[ Generate benchmarks ]]
ixm_layout_add_examples() #[[ Generate examples ]]
ixm_layout_add_tests() #[[ Generate unit tests ]]
ixm_layout_add_docs() #[[ Generate docs ]]
