include_guard(GLOBAL)

function (map action target)
  if (NOT TARGET ${target})
    add_library(${target} INTERFACE IMPORTED)
  endif()
  verify_actions(map ${action})
  invoke(${map} ${target} ${ARGN})
endfunction()

function (ixm_map_contains target key out-var)
  get_property(out TARGET ${target} PROPERTY INTERFACE_${key} SET)
  set(${out-var} ${out} PARENT_SCOPE)
endfunction()

function (ixm_map_append target key)
  if (NOT ARGN)
    error("map(APPEND) requires at least one value to be appended")
  endif()
  set_property(TARGET ${target} APPEND PROPERTY INTERFACE_${key} ${ARGN})
endfunction()

function (ixm_map_assign target key)
  if (NOT ARGN)
    error("map(ASSIGN) requires at least one value to be assigned")
  endif()
  set_property(TARGET ${target} PROPERTY INTERFACE_${key} ${ARGN})
endfunction()

function (ixm_map_remove target)
  if (NOT ARGN)
    error("map(REMOVE) requires at least one key to be removed")
  endif()
  foreach (key IN LISTS ARGN)
    set_property(TARGET ${target} PROPERTY INTERFACE_${key})
  endforeach()
endfunction()

function (ixm_map_get target key var)
  get_property(out TARGET ${target} PROPERTY INTERFACE_${key})
  set(${var} ${out} PARENT_SCOPE)
endfunction()


