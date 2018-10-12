include_guard(GLOBAL)

include(Algorithm)
include(Print)

function (target_glob_sources target)
  set(options RECURSE)
  set(single)
  set(multi INTERFACE PUBLIC PRIVATE)
  cmake_parse_arguments(ARG "${options}" "${single}" "${multi}" ${ARGN})

  set(INTERFACE_SOURCES)
  set(PRIVATE_SOURCES)
  set(PUBLIC_SOURCES)
  set(glob GLOB)

  if (ARG_RECURSE)
    set(glob GLOB_RECURSE)
  endif ()

  any_of(required DEFINED ARG_INTERFACE ARG_PRIVATE ARG_PUBLIC)
  if (NOT required)
    error("target_glob_sources requires any of: INTERFACE PUBLIC PRIVATE")
    return()
  endif()

  if (DEFINED ARG_INTERFACE)
    file(${glob} interface CONFIGURE_DEPENDS ${ARG_INTERFACE})
    list(APPEND INTERFACE_SOURCES INTERFACE ${interface})
  endif ()

  if (DEFINED ARG_PRIVATE)
    file(${glob} private CONFIGURE_DEPENDS ${ARG_PRIVATE})
    list(APPEND PRIVATE_SOURCES PRIVATE ${private})
  endif ()

  if (DEFINED ARG_PUBLIC)
    file(${glob} public CONFIGURE_DEPENDS ${ARG_PUBLIC})
    list(APPEND PUBLIC_SOURCES PUBLIC ${public})
  endif ()

  if (NOT DEFINED INTERFACE_SOURCES OR
      NOT DEFINED PRIVATE_SOURCES OR
      NOT DEFINED PUBLIC_SOURCES)
  endif()

  target_sources(${target}
    ${INTERFACE_SOURCES}
    ${PRIVATE_SOURCES}
    ${PUBLIC_SOURCES})
endfunction ()
