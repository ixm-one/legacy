include_guard(GLOBAL)

function(ixm_enable depend name)
  set(dep IXM_ENABLE_${depend})
  set(var ${dep}_${name})
  option(${var} "${ARGN}" ${${dep}})

  if (${dep} AND ${var})
    return()
  endif()

  get_property(cached CACHE ${var} PROPERTY VALUE)
  if (cached)
    set(args CACHE BOOL "${ARGN}" FORCE)
  endif()
  set(${var} ${dep} ${args})
endfunction()
