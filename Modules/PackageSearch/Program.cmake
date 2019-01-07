include_guard(GLOBAL)

function (import_program name)
  ixm_parse(${ARGN}
    @FLAGS GLOBAL
    @ARGS=? LOCATION)
  if (GLOBAL)
    set(GLOBAL GLOBAL)
  endif()

  list(APPEND properties IMPORTED_LOCATION ${LOCATION})
  add_executable(${name} IMPORTED ${GLOBAL})
  set_target_properties(${name} PROPERTIES ${properties})
endfunction ()
