include_guard(GLOBAL)

find_package(Protobuf)

function (target_sources_proto target visibility)
  set(interface PUBLIC;INTERFACE)
  set(private PRIVATE;PUBLIC)
  if (visibility IN_LIST interface)
    set_property(${name} ${target} APPEND
      PROPERTY
        INTERFACE_PROTOBUF_SOURCES "${ARGN}")
  endif()
  if (visibility IN_LIST private)
    set_property(${name} ${target} APPEND
      PROPERTY
        PROTOBUF_SOURCES "${ARGN}")
  endif()
endfunction()
