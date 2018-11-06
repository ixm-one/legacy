include_guard(GLOBAL)

function (target_glob_sources target)
  argparse(
    ARGS ${ARGN}
    OPTIONS RECURSE
    LISTS INTERFACE PUBLIC PRIVATE)

  set(INTERFACE_SOURCES)
  set(PRIVATE_SOURCES)
  set(PUBLIC_SOURCES)
  set(glob GLOB)

  if (ARG_RECURSE)
    set(glob GLOB_RECURSE)
  endif()

  any_of(required DEFINED ARG_INTERFACE ARG_PRIVATE ARG_PUBLIC)
  if (NOT required)
    error("target_glob_sources requires at least one of: INTERFACE PUBLIC PRIVATE")
    return()
  endif()

  if (DEFINED ARG_INTERFACE)
    file(${glob} interface CONFIGURE_DEPENDS ${ARG_INTERFACE})
    list(APPEND INTERFACE_SOURCES INTERFACE ${interface})
  endif()

  if (DEFINED ARG_PRIVATE)
    file(${glob} private CONFIGURE_DEPENDS ${ARG_PRIVATE})
    list(APPEND PRIVATE_SOURCES PRIVATE ${private})
  endif()

  if (DEFINED ARG_PUBLIC)
    file(${glob} public CONFIGURE_DEPENDS ${ARG_PUBLIC})
    list(APPEND PUBLIC_SOURCES PUBLIC ${public})
  endif()

  target_sources(${target}
    ${INTERFACE_SOURCES}
    ${PRIVATE_SOURCES}
    ${PUBLIC_SOURCES})
endfunction()
