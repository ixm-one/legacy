include_guard(GLOBAL)

#[[ SYNOPSIS

This module is an amalgamation of various functions and macros to aid in
implementing find_package for libraries, executables, and frameworks (macOS)

]]

include(PushFrameworkState)
include(PushFindState)

include(ImportExecutable)
include(ImportLibrary)

include(CheckFindPackage)
include(Hide)
include(Halt)
