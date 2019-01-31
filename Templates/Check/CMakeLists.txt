cmake_minimum_required(VERSION ${VERSION})
project(${NAME} LANGUAGES ${LANGUAGE})

string(TOLOWER ${LANGUAGE} extension)

if (TARGET_TYPE STREQUAL "STATIC" OR TARGET_TYPE STREQUAL "SHARED")
  add_library(${NAME} ${TARGET_TYPE})
else()
  add_executable(${NAME})
endif()

target_sources(${NAME} PRIVATE main.${extension})

if (DEFINED INCLUDE_DIRECTORIES)
  target_include_directories(${NAME} PRIVATE ${INCLUDE_DIRECTORIES})
endif()

if (DEFINED COMPILE_DEFINITIONS)
  target_compile_definitions(${NAME} PRIVATE ${COMPILE_DEFINITIONS})
endif()

if (DEFINED COMPILE_OPTIONS)
  target_compile_options(${NAME} PRIVATE ${COMPILE_OPTIONS})
endif()

if (DEFINED COMPILE_FEATURES)
  target_compile_features(${NAME} PRIVATE ${COMPILE_FEATURES})
endif()

if (DEFINED LINK_DIRECTORIES)
  target_link_directories(${NAME} PRIVATE ${LINK_DIRECTORIES})
endif()

if (DEFINED LINK_LIBRARIES)
  target_link_libraries(${NAME} PRIVATE ${LINK_LIBRARIES})
endif()

if (DEFINED LINK_OPTIONS)
  target_link_options(${NAME} PRIVATE ${LINK_OPTIONS})
endif()
