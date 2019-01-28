include_guard(GLOBAL)

function (global name)
  set_property(GLOBAL PROPERTY ${name} "${ARGN}")
endfunction()

# This is for forcing values
function (internal name value)
  cache(INTERNAL ${name} "${value}" "${ARGN}")
endfunction()

# This is *not* for forcing values
function (cache type name value)
  set(${name} "${value}" CACHE ${type} "${ARGN}")
endfunction()
