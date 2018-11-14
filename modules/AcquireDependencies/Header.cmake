include_guard(GLOBAL)

set(IXM_HEADER_DIR header)

# Useful for libraries like Catch2
function (header url)
  argparse(ARGS ${ARGN}
    OPTIONS INSTALL QUIET
    VALUES ALIAS)
  #TODO: Investigate if we need a different approach for getting the filename
  #      and the URL
  get_filename_component(name ${url} NAME_WE)
  get_filename_component(file ${url} NAME)
  set(source_dir ${PROJECT_BINARY_DIR}/${IXM_HEADER_DIR}/${name}-src)
  set(binary_dir ${PROJECT_BINARY_DIR}/${IXM_HEADER_DIR}/${name}-build)

  if (NOT EXISTS ${source_dir}/${file})
    file(DOWNLOAD ${url} ${source_dir}/${file})
  endif()

  get(alias ARG_ALIAS ${name})
  set(target ${name})

  add_library(${name} INTERFACE)
  target_include_directories(${name} INTERFACE ${source_dir})

  ixm_acquire_apply_target(${target} ${alias})

  set(${alias}_SOURCE_DIR ${source_dir} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${binary_dir} PARENT_SCOPE)
endfunction()
