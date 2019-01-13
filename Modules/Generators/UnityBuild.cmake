include_guard(GLOBAL)

# TODO: This could be refined a *lot* better
#[[ Generates a unity build file based on the sources given ]]
function(ixm_generate_unity_build_file path)
  foreach (source IN LISTS ARGN)
    list(APPEND content "#include <${source}$<ANGLE-R>")
  endforeach()
  file(GENERATE OUTPUT ${path} CONTENT ${content})
endfunction()
