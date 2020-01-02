include_guard(GLOBAL)

# This module is for internal use only. Its existence is specifically to hold
# functions that allow us to replicate CMake behavior without writing
# overrides

# Replicates the CMakeError/CMakeOutput logging behavior
function (ixm_cmake_log state entity)
  if (state STREQUAL "PASS")
    set(file "${IXM_STDOUT_LOG}")
    set(act "passed")
  elseif (state STREQUAL "FAIL")
    set(file "${IXM_STDERR_LOG}")
    set(act "failed")
  else()
    return()
  endif()
  file(APPEND "${file}"
    "Determining if ${entity} exists ${act} with the following output:\n" ${ARGN})
endfunction()
