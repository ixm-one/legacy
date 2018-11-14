include_guard(GLOBAL)

#[[ This macro is basically "set" with a fallback value ]]
macro (get var lookup default)
  set(${var} ${default})
  if (${lookup})
    set(${var} ${${lookup}})
  endif()
endmacro()
