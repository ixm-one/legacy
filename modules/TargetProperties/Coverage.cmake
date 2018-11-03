include_guard(GLOBAL)

#[[ Add coverage to your target ]]
function (target_coverage name type)
  set(valid $<OR:$<CXX_COMPILER:GNU>,$<CXX_COMPILER_ID:Clang>>)
  set(command ${name} ${type} $<${valid}:--coverage>)
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.13)
    target_link_libraries(${command})
  else()
    target_link_libraries(${command})
  endif()
endfunction()
