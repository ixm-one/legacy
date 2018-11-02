# We don't add an include_guard so subprojects may use this as well
# This project is used like so:
# cmake_minimum_required(VERSION 3.1X)
# include(FetchContent)
# FetchContent_Declare(ixm ...)
# ...
# project(my-project)
# include(DefaultLayout)
# Congrats. A basic target design has been added. Make sure to link libraries
# and acquire dependencies as needed.
# This default layout will:
#  1) Create per-project build options
#  2) Generate a library target and X executables based on how Rust's cargo does it
#  3) Generate examples if necessary
#  4) Generate benchmark tests if necessary
#  5) Generate documentation if necessary
#  6) Generate unit tests if necessary
#  7) Generate install targets for said project
#  8) Set various CPack settings if necessary
#  9) Generate ${PROJECT_NAME}-config.cmake files
#  10) Generate additional build targets for things like ClangCheck/Bloaty
#  11) Automatically sets certain values based on the system to improve build
#      times

include(DefaultLayout/Executables.cmake)
include(DefaultLayout/Benchmarks.cmake)
include(DefaultLayout/Examples.cmake)
include(DefaultLayout/Tests.cmake)

include(DefaultLayout/Options.cmake)
include(DefaultLayout/Docs.cmake)

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/.cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

__default_options()

if (IS_DIRECTORY ${PROJECT_SOURCE_DIR}/src)
  add_library(${PROJECT_NAME})
else()
  add_library(${PROJECT_NAME} INTERFACE)
endif()

#__default_library() # Generate the primary library
#__default_executable() # Generate the main executable if possible
__default_extra_executables() # Generate all of our extra executables

if (${PROJECT_NAME}_BUILD_BENCHMARKS)
  __default_benchmarks()
endif()

if (${PROJECT_NAME}_BUILD_EXAMPLES)
  __default_examples()
endif()

if (${PROJECT_NAME}_BUILD_TESTING)
  __default_tests()
endif()

if (${PROJECT_NAME}_BUILD_DOCS)
  __default_docs()
endif()


# Generate our primary project target...
if (IS_DIRECTORY ${PROJECT_SOURCE_DIR}/src)
  # We're not an interface library
  foreach (ext IN LISTS CMAKE_CXX_SOURCE_FILE_EXTENSIONS
                        CMAKE_C_SOURCE_FILE_EXTENSIONS)
    if (EXISTS ${PROJECT_SOURCE_DIR}/src/main.${ext})
      add_executable(${PROJECT_NAME})
      break()
    endif()
  endforeach ()
  if (NOT TARGET ${PROJECT_NAME})
    add_library(${PROJECT_NAME})
  endif()
else()
  add_library(${PROJECT_NAME} INTERFACE)
endif()
