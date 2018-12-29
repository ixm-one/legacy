include_guard(GLOBAL)

function (add_subdirectory dir)
  ixm_builtins_add_subdirectory(processed ${CMAKE_SOURCE_DIR})
  if (NOT dir IN_LIST processed)
    _add_subdirectory(${dir} ${ARGN})
  endif()
endfunction()

function (add_executable name)
  argparse(${ARGN}
    @FLAGS APPIMAGE)
  _add_executable(${name} ${REMAINDER})
  if (APPIMAGE)
    set_target_properties(${name} PROPERTIES APPIMAGE TRUE)
  endif()
endfunction()

# Module support functions
function (ixm_builtins_add_subdirectory output src)
  get_property(subdirs DIRECTORY ${src} PROPERTY SUBDIRECTORIES)
  foreach (subdir IN LISTS subdirs)
    ixm_builtins_add_subdirectory(${output} ${subdir})
    list(APPEND ${output} ${subdir})
  endforeach()
  list(APPEND ${output} ${src})
  list(REMOVE_DUPLICATES ${output})
  parent_scope(${output})
endfunction()


