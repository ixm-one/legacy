include_guard(GLOBAL)

function (ixm_coven_common_launcher target)
  if (NOT TARGET ${target})
    return()
  endif()
  foreach (language IN ITEMS CXX C)
    if (DEFINED CMAKE_${language}_COMPILER_LAUNCHER)
      continue()
    endif()
    get_property(CMAKE_${language}_COMPILER_LAUNCHER
      TARGET ${target}
      PROPERTY IMPORTED_LOCATION)
    upvar(CMAKE_${language}_COMPILER_LAUNCHER)
  endforeach()
endfunction()
