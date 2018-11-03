include_guard(GLOBAL)

include(ParentScope)

macro(push_module_path path)
  list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_LIST_DIR}/${path}")
endmacro()

macro(pop_module_path)
  list(REMOVE_AT CMAKE_MODULE_PATH 0)
endmacro()
