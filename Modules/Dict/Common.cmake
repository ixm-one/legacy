include_guard(GLOBAL)

macro(ixm_dict_noop dict)
  if (NOT TARGET ${dict})
    return()
  endif()
endmacro()

function (ixm_dict_create dict)
  if (NOT TARGET ${dict})
    add_library(${dict} INTERFACE IMPORTED)
  endif()
endfunction()

function (ixm_dict_filepath result path ext)
  if (NOT path MATCHES ".+[.]${ext}")
    set(path "${path}.${ext}")
  endif()
  if (NOT IS_ABSOLUTE "${path}")
    get_filename_component(path "${path}" ABSOLUTE
      BASE_DIR "${CMAKE_CURRENT_BINARY_DIR}")
  endif()
  set(${result} "${path}" PARENT_SCOPE)
endfunction()