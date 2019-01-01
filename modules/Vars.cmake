include_guard(GLOBAL)

# We place all pre-determined IXM related variables here.
# TODO: We might need to also move all properties here?

list(APPEND IXM_SOURCE_EXTENSIONS ${CMAKE_CXX_SOURCE_FILE_EXTENSIONS})
list(APPEND IXM_SOURCE_EXTENSIONS ${CMAKE_C_SOURCE_FILE_EXTENSIONS})
list(REMOVE_DUPLICATES IXM_SOURCE_EXTENSIONS)
