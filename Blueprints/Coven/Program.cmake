include_guard(GLOBAL)

function (coven_program_init)
  coven_program_create_bin_targets()
  coven_program_create_dir_targets()
endfunction ()

function (coven_program_create_dir_targets)
  file(GLOB mains
    LIST_DIRECTORIES OFF
    CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/src/*/main.*")
  if (NOT mains)
    return()
  endif()
  foreach (main IN LISTS mains)
    file(RELATIVE_PATH main "${PROJECT_SOURCE_DIR}/src" ${main})
    get_filename_component(name "${main}" DIRECTORY)
    set(target ${PROJECT_NAME}-${name})
    add_executable(${target} ${file})
    add_executable(${PROJECT_NAME}::${name} ALIAS ${target})
    target_link_libraries(${target}
      PRIVATE
        $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
    set_target_properties(${target}
      PROPERTIES
        OUTPUT_NAME ${name}
        EXPORT_NAME ${name})
    dict(APPEND coven::${PROJECT_NAME} INSTALL ${target})
  endforeach()
endfunction()
