include_guard(GLOBAL)

function (ixm_import_module name)
  argparse(${ARGN}
    @FLAGS ROOT)
  get_property(cached_module_path CACHE @${IXM_CURRENT_MODULE}::${name})
  include(${cached_module_path} OPTIONAL RESULT_VARIABLE IXM_CURRENT_MODULE_FILE)
  if (IXM_CURRENT_MODULE_FILE)
    parent_scope(IXM_CURRENT_MODULE_FILE)
    return()
  endif()
  set(qualname ${IXM_CURRENT_MODULE}::${name})
  string(REPLACE "::" ";" lookup ${qualname})
  list(REMOVE_ITEM lookup "")
  list(LENGTH lookup length)
  # This means a "root" module was passed. Try to include it. If we couldn't,
  # then we error with a custom message!
  # TODO: need to set IXM_CURRENT_MODULE in parent_scope
  if (NOT DEFINED IXM_CURRENT_MODULE AND length EQUAL 1)
    include(${${lookup}_MODULE_ROOT} OPTIONAL RESULT_VARIABLE IXM_CURRENT_MODULE)
    if (NOT IXM_CURRENT_MODULE)
      error([[
        Could not locate IXM Module Root for '${name}'.
        Is ${lookup}_MODULE_ROOT defined?
      ]])
    endif()
  endif()
  stack(POP lookup final) # XXX: needs better name for this variable
  foreach (module IN LISTS lookup)
  endforeach()
endfunction()

macro(import name)
  ixm_import_module(${name} ${ARGN}) # parent_scope(IXM_CURRENT_MODULE_FILE)
  include(${IXM_CURRENT_MODULE_FILE})
  stack(POP IXM_MODULE_PATH IXM_CURRENT_MODULE)

  #include(${CMAKE_CURRENT_LIST_DIR}/${IXM_CURRENT_MODULE}/${name}.cmake)
endmacro()

macro(module name)
  include_guard(GLOBAL)
  set(${name}_MODULE_ROOT
    ${CMAKE_CURRENT_LIST_FILE}
    CACHE
    INTERNAL
    "Module Root for '${name}'")
  list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
endmacro()
