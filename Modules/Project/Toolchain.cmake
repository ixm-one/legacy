include_guard(GLOBAL)

# This function takes any triplet, even if its abbreviated, and then turns it
# into an IXM toolchain triplet. We sort of copy the triplet logic found within
# clang. This format is:
# <arch><sub>-<vendor>-<system>-<abi>
# Some examples are:
# x86_64-linux-gnu
# aarch64-linux-android
# arm-linux-gnu
# x86-windows-gnu
# x86-windows-msvc
# In this case, <vendor> is non-existant. Additionally, we don't specify if
# we actually want clang or gcc for both x86-windows-<abi>. This is an issue,
# and not one we can easily resolve.
function (ixm_project_toolchain_find triplet)

endfunction()

function (ixm_project_toolchain_file)
  if (DEFINED CMAKE_TOOLCHAIN_FILE)
    return()
  endif()
  ixm_project_toolchain_find(${CMAKE_TOOLCHAIN_NAME})
endfunction()
