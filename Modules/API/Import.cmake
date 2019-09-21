include_guard(GLOBAL)

# We use this over includes for a better include system
macro(import name)
  ixm_import_find(@import-files ${name})
  foreach (file IN LISTS @import-files)
    include(${file})
  endforeach()
  unset(@import-files)
endmacro()

#[[
This is just a simple wrapper to let a user declare a module, *and* set its
${name}_MODULE_ROOT all in one go.
]]
macro (module name)
  include_guard(GLOBAL)
  set(${name}_MODULE_ROOT "${CMAKE_CURRENT_LIST_DIR}"
    CACHE INTERNAL "Module Root for '${name}'")
endmacro()

#[[
Simple wrapper to declare a module root from inside of a blueprint, and
then import all of the Blueprint's files
]]
macro(blueprint name)
  include_guard()
  set(${name}_MODULE_ROOT "${CMAKE_CURRENT_LIST_DIR}"
    CACHE INTERNAL "Blueprint Module Root for '${name}'")
  import(${name}::*)
endmacro()

#[[ Syntax is fairly simple:
  import(${root}::Submodule) -> ${root}_MODULE_ROOT/Submodule.cmake
  import(${root}::*) -> ${root}_MODULE_ROOT/*.cmake

  # TODO: This would fail twice if it tries to use log(FATAL).
  # Detection with `if(COMMAND log)` is needed before actually calling it.
]]
function (ixm_import_find out-var name)
  string(REPLACE "::" ";" paths ${name})
  list(LENGTH paths length)
  if (length LESS 2)
    log(FATAL "Imports must have a path larger than just the module root!")
  endif()
  list(GET paths 0 root)
  if (NOT DEFINED ${root}_MODULE_ROOT)
    log(FATAL "${root}_MODULE_ROOT is not defined.")
  endif()
  if (NOT IS_DIRECTORY "${${root}_MODULE_ROOT}")
    log(FATAL "${root}_MODULE_ROOT must be a directory")
  endif()
  if (NOT IS_ABSOLUTE "${${root}_MODULE_ROOT}")
    log(FATAL "${root}_MODULE_ROOT must be an absolute path")
  endif()
  list(REMOVE_AT paths 0)
  string(JOIN "/" paths ${paths})
  list(APPEND directories "${${root}_MODULE_ROOT}/${paths}.cmake")
  # Hard code for CMake. This allows us to use `CMakeDependentOption`
  # as CMake::DependentOption
  if (root STREQUAL "CMake")
    list(APPEND directories "${${root}_MODULE_ROOT}/${root}${paths}.cmake")
  endif()
  file(GLOB files LIST_DIRECTORIES OFF ${directories})
  set(${out-var} ${files} PARENT_SCOPE)
endfunction()
