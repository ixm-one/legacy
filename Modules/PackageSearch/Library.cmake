include_guard(GLOBAL)

# TODO: Support importing with specific configurations
# TODO: Support importing with specific library types
# TODO: Support importing Object File libraries

function (import_library name)
  argparse(ARGS ${ARGN}
    SETTINGS GLOBAL
    VALUES LOCATION
    LISTS INCLUDES DEFINITIONS FLAGS FEATURES LIBRARIES)

  list(APPEND properties IMPORTED_LOCATION ${ARG_LOCATION})

  if (ARG_GLOBAL)
    set(ARG_GLOBAL GLOBAL)
  endif()

  if (ARG_DEFINITIONS)
    list(APPEND properties INTERFACE_COMPILE_DEFINITIONS ${ARG_DEFINITIONS})
  endif()

  if (ARG_INCLUDES)
    list(APPEND properties INTERFACE_INCLUDE_DIRECTORIES ${ARG_INCLUDES})
  endif ()

  if (ARG_FEATURES)
    list(APPEND properties INTERFACE_COMPILE_FEATURES ${ARG_FEATURES})
  endif()

  if (ARG_OPTIONS)
    list(APPEND properties INTERFACE_COMPILE_OPTIONS ${ARG_FLAG})
  endif()

  if (ARG_LIBRARIES)
    list(APPEND properties INTERFACE_LINK_LIBRARIES ${ARG_LIBRARIES})
  endif()

  if (TARGET ${name})
    get_target_property(LOCATION ${name} IMPORTED_LOCATION)
    if (NOT LOCATION STREQUAL ARG_LOCATION)
      error("TARGET ${name} location mismatch!" ${LOCATION} "!=" ${ARG_LOCATION})
    endif()
    return()
  endif()
  add_library(${name} UNKNOWN IMPORTED ${ARG_GLOBAL})
  set_target_properties(${name} PROPERTIES ${properties})
endfunction ()
