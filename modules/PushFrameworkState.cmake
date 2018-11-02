include_guard(GLOBAL)

#[[ SYNOPSIS

Helper macro to help implement find_package calls for frameworks,
effectively doing so in one line.

]]
macro (push_framework_state value)
  list(APPEND IXM_CMAKE_FIND_FRAMEWORK ${value})
  set(CMAKE_FIND_FRAMEWORK ${value})
endmacro()

macro (pop_framework_state value)
  list(GET IXM_CMAKE_FIND_FRAMEWORK -1 CMAKE_FIND_FRAMEWORK)
  list(REMOVE_AT IXM_CMAKE_FIND_FRAMEWORK -1)
endmacro()
