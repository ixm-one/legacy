include_guard(GLOBAL)

include(ParentScope)

function (__default_glob output path)
  foreach (ext IN LISTS CMAKE_CXX_SOURCE_FILE_EXTENSIONS
                        CMAKE_C_SOURCE_FILE_EXTENSIONS)
    file(GLOB sources CONFIGURE_DEPENDS ${path}.${ext})
    foreach (src IN LISTS sources)
      list(APPEND ${output} ${src})
    endforeach()
  endforeach()
  parent_scope(${output})
endfunction ()

function (__default_extra_executables)
  __default_glob(entrypoints ${PROJECT_SOURCE_DIR}/src/*/main)
  foreach (main IN LISTS entrypoints)
    get_filename_component(dir ${main} DIRECTORY)
    get_filename_component(name ${dir} NAME)
    add_executable(${name})
    foreach (ext IN LISTS CMAKE_CXX_SOURCE_FILE_EXTENSIONS
                          CMAKE_C_SOURCE_FILE_EXTENSIONS)
      target_glob_sources(${name} PRIVATE ${dir}/*.${ext})
    endforeach ()
  endforeach ()
endfunction ()
