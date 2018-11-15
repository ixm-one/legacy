include_guard(GLOBAL)

function(ixm_layout_support_generate directory)
  file(GLOB items
    LIST_DIRECTORIES ON
    "${PROJECT_SOURCE_DIR}/${directory}/*")
  foreach (item IN LISTS items)
    if (IS_DIRECTORY item)
      list(APPEND directories ${item})
    endif()
  endforeach()
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files
      LIST_DIRECTORIES OFF
      CONFIGURE_DEPENDS
      "${PROJECT_SOURCE_DIR}/${directory}/*.${ext}")
    list(APPEND sources ${files})
  endforeach ()
  foreach (input IN LISTS directories sources)
    ixm_layout_support_create(${input} ${ARGN})
    if (NOT IS_DIRECTORY ${input})
      target_sources(${target} PRIVATE ${input})
    else()
      foreach(ext IN LISTS IXM_SOURCE_EXTENSIONS)
        target_glob_sources(${target} PRIVATE "${input}/*.${ext}")
      endforeach()
    endif()
  endforeach()
endfunction()

function (ixm_layout_support_create path)
  argparse(ARGS ${ARGN} VALUES PREFIX)
  get_filename_component(name ${path} NAME_WE)
  set(target ${PROJECT_NAME}-${name})
  add_executable(${target})
  if (DEFINED ARG_PREFIX)
    add_test(${ARG_PREFIX}-${target} ${target})
  endif()
  target_link_libraries(${target}
    PRIVATE $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
  parent_scope(target name)
endfunction()
