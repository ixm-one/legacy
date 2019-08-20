include_guard(GLOBAL)

import(IXM::Common::*)

# TODO: Rename this file to "Prelude.cmake"
# TODO: It must be imported/included before any other files in API
# TODO: Remove all instances of IXM specific functions.

# rules for IXM specific settings are:
# Variables are set as UPPERCASE_VARIABLE_NAMES
# This applies for all environment, cache, and scoped variables
# If a variable is for a specific API call, it will be named IXM_<API>_<SETTING>
# Global properties are `namespaced::via::colons`. If global, they are set
# as ixm::<api>::<setting>. Emojis might be used to keep properties "safe" from
# common tampering.
# Target properties are set as UPPERCASE_VARIABLE_NAMES to stay in line with
# CMake itself.
# Blueprint specific properties are set as <blueprint>::<setting>
# Dictionaries are used for project specific settings. These are sometimes
# named like `ixm::<api>::<name>`, such as in the case of ixm::fetch::
# dictionaries. These should be transitioned to something else. e.g.,
# nothing says these can't be `${PROJECT_NAME}::fetch::<name>`, or similar.

set_property(GLOBAL APPEND PROPERTY ixm::actions::fetch git svn cvs hg)
set_property(GLOBAL APPEND PROPERTY ixm::actions::fetch hub lab bit)
set_property(GLOBAL APPEND PROPERTY ixm::actions::fetch bin url)
set_property(GLOBAL APPEND PROPERTY ixm::actions::fetch use add)

# TODO: These should be properties
set(IXM_LOG_STRFTIME "%Y-%b-%d@%H:%M:%S" PARENT_SCOPE)
set(IXM_LOG_FORMAT TEXT PARENT_SCOPE)
set(IXM_LOG_LEVEL TRACE PARENT_SCOPE)
set(IXM_LOG_COLOR ON PARENT_SCOPE)
set(IXM_LOG_ROTATE 5000000 PARENT_SCOPE) # 5MB

# This is where all properties, cache values, builtin options, are declared.

# General Global Settings
global(IXM_PRINT_COLORS "NOT ${WIN32}")
global(IXM_PRINT_QUIET OFF)

# Project Settings
global(IXM_SOURCE_EXTENSIONS cxx;cpp;c++;cc;c;mm;m)
global(IXM_CUSTOM_EXTENSIONS)

# XXX: Some of these here are placeholders and might be removed before release

# Cache Variables
cache(PATH IXM_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
cache(PATH IXM_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
cache(BOOL IXM_UNITY_BUILD ON)
