include_guard(GLOBAL)

include(ParentScope)

function (push_module_path path)
  get_filename_component(path ${path} ABSOLUTE
    BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
  list(INSERT CMAKE_MODULE_PATH 0 ${path})
  parent_scope(CMAKE_MODULE_PATH)
endfunction()

function(pop_module_path)
  list(REMOVE_AT CMAKE_MODULE_PATH 0)
  parent_scope(CMAKE_MODULE_PATH)
endfunction()
