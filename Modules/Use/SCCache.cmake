include_guard(GLOBAL)

find_package(SCCache)

function (ixm_use_sccache target)
  if (NOT SCCache_FOUND)
    return()
  endif()
  set_target_properties(${target}
    PROPERTIES
      CXX_COMPILER_LAUNCHER SCCache
      C_COMPILER_LAUNCHER SCCache)
endfunction()
