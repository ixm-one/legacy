include_guard(GLOBAL)

# TODO: This could be refined a *lot* better
#[[ Generates a unity build file based on the sources given ]]
function(ixm_generate_unity_build_file target path)
  set(sources $<TARGET_PROPERTY:${target},INTERFACE_SOURCES>)
  file(GENERATE
    OUTPUT $<TARGET_PROPERTY:${target},UNITY_BUILD_LOCATION>
    CONTENT "$<$<BOOL:${sources}>:#include <$<JOIN:${sources},$<ANGLE-R>\n#include<>$<ANGLE-R>>"
    CONDITION $<BOOL:${sources}>)
endfunction()
