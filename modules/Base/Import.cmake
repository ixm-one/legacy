include_guard(GLOBAL)

macro(import name)
  get_filename_component(IXM_CURRENT_MODULE ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
  include(${CMAKE_CURRENT_LIST_DIR}/${IXM_CURRENT_MODULE}/${name}.cmake)
  unset(IXM_CURRENT_MODULE)
endmacro()
