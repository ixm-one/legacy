include_guard(GLOBAL)

# NOT YET IMPLEMENTED
function (coven_docs_init)
  # FIXME: The output vars are currently not used...
  coven_detect_hyde(hyde-config) # Relies on Jekyll, so we need to do this one first
  coven_detect_jekyll(jekyll-config)
  coven_detect_mkdocs(mkdocs-config)
  coven_detect_sphinx(sphinx-config)
  coven_detect_gohugo(gohugo-config)
endfunction()
