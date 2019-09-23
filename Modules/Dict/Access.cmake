include_guard(GLOBAL)

function (ixm_dict_contains dict key result)
  ixm_dict_noop(${dict})
  ixm_dict_keys(${dict} keys)
  list(FIND keys ${key} index)
  if (index EQUAL -1)
    set(${result} NO PARENT_SCOPE)
    return()
  endif()
  set(${result} YES PARENT_SCOPE)
endfunction()

function (ixm_dict_get dict key result)
  ixm_dict_noop(${dict})
  get_property(values TARGET ${dict} PROPERTY "INTERFACE_${key}")
  set(${result} ${values} PARENT_SCOPE)
endfunction()

function (ixm_dict_keys dict result)
  ixm_dict_noop(${dict})
  string(ASCII 192 C0)
  get_property(values TARGET ${dict} PROPERTY "INTERFACE_${C0}")
  set(${result} ${values} PARENT_SCOPE)
endfunction()