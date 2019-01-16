include_guard(GLOBAL)

create_property(TARGET RESPONSE_FILE PUBLIC INHERITED [[

Path to a response file for compiling the given item.

A response file that is created at build system generation time based on the
followig flags:

 * CMAKE_<LANG>_FLAGS_<CONFIG>
 * INTERFACE_INCLUDE_DIRECTORIES
 * INTERFACE_COMPILE_DEFINITIONS
 * INTERFACE_COMPILE_OPTIONS
 * INTERFACE_COMPILE_FLAGS
 * INTERFACE_LINK_DIRECTORIES
 * INTERFACE_LINK_LIBRARIES
 * INTERFACE_LINK_OPTIONS
]])

define_property(TARGET
  PROPERTY INTERFACE_RESPONSE_FILE INHERITED
  BRIEF_DOCS "Path to a response file for compiling the given item"
  FULL_DOCS [[
Path to a response file that is created at generation time based on the
following flags:

 * CMAKE_<LANG>_FLAGS_<CONFIG>
 * INTERFACE_INCLUDE_DIRECTORIES
 * INTERFACE_COMPILE_DEFINITIONS
 * INTERFACE_COMPILE_OPTIONS
 * INTERFACE_COMPILE_FLAGS
 * INTERFACE_LINK_DIRECTORIES
 * INTERFACE_LINK_LIBRARIES
 * INTERFACE_LINK_OPTIONS
]])

define_property(TARGET
  PROPERTY RESPONSE_FILE INHERITED
  BRIEF_DOCS "Path to a response file for compiling the given item"
  FULL_DOCS [[
Path to a response file that is created at generation time based on the
following flags:

 * CMAKE_<LANG>_FLAGS_<CONFIG>
 * INCLUDE_DIRECTORIES
 * COMPILE_DEFINITIONS
 * COMPILE_OPTIONS
 * COMPILE_FLAGS
 * LINK_DIRECTORIES
 * LINK_LIBRARIES
 * LINK_OPTIONS

Some of these settings may be disabled based on their use.
]])
