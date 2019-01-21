include_guard(GLOBAL)

# This is for forcing values
function (internal name value)
  cache(INTERNAL ${name} "${value}" "${ARGN}")
endfunction()

# This is *not* for forcing values
function (cache type name value)
  set(${name} "${value}" CACHE ${type} "${ARGN}")
endfunction()
