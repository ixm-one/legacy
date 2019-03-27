include_guard(GLOBAL)

#[[ TODO: Add support for:
 * MkDocs
 * Jekyll
 * Doxygen
 * Hugo
]]
function (ixm_coven_documentation_create)
  if (NOT BUILD_DOCS)
    return()
  endif()
  add_documentation(docs HTML)
  #  ixm_use_sphinx_add_target(docs HTML)
endfunction()
