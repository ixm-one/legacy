include_guard(GLOBAL)

# This is *not* for forcing values
function (cache type name value)
  set(${name} "${value}" CACHE ${type} "${ARGN}")
endfunction()
