include_guard(GLOBAL)

function (ixm_coven_add_interface)
  add_library(${PROJECT_NAME} INTERFACE)
  target_include_directories(${PROJECT_NAME}
    INTERFACE
      $<BUILD_INTERFACE:${PROJECT_SOURCE}/include>
      $<INSTALL_INTERFACE:include>)
endfunction()

function (ixm_coven_add_library)
  add_library(${PROJECT_NAME})
  target_include_directories(${PROJECT_NAME}
    PUBLIC
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:include>
    PRIVATE
      "${PROJECT_SOURCE_DIR}/src")
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files LIST_DIRECTORIES OFF "${PROJECT_SOURCE_DIR}/src/*.${ext}")
    list(FILTER files EXCLUDE REGEX ".*/main[.]${ext}")
    list(APPEND sources ${files})
  endforeach()
  if (NOT sources)
    return()
  endif()
  target_sources(${PROJECT_NAME} PRIVATE ${sources})
endfunction()

function (ixm_coven_add_legacy_module directory)
  file(RELATIVE_PATH path "${PROJECT_SOURCE_DIR}/src" "${directory}")
  string(REPLACE "/" "_" option "${path}")
  string(TOUPPER "${option}" option)
  option(${PROJECT_NAME}_UNITY_BUILD_${option}
    "Perform a unity build for '${path}'" ON)
  set(enabled $<BOOL:${${PROJECT_NAME}_UNITY_BUILD_${option}}>)
  string(REPLACE "/" "-" target "${PROJECT_NAME}/${path}")
  string(REPLACE "/" "::" alias "${PROJECT_NAME}/${path}")
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files LIST_DIRECTORIES OFF "${directory}")
    list(APPEND sources ${files})
  endforeach()
  if (NOT sources)
    return()
  endif()
  set(generated "${PROJECT_BINARY_DIR}/IXM/generated/unity/${CMAKE_CFG_INTDIR}")
  set(unity "${generated}/${PROJECT_NAME}/${path}.cxx")
  add_library(${target} OBJECT)
  add_library(${alias} ALIAS ${target})
  target_sources(${PROJECT_NAME} PRIVATE $<TARGET_OBJECTS:${alias}>)
  target_sources(${target}
    PRIVATE
      $<IF:${enabled},${unity},${sources}>)
  foreach (source IN LISTS sources)
    list(APPEND content "#include <${source}$<ANGLE-R>")
  endforeach()
  file(GENERATE
    OUTPUT ${unity}
    CONTENT ${content}
    CONDITION ${enabled})
  set_target_properties(${target} PROPERTIES UNITY_BUILD_FILE ${unity})
endfunction()

function (ixm_coven_create_legacy_modules)
  file(GLOB_RECURSE entries LIST_DIRECTORIES ON "${PROJECT_SOURCE_DIR}/src/*")
  string(JOIN "|" regex ${IXM_SOURCE_EXTENSIONS})
  # Early file removal
  list(FILTER entries EXCLUDE REGEX ".*[.](${regex})")
  foreach (entry IN LISTS entries)
    if (IS_DIRECTORY ${entry})
      list(APPEND directories ${entry})
    endif()
  endforeach()
  foreach (directory IN LISTS directories)
    ixm_coven_add_legacy_module(${directory})
  endforeach()
endfunction()

function (ixm_coven_create_primary_library)
  if (NOT EXISTS "${PROJECT_SOURCE_DIR}/src")
    ixm_coven_add_interface()
  else()
    ixm_coven_add_library()
  endif()
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
endfunction()
