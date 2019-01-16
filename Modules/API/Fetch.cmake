include_guard(GLOBAL)

# TODO: Add IXM_FETCH_API_PROVIDERS as a cache variable, values are all providers
# TODO: Add IXM_FETCH_API_<PROVIDERS> as a cache variable (of some kind)

set(IXM_FETCH_API_PROVIDERS HUB LAB BIT WEB SSH URL ADD USE BIN S3B SVN CVS CMD)


#[[
This function prepares all the Fetch API providers for a regex, so we can do a
"dynamic" lookup of their URL template
]]
function (ixm_fetch_providers_prepare var)
  if (NOT IXM_FETCH_API_PROVIDERS_REGEX)
    foreach (provider IN LISTS IXM_FETCH_API_PROVIDERS)
      string(REGEX REPLACE "([A-Z])" "\[\\1\]" prepared ${provider})
      list(APPEND providers ${prepared})
    endforeach()
    list(JOIN providers "|" providers)
    set(IXM_FETCH_API_PROVIDERS_REGEX ${providers} CACHE INTERNAL
      "Regex for finding valid Fetch providers")
  endforeach()
  set(${var} ${IXM_FETCH_API_PROVIDERS_REGEX} PARENT_SCOPE)
endfunction()

#[[
This "repairs" the input to a Fetch call so that it can span several lines if
users desire
]]
function (ixm_fetch_resource_repair var)
  string(REPLACE ";" "" ${var} ${ARGN})
  upvar(${var})
endfunction()

#[[
Prepares the resource to receive both the provider and recipe, as well as any

]]
function (ixm_fetch_resource_prepare var)
  ixm_fetch_resource_repair(${var} ${ARGN})
  ixm_fetch_providers_prepare(providers)
  string(REGEX REPLACE "(${providers}){(.*)}" "\\1;\\2" ${var} ${var})
  upvar(${var})
endfunction()

function (Fetch)

endfunction()
