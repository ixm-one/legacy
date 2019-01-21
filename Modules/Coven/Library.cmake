include_guard(GLOBAL)

import(IXM::Generators::UnityBuild)

function (ixm_coven_create_libraries)
  ixm_coven_create_project_library()
  #[[
    This means that there are no sources or directories *without* a main file
    located within it. BUT we still make an interface library. Because it's the
    right thing to do.
  ]]
  if (NOT TARGET ${PROJECT_NAME})
    add_library(${PROJECT_NAME} INTERFACE)
    target_include_directories(${PROJECT_NAME}
      INTERFACE
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)
  endif()
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
endfunction()

function (ixm_coven_create_project_library)
  if (NOT IS_DIRECTORY "${PROJECT_SOURCE_DIR}/src")
    return()
  endif()
  glob(entries BASE "${PROJECT_SOURCE_DIR}/src" ALL "${PROJECT_SOURCE_DIR}/src/*")
  if (NOT entries)
    return()
  endif()
  list(FILTER entries EXCLUDE REGEX "(bin|main[.].*)")

  list(APPEND directories ${entries})
  list(APPEND files ${entries})

  if (files)
    list(FILTER files INCLUDE REGEX ".*[.].*")
    add_library(${PROJECT_NAME})
    target_sources(${PROJECT_NAME} PRIVATE ${files})
  endif()

  # If there's no directories, we return. If there were no source files, we
  # return. Simple!
  if (NOT directories)
    return()
  endif()

  # This filtering saves us a foreach within CMake.
  list(FILTER directories EXCLUDE REGEX ".*[.].*")
  foreach (directory IN LISTS directories)
    glob(srcs "${PROJECT_SOURCE_DIR}/src/${directory}/*.*")
    list(APPEND main ${srcs})
    list(FILTER main INCLUDE REGEX ".*/main[.].*")
    if (main)
      continue()
    endif()
    add_submodule(${PROJECT_NAME}::${directory} HIERARCHY)
  endforeach()
endfunction()

function (ixm_coven_add_legacy_module directory)
  file(RELATIVE_PATH path "${PROJECT_SOURCE_DIR}/src" "${directory}")
  string(REPLACE "/" "-" target "${PROJECT_NAME}/${path}")
  string(REPLACE "/" "::" alias "${PROJECT_NAME}/${path}")
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files
      LIST_DIRECTORIES OFF
      CONFIGURE_DEPENDS "${directory}/*.${ext}")
    list(APPEND sources ${files})
  endforeach()
  if (NOT sources)
    return()
  endif()
  ixm_generate_unity_build_file(${alias})
  add_submodule(${alias} SPLAYED ${sources})
endfunction()

function (ixm_coven_create_primary_modules)
  file(GLOB_RECURSE entries LIST_DIRECTORIES ON "${PROJECT_SOURCE_DIR}/src/*")
  string(JOIN "|" regex ${IXM_SOURCE_EXTENSIONS})
  # Early file removal
  list(FILTER entries EXCLUDE REGEX "${PROJECT_SOURCE_DIR}/src/bin")
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
  if (EXISTS "${PROJECT_SOURCE_DIR}/src")
    ixm_coven_add_library()
  endif()
  if (NOT TARGET ${PROJECT_NAME})
    ixm_coven_add_interface()
  endif()
  add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
endfunction()


