include_guard(GLOBAL)

define_property(RESPONSE_FILE SCOPE TARGET HELP [[

Path to a response file that can be used to compile anything

This file is created at build system generation time based on the
following flags:

 * CMAKE_<LANG>_FLAGS_<CONFIG>
 * INCLUDE_DIRECTORIES
 * COMPILE_DEFINITIONS
 * COMPILE_OPTIONS
 * COMPILE_FLAGS
 * LINK_DIRECTORIES
 * LINK_LIBRARIES
 * LINK_OPTIONS
]])
