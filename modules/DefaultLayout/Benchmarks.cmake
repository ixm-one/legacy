include_guard(GLOBAL)

function (ixm_layout_add_benchmarks)
  file(GLOB items
    LIST_DIRECTORIES ON
    CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/bench/*")
  foreach (item IN LISTS items)
    if (IS_DIRECTORY item)
      ixm_layout_add_integration_benchmark(${item})
    else()
      ixm_layout_add_benchmark(${item})
    endif()
  endforeach()
endfunction()

function (ixm_layout_add_integration_benchmark directory)
endfunction()

function (ixm_layout_add_benchmark)
endfunction()
