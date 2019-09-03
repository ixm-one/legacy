include_guard(GLOBAL)

#[[ target(COMPILE <target> DEFINITIONS <definitions>... FEATURES ... OPTIONS ...) ]]
function (ixm_target_compile name)
  parse(${ARGN}
    @ARGS=+ DEFINITIONS FEATURES OPTIONS)
endfunction()