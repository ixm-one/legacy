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

option(${PROJECT_NAME}_QUIET "Suppress output for ${PROJECT_NAME}")

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
