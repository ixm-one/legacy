include_guard(GLOBAL)

function (ixm_check_enum name)
  string(TOUPPER "${name}" item)
  string(REPLACE "::" ":" item "${item}")
  string(MAKE_C_IDENTIFIER "HAVE_${item}" variable)
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    EXTRA_CMAKE_FLAGS CXX_STANDARD=17
    
  CONTENT [[
    static_assert(::std::is_enum<@name@>::value, "Not an enum");
  ]])
endfunction()
