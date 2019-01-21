include_guard(GLOBAL)

define_property(TARGET
  PROPERTY INTERFACE_PROTOBUF_SOURCES INHERITED
  BRIEF_DOCS "List of .proto files added to a given target"
  FULL_DOCS
[[
A list of .proto files added to a given target. Each one is generated into
the C++ files.
]])

define_property(TARGET
  PROPERTY INTERFACE_PROTOBUF_PATH INHERITED
  BRIEF_DOCS "Paths to --proto_path that propagate to other targets"
  FULL_DOCS
[[
Given a set of paths, each one is passed with a -I (or rather, a --proto_path
for debuggability on the commandline) to protoc.
]])

define_property(TARGET
  PROPERTY PROTOBUF_SOURCES INHERITED
  BRIEF_DOCS "List of .proto files added to a given target"
  FULL_DOCS
[[
A list of .proto files added to a given target. Each one is generated into
the C++ files.
]])

define_property(TARGET
  PROPERTY PROTOBUF_PATH INHERITED
  BRIEF_DOCS "Paths to --proto_path that propagate to other targets"
  FULL_DOCS
[[
Given a set of paths, each one is passed with a -I (or rather, a --proto_path
for debuggability on the commandline) to protoc.
]])


