include_guard(GLOBAL)

#[[ Add coverage to your target ]]
function (target_coverage name type)
  set(valid $<OR:$<CXX_COMPILER:GNU>,$<CXX_COMPILER_ID:Clang>>)
  set(command ${name} ${type} $<${valid}:--coverage>)
  target_link_options(${command})
endfunction()
