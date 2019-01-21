include_guard(GLOBAL)

#[[
Wrapper around Fetch() API so that the given <name> is used as an ALIAS, but
additionally, if it is NOT enabled the value is never fetched. One thing to
keep in mind is that we currently DO NOT support a "choice selection".
This will be changed in the future.
]]
function (With name spec)
endfunction()

#[[
Better "option()" that also adds several defines and variables so that they are
available in the configure header for the project. This is placed into a file
that is generated at generation time, as opposed to configure_file.
]]
function (Feature name help)
endfunction()
