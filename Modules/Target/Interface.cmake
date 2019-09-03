include_guard(GLOBAL)

function (ixm_target_interface name)
  add_library(${name} INTERFACE)
  event(EMIT target:interface ${name})
endfunction()