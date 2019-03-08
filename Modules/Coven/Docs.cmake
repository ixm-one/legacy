include_guard(GLOBAL)

function (ixm_coven_documentation_create)
  if (NOT BUILD_DOCS)
    return()
  endif()
  add_documentation(docs HTML)
  #  ixm_use_sphinx_add_target(docs HTML)
endfunction()
