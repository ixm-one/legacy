include_guard(GLOBAL)

import(IXM::Check::Internal)

# This is ONLY allowed for C++
function (check_enum_exists enum)
  string(MAKE_C_IDENTIFIER "HAVE_ENUM_${enum}" variable)

  if ($CACHE{${variable}})
    return()
  endif()

  ixm_check_common(${ARGN})

  if (NOT QUIET)
    message(STATUS "Looking for ${enum}")
  endif()

  ixm_check_build_root()
  ixm_check_includes()

  ixm_check_configure_content([[
    static_assert(::std::is_enum_v<@enum@>, "std::is_enum_v<@enum@>")
  ]])

  list(APPEND COMPILE_FEATURES cxx_static_assert cxx_variadic_templates)
  list(APPEND CMAKE_FLAGS "-DNAME=check-enum-exists")
  ixm_check_set_flags(CMAKE_FLAGS)

  try_compile(${variable}
    check-enum-exists
    "${BUILD_ROOT}/build"
    "${BUILD_ROOT}"
    CMAKE_FLAGS ${CMAKE_FLAGS}
    OUTPUT_VARIABLE ${variable}_BUILD_OUTPUT)
  ixm_check_result(${variable} ${enum} "Have enum ${enum}")
endfunction()

function (check_enum_member_exists member)
  string(MAKE_C_IDENTIFIER "HAVE_ENUM_MEMBER_${member}" variable)
  if ($CACHE{${variable}})
    return()
  endif()

  ixm_check_common(${ARGN})

  if (NOT QUIET)
    message(STATUS "Looking for '${member}'")
  endif()

  ixm_check_build_root()
  ixm_check_includes()

  ixm_check_configure_content([[
    static_assert(::std::is_enum_v<@enum@>, "std::is_enum_v<@enum@>");
    auto member = @member@;
  ]])

  list(APPEND COMPILE_FEATURES cxx_static_assert cxx_variadic_templates)
  list(APPEND CMAKE_FLAGS "-DNAME=check-enum-member-exists")
  ixm_check_set_flags(CMAKE_FLAGS)

  try_compile(${variable}
    check-enum-member-exists
    "${BUILD_ROOT}/build"
    "${BUILD_ROOT}"
    CMAKE_FLAGS ${CMAKE_FLAGS}
    OUTPUT_VARIABLE ${variable}_BUILD_OUTPUT)
  ixm_check_result(${variable} ${member} "Have enum member '${member}'")
endfunction()
