include_guard(GLOBAL)

include(AddFileDependencies)

#[[ SYNOPSIS
This function is a replacement for the AddFileDependencies macro. A separate
macro is provided for backwards compatibility that overrides the old one
]]
function (ixm_extra_source_depends file)
  get_source_file_property(deps ${file} OBJECT_DEPENDS)
  list(APPEND deps ${ARGN})
  set_source_files_properties(${file} PROPERTIES OBJECT_DEPENDS ${deps})
endfunction()

# This overrides the AddFileDependencies macro
macro(add_file_dependencies file)
  ixm_extra_source_depends(${file} ${ARGN})
endmacro()
