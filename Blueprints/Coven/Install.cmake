include_guard(GLOBAL)

function (coven_install_init)
  if (EXISTS "${PROJECT_SOURCE_DIR}/include/")
    install(DIRECTORY include/ TYPE INCLUDE)
  endif()
endfunction ()
