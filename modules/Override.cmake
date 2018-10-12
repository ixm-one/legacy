include_guard(GLOBAL)

function (override var type)
  get_property(docs CACHE ${var} PROPERTY HELPSTRING)
  set(${var} ${ARGN} CACHE ${type} "${docs}" FORCE)
endfunction ()

function (bool var value)
  override(${var} BOOL ${value})
endfunction ()

function (filepath var value)
  override(${var} FILEPATH ${value})
endfunction()

function (directory var value)
  override(${var} PATH ${value})
endfunction ()

function (text var value)
  override(${var} STRING ${value})
endfunction ()
