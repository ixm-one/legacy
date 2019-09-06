include_guard(GLOBAL)

macro(ixm_dict_noop @dict:name)
  if (NOT TARGET ${\@dict\:name})
    return()
  endif()
endmacro()

function (ixm_dict_create @dict:name)
  if (NOT TARGET ${\@dict\:name})
    add_library(${\@dict\:name} INTERFACE IMPORTED)
  endif()
endfunction()

function (ixm_dict_filepath @dict:result @dict:path @dict:ext)
  if (NOT @dict:path MATCHES ".+[.]${\@dict\:ext}")
    set(@dict:path "${\@dict\:path}.${\@dict\:ext}")
  endif()
  if (NOT IS_ABSOLUTE "${\@dict\:path}")
    get_filename_component(@dict:path "${\@dict\:path}" ABSOLUTE
      BASE_DIR "${CMAKE_CURRENT_BINARY_DIR}")
  endif()
  set($\@dict\:result} "${\@dict\:path}" PARENT_SCOPE)
endfunction()

