include_guard(GLOBAL)

#[[
For every extension in DIRECTORY property ixm::sources::custom
call `aspect(GET sources:<extension>)`. If nothing is returned OR if NOT COMMAND,
check `if (COMMAND target_sources_<extension>)`. If it does not exist, error.
Otherwise, call the command with
1) target name
2) visibility level
3) each source file found via the unrolled glob expression (if possible)
]]

#[[
Extends the builtin targets_sources function to accept global parameters
automatically. If a file's extension is found to be in the ixm::sources::custom
global property, we instead attempt to *dynamically* invoke
`target_sources_${ext}`. (This may change before the alpha to perform a lookup
on a property and then call that command).
]]
#[[ target(SOURCES <target> [RECURSE] [INTERFACE|PUBLIC|PRIVATE] sources...)]]
function (ixm_target_sources target)
  void(RECURSE INTERFACE PUBLIC PRIVATE)
  parse(${ARGN}
    @FLAGS RECURSE
    @ARGS=* INTERFACE PUBLIC PRIVATE)
  set(glob GLOB)
  if (RECURSE)
    set(glob GLOB_RECURSE)
  endif()
  get_property(custom-extensions GLOBAL PROPERTY ixm::sources::custom)
  foreach (visibility IN ITEMS PRIVATE PUBLIC INTERFACE)
    if (NOT DEFINED ${visibility})
      continue()
    endif()
    # Handle globbing for this specific visibility
    foreach (entry IN LISTS ${visibility})
      string(FIND "${entry}" "*" glob-indicator)
      if (glob-indicator GREATER -1)
        file(${glob} entry CONFIGURE_DEPENDS ${entry})
      endif()
      list(APPEND sources ${entry})
    endforeach()
    foreach (extension IN LISTS custom-extensions)
      set(${extension}-sources ${sources})
      list(FILTER ${extension}-sources INCLUDE REGEX ".*[.]${extension}$")
      list(LENGTH ${extension}-sources length)
      if (length GREATER 0)
        list(APPEND extensions ${extension})
        list(REMOVE_ITEM sources ${${extension}-sources})
      endif()
    endforeach()
    foreach (extension IN LISTS extensions)
      if (NOT COMMAND target_sources_${extension})
        log(FATAL "'target_sources_${extension}' is not a valid command")
      endif()
      invoke(target_sources_${extension}
        ${target}
        ${visibility}
        ${${extension}-sources})
    endforeach ()
    target_sources(${target} ${visibility} ${sources})
  endforeach()
endfunction()
