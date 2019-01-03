include_guard(GLOBAL)

#[[ SYNOPSIS

This module holds functions and macros related to source file generators. This
includes more modern wrappers around tools such as protobuf.

#]]

include(PushState)

push_module_path(Generators)
include(Protobuf)
pop_module_path()
