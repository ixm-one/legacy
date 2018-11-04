include_guard(GLOBAL)

include(PushState)

#[[ SYNOPSIS

This module is an amalgamation of various functions and macros to aid in
implementing find_package for libraries, executables, and frameworks (macOS)

]]

push_module_path(PackageSearch)
include(Component) # Formerly CheckComponent
include(Library) # Formerly ImportLibrary
include(Program) # Formerly ImportExecutable
include(Check) # Formerly CheckFindPackage
include(Hide)
include(Halt)
pop_module_path()

include(PushFrameworkState)
include(PushFindState)

include(ImportExecutable)
include(ImportLibrary)

include(CheckFindPackage)
include(Hide)
include(Halt)
