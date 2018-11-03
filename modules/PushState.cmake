include_guard(GLOBAL)

# We do this manually to "bootstrap"
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_LIST_DIR}/PushState")
include(FindOptions)
include(ModulePath)
list(REMOVE_AT CMAKE_MODULE_PATH 0)
