include_guard(GLOBAL)

define_property(PROTOBUF_SOURCES SCOPE TARGET HELP [[
List of .proto files added to a given target

A list of .proto files added to a given target. Each one is generated into
the C++ files.
]])

define_property(PROTOBUF_PATH SCOPE TARGET HELP [[
Paths to --proto_path that propagate to other targets

Given a set of paths, each one is passed with a -I (or rather, a --proto_path
for debuggability on the commandline) to protoc.
]])
