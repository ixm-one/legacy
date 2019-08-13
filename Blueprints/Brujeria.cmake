import(IXM::Fetch::*)

find_package(Python REQUIRED)

# This is a simpler layout than most others. In short, given a directory,
# inside, we generate a python module, adding all sources from src/*.{ext}
# and an include directory. The output module is placed into a specific
# directory passed from the brujeria tool.
add_library(${PROJECT_NAME} MODULE)
file(GLOB_RECURSE sources
  LIST_DIRECTORIES OFF
  CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/*")
target_sources(${PROJECT_NAME} PRIVATE ${sources})
target_include_directories(${PROJECT_NAME} PRIVATE "${PROJECT_SOURCE_DIR}/include")
