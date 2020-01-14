include_guard(GLOBAL)

function (ixm_check_enum name)
  ixm_check_common_prepare(variable ${name})
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    CONTENT [[
      static_assert(::std::is_enum<@name@>::value, "Not an enum");
    ]])
endfunction()

function (ixm_check_class name)
  ixm_check_common_prepare(variable ${name})
  ixm_check_common_symbol(${name} ${ARGN}
    OUTPUT_VARIABLE ${variable}
    CONTENT [[
      static_assert(::std::is_class<@name@>::value, "Not a class");
    ]])
endfunction()

function (ixm_check_union name)
  ixm_check_common_prepare(variable ${name})
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    CONTENT [[
      static_assert(::std::is_union<@name@>::value, "Not a union");
    ]])
endfunction()

function (ixm_check_integral name)
  ixm_check_common_prepare(variable ${name})
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    CONTENT [[
      static_assert(::std::is_integral<@name@>::value, "Not an integral");
  ]])
endfunction()

function (ixm_check_pointer name)
  ixm_check_common_prepare(variable ${name})
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    CONTENT [[
      static_assert(::std::is_pointer<@name@>::value, "Not a pointer");
  ]])
endfunction()

function (ixm_check_trait name)
  ixm_check_common_prepare(variable ${name})
  ixm_check_common_symbol(${variable} ${name} ${ARGN}
    CONTENT "static_assert(::std::${trait}<@name@>::value, \"Not a ${trait}\");")
endfunction ()
