include_guard(GLOBAL)

#[[ Prints the current value of the given variables ]]
#[[ SIGNATURE: inspect(<var>...) ]]
macro (inspect)
  foreach (@inspect:var ${ARGV})
    set(CMAKE_MESSAGE_INDENT "${CMAKE_MESSAGE_INDENT}${\@inspect\:var}: ")
    if (DEFINED ${\@inspect\:var})
      list(LENGTH ${\@inspect\:var} @inspect:length)
      if (@inspect:length GREATER 1)
        string(JOIN " " ${\@inspect\:var} ${${\@inspect\:var}})
      endif()
      _message("${\@inspect\:var}: ${${\@inspect\:var}}")
    else()
      _message("${\@inspect\:var}: $<UNDEFINED>")
    endif()
    void(CMAKE_MESSAGE_INDENT @inspect:var @inspect:length @inspect:prefix)
  endforeach()
endmacro()

function (ixm_introspection_filter out-var)
  parse(${ARGN} @ARGS=? KEEP REMOVE @ARGS=* VALUES)
  if (REMOVE)
    list(FILTER VALUES EXCLUDE REGEX "${REMOVE}")
  endif()
  if (KEEP)
    list(FILTER VALUES INCLUDE REGEX "${KEEP}")
  endif()
  set(${out-var} ${VALUES} PARENT_SCOPE)
endfunction()

# TODO: getting a property and then filtering its values is a common operation
# This should be abstracted so we don't keep writing it...

#[[ Sets <out-var> to a list of all macros in the current directory ]]
function (macros out-var)
  get_property(macros DIRECTORY PROPERTY MACROS)
  ixm_introspection_filter(macros ${ARGN} VALUES ${macros})
  set(${out-var} ${macros} PARENT_SCOPE)
endfunction ()

#[[
Sets out-var to a list of all commands in the current build. This is a
"hidden" property, so it's basically a crapshoot if it will ever go away
]]
function (commands out-var)
  get_property(commands GLOBAL PROPERTY COMMANDS)
  ixm_introspection_filter(commands ${ARGN} VALUES ${commands})
  set(${out-var} ${commands} PARENT_SCOPE)
endfunction()

#[[ Sets <out-var> to a list of all functions ]]
function (functions out-var)
  commands(functions ${ARGN})
  if (macros)
    list(REMOVE_ITEM functions ${macros})
  endif()
  set(${out-var} ${functions} PARENT_SCOPE)
endfunction()

#[[ Sets all variable names in the current directory scope to a list ]]
function (locals out-var)
  get_property(variables DIRECTORY PROPERTY VARIABLES)
  ixm_introspection_filter(variables ${ARGN} VALUES ${variables})
  set(${out-var} ${variables} PARENT_SCOPE)
endfunction()

#[[ sets all targets in the current directory (and below) to a list ]]
function (targets out-var)
  get_property(directories DIRECTORY PROPERTY SUBDIRECTORIES)
  foreach (directory IN LISTS directories ITEMS CMAKE_CURRENT_SOURCE_DIR)
    get_property(targets DIRECTORY ${directories} PROPERTY BUILDSYSTEM_TARGETS)
    list(APPEND @targets ${targets})
  endforeach()
  set(${out-var} ${\@targets} PARENT_SCOPE)
endfunction()
