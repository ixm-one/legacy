include_guard(GLOBAL)

function (ixm_target_link name)
  void(LIBRARIES DIRECTORIES OPTIONS)
  parse(${ARGN} @ARGS=+ LIBRARIES DIRECTORIES OPTIONS)
endfunction()
