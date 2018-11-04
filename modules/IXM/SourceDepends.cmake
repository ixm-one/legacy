include_guard(GLOBAL)

# A better version of AddFileDependencies because it's a function and thus 
# won't pollute the scope with a _deps variable
function (source_depends file)
  get_source_file_property(deps ${file} OBJECT_DEPENDS)
  list(APPEND deps ${ARGN})
  set_source_files_properties(${file} PROPERTIES OBJECT_DEPENDS ${deps})
endfunction()
