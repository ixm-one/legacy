#include_guard(GLOBAL)
#
##generate(PROTO)
## TODO: Several things are needed for this to be "proper".
## However, this is being 'copied' from older sources and cleanup just ever so
## slightly.
## Mostly, the interface properties are not supported, nor are any of these
## properties defined. As a result, we need to make this gets handled correctly.
## TODO: Support protobuf plugins
#function (ixm_generate_protobuf_sources target source)
#  genexp(protobuf-path $<JOIN:
#    $<TARGET_PROPERTY:${target},PROTOBUF_PATH>,$<SEMICOLON>--proto_path=
#  >
#  aspect(GET path:generate AS directory)
#  set(output_directory "${directory}/protobuf/${target}")
#  add_custom_command(
#    OUTPUT ${output_files}
#    COMMAND ${CMAKE_COMMAND} -E make_directory
#      $<TARGET_PROPERTY:${target},PROTOBUF_OUTPUT_DIRECTORY>
#    COMMAND $<TARGET_PROPERTY:${target},PROTOBUF_COMPILER>
#      $<$<CXX_COMPILER_ID:MSVC>:--error_format=msvs>
#      --proto_path ${protobuf-path}
#      --cpp_out=${output_directory}
#
#    COMMENT "Generating protobuf files for ${target}"
#    COMMAND_EXPAND_LISTS
#    VERBATIM)
#endfunction()
#
#function (ixm_generate_protobuf_sources target)
#  log(FATAL "This command is not properly implemented")
#  set(MKDIR_COMMAND ${CMAKE_COMMAND} -E make_directory)
#  set(error-format $<$<CXX_COMPILER_ID:MSVC>:--error_format=msvs>)
#  genexp(output-directory $<TARGET_PROPERTY:${target},PROTOBUF_OUTPUT_DIR>)
#  genexp(proto-path $<TARGET_PROPERTY:${target},PROTOBUF_PATH>)
#  genexp(proto-path $<
#    $<BOOL:${proto-path}>:--proto_path=$<JOIN:${proto-path}>
#  >)
#  genexp(output-directory $<IF:
#    $<BOOL:${output-directory}>,
#    ${output-directory},
#    ${CMAKE_CURRENT_BINARY_DIR}/IXM/protobuf/${target}
#  >)
#  add_custom_command(
#    COMMAND ${MKDIR_COMMAND} ${output-directory}
#    COMMAND Protobuf::Compiler # TODO: This needs a way to be found
#      ${error-format}
#      --cpp_out=${output-directory}
#      ${proto-path}
#    COMMENT "Generating protobuf sources for '${target}'"
#    COMMAND_EXPAND_LISTS
#    VERBATIM)
#  target_include_directories(${target} PRIVATE ${output-directory})
#endfunction()
