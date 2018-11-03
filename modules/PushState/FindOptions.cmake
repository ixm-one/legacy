include_guard(GLOBAL)

macro (push_find_state package)
  string(TOUPPER ${package} pkg)
  set(FIND_OPTIONS
    HINTS
      ENV ${pkg}_ROOT_DIR
      ENV ${pkg}_DIR
      ENV ${pkg}DIR
      "${${pkg}_ROOT_DIR}"
      "${${pkg}_DIR}"
      "${${pkg}DIR}")
endmacro()

macro (pop_find_state)
  unset(FIND_OPTIONS)
endmacro()
