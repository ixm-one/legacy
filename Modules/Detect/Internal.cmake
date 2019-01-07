include_guard(GLOBAL)

function(ixm_detect_options name)
  string(TOUPPER ${name} pkg)
  set(IXM_FIND_OPTIONS
    HINTS
      ENV ${pkg}_ROOT_DIR
      ENV ${pkg}_DIR
      ENV ${pkg}DIR
      "${${name}_ROOT_DIR}"
      "${${name}_DIR}"
      "${${name}DIR}"
      "${${pkg}_ROOT_DIR}"
      "${${pkg}_DIR}"
      "${${pkg}DIR}")
  ixm_upvar(IXM_FIND_OPTIONS)
endfunction()
