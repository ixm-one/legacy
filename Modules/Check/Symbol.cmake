include_guard(GLOBAL)

function (ixm_check_enum name)
  ixm_check_common_symbol_prepare(variable ${name})
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    EXTRA_CMAKE_FLAGS
      CXX_STANDARD=17
    CONTENT [[
      static_assert(::std::is_enum<@name@>::value, "Not an enum");
    ]])
endfunction()

function (ixm_check_class name)
  ixm_check_common_symbol_prepare(variable ${name})
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    EXTRA_CMAKE_FLAGS
      CXX_STANDARD=17
    CONTENT [[
      static_assert(::std::is_class<@name@>::value, "Not a class");
    ]])
endfunction()

function (ixm_check_union name)
  ixm_check_common_symbol_prepare(variable ${name})
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    EXTRA_CMAKE_FLAGS
      CXX_STANDARD=17
    CONTENT [[
      static_assert(::std::is_union<@name@>::value, "Not a union");
    ]])
endfunction()
