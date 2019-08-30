include_guard(GLOBAL)

#generate(PROTO)
# TODO: Several things are needed for this to be "proper".
# However, this is being 'copied' from older sources and cleanup just ever so
# slightly.
# Mostly, the interface properties are not supported, nor are any of these
# properties defined. As a result, we need to make this gets handled correctly.
# TODO: Support protobuf plugins
function (ixm_generate_protobuf_sources target)
  set(MKDIR_COMMAND ${CMAKE_COMMAND} -E make_directory)
  set(error-format $<$<CXX_COMPILER_ID:MSVC>:--error_format=msvs>)
  genexp(output-directory $<TARGET_PROPERTY:${target},PROTOBUF_OUTPUT_DIR>)
  genexp(proto-path $<TARGET_PROPERTY:${target},PROTOBUF_PATH>)
  genexp(proto-path $<
    $<BOOL:${proto-path}>:--proto_path=$<JOIN:${proto-path}>
  >)
  genexp(output-directory $<IF:
    $<BOOL:${output-directory}>,
    ${output-directory},
    ${CMAKE_CURRENT_BINARY_DIR}/IXM/protobuf/${target}
  >)
  add_custom_command(
    COMMAND ${MKDIR_COMMAND} ${output-directory}
    COMMAND Protobuf::Compiler # TODO: This needs a way to be found
      ${error-format}
      --cpp_out=${output-directory}
      ${proto-path}
    COMMENT "Generating protobuf sources for '${target}'"
    COMMAND_EXPAND_LISTS
    VERBATIM)
  target_include_directories(${target} PRIVATE ${output-directory})
endfunction()