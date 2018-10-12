include_guard(GLOBAL)

function (combobox name doc)
  list(GET ARGN 0 default)
  set(${name} ${default} CACHE STRING ${doc})
  set_property(CACHE ${name} PROPERTY STRINGS ${ARGN})
endfunction()
