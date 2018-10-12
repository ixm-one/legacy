include_guard(GLOBAL)

function (push_find_state package)
  string(TOUPPER ${package} package)
  set(FIND_OPTIONS
    HINTS
      ENV ${package}_ROOT_DIR
      ENV ${package}_DIR
      ENV ${package}DIR
      "${${package}_ROOT_DIR}"
      "${${package}_DIR}"
      "${${package}DIR}"
    PARENT_SCOPE)
endfunction()

function (pop_find_state)
  unset(FIND_OPTIONS PARENT_SCOPE)
endfunction ()

function (reset_find_state)
  unset(FIND_OPTIONS PARENT_SCOPE)
endfunction ()
