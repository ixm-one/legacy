include_guard(GLOBAL)

include(CheckIPOSupported)

function (target_ipo_support target)
  check_ipo_supported(RESULT ${target}_IPO_SUPPORTED)
  set_target_properties(${target} PROPERTIES
    INTERPROCEDURAL_OPTIMIZATION_RELEASE ${target}_IPO_SUPPORTED)
endfunction ()
