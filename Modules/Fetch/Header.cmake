include_guard(GLOBAL)

# TODO: Move to Vars module
set(IXM_HEADER_DIR "${IXM_FILES_DIR}/header")

# Useful for some libraries, such as Catch2 or nlohmann::json
function (header url)
  parse(${ARGN}
    @FLAGS INSTALL QUIET
    @ARGS=? ALIAS)
  get_filename_component(name ${url} NAME_WE)
  get_filename_component(file ${url} NAME)

  set(source_dir ${PROJECT_BINARY_DIR}/_deps/${name}-src)
  set(binary_dir ${PROJECT_BINARY_DIR}/_deps/${name}-build)

  get(alias ALIAS ${name})
  set(target ${name})

  if (NOT EXISTS ${source_dir}/${file})
    file(DOWNLOAD ${url} ${source_dir}/${file})
  endif()
  
  add_library(${name} INTERFACE)
  target_include_directories(${name} INTERFACE ${source_dir})

  ixm_fetch_common_target(${target} ${alias})

  set(${alias}_SOURCE_DIR ${source_dir} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${binary_dir} PARENT_SCOPE)
endfunction()
