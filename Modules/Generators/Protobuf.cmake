define_property(TARGET
  PROPERTY INTERFACE_PROTO_SOURCES INHERITED
  BRIEF_DOCS "List of .proto files added to a given target"
  FULL_DOCS [=[
A list of .proto files added to a given target. Each one is generated into the
C++ 
]=])

function (ixm_generate_protobuf_sources target)
  ixm_parse(${ARGN}
    @ARGS=? SOURCE_EXTENSION HEADER_EXTENSION
  )
  set(MKDIR_COMMAND ${CMAKE_COMMAND} -E make_directory)
  set(COPY_COMMAND ${CMAKE_COMMAND} -E copy_if_different)
  set(TARGET_PROTOBUF_PATH $<TARGET_PROPERTY:${target},PROTOBUF_PATH>)
  ixm_var(HEADER_EXTENSION HEADER_EXTENSION "hpp")
  ixm_var(SOURCE_EXTENSION SOURCE_EXTENSION "cc")
  if (MSVC)
    set(error_format "--error_format=msvs")
  endif()
  get_filename_component(root ${proto} DIRECTORY)
  get_filename_component(name ${proto} NAME_WE)
  file(RELATIVE_PATH output_dir ${PROJECT_SOURCE_DIR} ${root})
  set(target_protobuf_dir "${PROJECT_BINARY_DIR}/IXM/protobuf/${output}")
  add_custom_command(
    COMMAND ${MKDIR_COMMAND} ${target_protobuf_dir}
    COMMAND protoc
      ${error_format}
      --cpp_out=${target_protobuf_dir}
      $<$<BOOL:${TARGET_PROTOBUF_PATH}>:--proto_path=$<JOIN:${TARGET_PROTOBUF_PATH}>>)
    add_custom_target(${target} DEPENDS)
  add_dependencies(${target} ${custom})
endfunction()
