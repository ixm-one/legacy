include_guard(GLOBAL)

function (ixm_layout_generate_targets directory)
  argparse(ARGS ${ARGN}
    OPTIONS TEST
    VALUES PREFIX)

  file(GLOB items
    LIST_DIRECTORIES ON
    CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/${directory}/*")
  foreach (item IN LISTS items)
    if (IS_DIRECTORY item)
      ixm_layout_generate_integrations(${item})
    else()
      ixm_layout_generate_target(${item})
    endif()
  endforeach()
endfunction()

function (ixm_layout_create_target path)
  get_filename_component(name ${path} NAME_WE)
  set(target ${PROJECT_NAME}-${name})
  add_executable(${target})
  if (DEFINED ARG_TEST)
    add_test(${ARG_PREFIX}-${target} ${target})
  endif()
  target_link_libraries(${target}
    PRIVATE $<TARGET_NAME_IF_EXISTS:${PROJECT_NAME}::${PROJECT_NAME}>
  parent_scope(target)
endfunction()

function (ixm_layout_generate_target file)
  ixm_layout_create_target(${file})
  target_sources(${target} PRIVATE ${file})
endfunction()

function (ixm_layout_generate_integrations directory prefix)
  ixm_layout_create_target(${directory})
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files
      LIST_DIRECTORIES OFF
      CONFIGURE_DEPENDS
      "${directory}/*.${ext}")
    if (NOT files)
      continue()
    endif()
    target_sources(${target} PRIVATE ${files})
  endforeach()
endfunction()

function (ixm_layout_add_benchmarks)
  ixm_layout_generate_targets(bench TEST PREFIX bench)
endfunction()

function (ixm_layout_add_tests)
  ixm_layout_generate_targets(tests TEST PREFIX test)
endfunction()

function (ixm_layout_add_examples)
  ixm_layout_generate_targets(examples)
endfunction()
