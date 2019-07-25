include_guard(GLOBAL)

import(IXM::Property::*)

function (property action)
  if (action STREQUAL "DEFINE")
    ixm_property_define(${ARGN})
  elseif (action STREQUAL "GET")
    ixm_property_get(${ARGN})
  elseif (action STREQUAL "GENEXP")
    ixm_property_genexp(${ARGN})
  endif()
endfunction()
