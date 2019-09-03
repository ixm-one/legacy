include_guard(GLOBAL)

function (ixm_event_emit name)
  set(ixm::event::${name} ${ARGN})
endfunction()