include_guard(GLOBAL)

import(IXM::Common::*)

# This is where all properties, cache values, builtin options, are declared.

# General Global Settings
# This is done to make sure our "generated" files go into ixm-build
global(IXM_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
global(IXM_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
global(IXM_FETCH_DIR "${IXM_BINARY_DIR}/Fetch")
global(IXM_CHECK_DIR "${IXM_BINARY_DIR}/Check")

internal(IXM_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}")
internal(IXM_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
internal(IXM_FETCH_DIR "${IXM_BINARY_DIR}/Fetch")
internal(IXM_CHECK_DIR "${IXM_BINARY_DIR}/Check")
internal(IXM_INVOKE_DIR "${IXM_BINARY_DIR}/Invoke")

global(IXM_PRINT_COLORS "NOT ${WIN32}")
global(IXM_PRINT_QUIET OFF)

# Project Settings
global(IXM_SOURCE_EXTENSIONS cxx;cpp;c++;cc;c;mm;m)
global(IXM_CUSTOM_EXTENSIONS)

global(IXM_INTERFACE_PROPERTIES)
global(IXM_PRIVATE_PROPERTIES)

# XXX: Some of these here are placeholders and might be removed before release
global(IXM_EXAMPLE_PROPERTIES)
global(IXM_LIBRARY_PROPERTIES)
global(IXM_PROGRAM_PROPERTIES)
global(IXM_PACKAGE_PROPERTIES)
global(IXM_TARGET_PROPERTIES)
global(IXM_SOURCE_PROPERTIES)
global(IXM_BENCH_PROPERTIES)
global(IXM_TEST_PROPERTIES)
global(IXM_DOCS_PROPERTIES)
global(IXM_TOOL_PROPERTIES)
global(IXM_DATA_PROPERTIES)

# Fetch Properties
global(IXM_FETCH_PROVIDERS HUB LAB BIT WEB SSH GIT URL ADD USE BIN S3B SVN CVS)
global(IXM_FETCH_HUB ixm_fetch_hub)
global(IXM_FETCH_LAB ixm_fetch_lab)
global(IXM_FETCH_BIT ixm_fetch_bit)
global(IXM_FETCH_WEB ixm_fetch_web)
global(IXM_FETCH_SSH ixm_fetch_ssh)
global(IXM_FETCH_GIT ixm_fetch_git)
global(IXM_FETCH_URL ixm_fetch_url)
global(IXM_FETCH_ADD ixm_fetch_add)
global(IXM_FETCH_USE ixm_fetch_use)
global(IXM_FETCH_BIN ixm_fetch_bin)
global(IXM_FETCH_S3B ixm_fetch_s3b)
global(IXM_FETCH_SVN ixm_fetch_svn)
global(IXM_FETCH_CVS ixm_fetch_cvs)

# Check/Require Properties
global(IXM_CHECK_ACTIONS MEMBER ENUM INCLUDE SIZEOF FLAG STRUCT CLASS)
global(IXM_CHECK_INCLUDE ixm_check_include)
global(IXM_CHECK_MEMBER ixm_check_member)
global(IXM_CHECK_SIZEOF ixm_check_sizeof)
global(IXM_CHECK_STRUCT ixm_check_struct)
global(IXM_CHECK_CLASS ixm_check_class)
global(IXM_CHECK_FLAG ixm_check_flag)
global(IXM_CHECK_ENUM ixm_check_enum)

# Layout Properties
global(IXM_CURRENT_LAYOUT_NAME)
global(IXM_CURRENT_LAYOUT_FILE)

# Cache Variables
cache(PATH IXM_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
cache(PATH IXM_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
cache(BOOL IXM_UNITY_BUILD ON)

list(APPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Languages")
list(APPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Packages")
upvar(CMAKE_MODULE_PATH)
