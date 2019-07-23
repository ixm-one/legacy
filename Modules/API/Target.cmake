include_guard(GLOBAL)

import(IXM::Target::*)

# Given a directory, it will glob all files and then add them to the given
# target, while still using the unity-build option.
function (target_module)
endfunction()

function(target_precompiled_header target)
endfunction()

# Like target_link_libraries, but copies all custom IXM properties
function(target_copy_properties target)
  get_property(interface-properties GLOBAL PROPERTY IXM_INTERFACE_PROPERTIES)
  get_property(private-properties GLOBAL PROPERTY IXM_PRIVATE_PROPERTIES)

  parse(${ARGN} @ARGS=* PRIVATE PUBLIC INTERFACE)

  # TODO: make target verification occur *outside* of copy loops
  foreach (tgt IN LISTS PRIVATE PUBLIC)
    if (NOT TARGET ${tgt})
      error("'${tgt}' is not a known target")
    endif()
    foreach (property IN LISTS private-properties)
      get_target_property(value ${tgt} ${property})
      if (NOT value)
        continue()
      endif()
      set_property(TARGET ${target} APPEND PROPERTY ${property} ${value})
    endforeach()
  endforeach()
endfunction()
#[[
Extends the builtin target_sources function to accept glob parameters
automatically. If a file's extension is found to be in the
IXM_CUSTOM_EXTENSIONS global property, we instead attempt to *dynamically*
invoke target_sources_${ext}
]]
function (target_sources target)
  parse(${ARGN}
    @FLAGS RECURSE
    @ARGS=* INTERFACE PUBLIC PRIVATE)
  set(glob GLOB)
  if (RECURSE)
    set(glob GLOB_RECURSE)
  endif()
  if (NOT (INTERFACE OR PUBLIC OR PRIVATE))
    error(
      "target_sources requires at least"
      "PRIVATE, PUBLIC, or INTERFACE as the second parameter")
  endif()
  get_property(custom-extensions GLOBAL PROPERTY IXM_CUSTOM_EXTENSIONS)
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
        error("COMMAND target_sources_${extension} not found")
      endif()
      invoke(target_sources_${extension}
        ${target}
        ${visibility}
        ${${extension}-sources})
    endforeach()
    _target_sources(${target} ${visibility} ${sources})
  endforeach()
endfunction()
