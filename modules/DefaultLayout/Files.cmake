include_guard(GLOBAL)

function (__default_files var path)
  foreach (ext IN LISTS IXM_SOURCE_EXTENSIONS)
    file(GLOB files CONFIGURE_DEPENDS ${PROJECT_SOURCE_DIR}/${path}/*.${ext})
    list(APPEND ${var} ${files})
  endforeach ()
  parent_scope(var)
endfunction()
