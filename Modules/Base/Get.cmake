include_guard(GLOBAL)

#[[ Basically set() with a fallback value]]
macro(get var lookup default)
  set(__@default ${default} ${ARGN})
  if (DEFINED ${lookup} AND ${lookup})
    set(__@default ${${lookup}} ${ARGN})
  endif()
  set(${var} ${__\@default})
  unset(__@default)
endmacro()
