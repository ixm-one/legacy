include_guard(GLOBAL)

function(ixm_layout_support_generate directory)
  file(GLOB items
    LIST_DIRECTORIES ON
    "${PROJECT_SOURCE_DIR}/${directory}/*")
  foreach (item IN LISTS items)
    if (IS_DIRECTORY ${item})
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
  parse(${ARGN} @ARGS=? PREFIX)
  get_filename_component(name ${path} NAME_WE)
  set(name ${PROJECT_NAME}-${name})
  if (DEFINED PREFIX)
    set(target ${PREFIX}-${name})
    add_test(${target} ${target})
  endif()
  add_executable(${target})
  target_link_libraries(${target}
    PRIVATE $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>)
  parent_scope(target)
endfunction()
