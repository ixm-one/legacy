include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

import(IXM::Use::Clang::Format)
import(IXM::Use::Clang::Check)
import(IXM::Use::Clang::Tidy)
import(IXM::Use::SCCache)
import(IXM::Use::Sphinx)
import(IXM::Use::IWYU)

import(IXM::Coven::*)
import(IXM::Fetch::*)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if (SCCache_FOUND)
  set(CMAKE_CXX_COMPILER_LAUNCHER SCCache)
  set(CMAKE_C_COMPILER_LAUNCHER SCcache)
endif()

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/.cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

ixm_coven_create_options() # [[Generate Options Here]]

ixm_coven_create_primary_library()
ixm_coven_create_primary_program()
ixm_coven_create_primary_modules() # [[ "modules" eligible for unity builds ]]
ixm_coven_create_component_programs() # [[ All components in src/bin/*.{ext} ]]
ixm_coven_create_configure_header()   # [[ Project wide configure header ]]

ixm_coven_create_benchmarks() #[[ bench/*.{ext} and bench/*/main.{ext} ]]
ixm_coven_create_examples() #[[ examples/*.{ext} and examples/*/main.{ext} ]]
ixm_coven_create_tests() #[[ tests/*.{ext} and tests/*/main.{ext} ]]
ixm_coven_create_docs() #[[ docs/*.{md|rst} ]]
ixm_coven_create_install() #[[ Various calls to install the above ]]
ixm_coven_create_package() #[[ Packaging settings (creates our own CPackConfig.cmake file) ]]

#[[
In order of execution we do:

 * Generate primary library (src/[!main]*.{ext}) (then cache the extension)
 * Generate primary executable (src/main.{ext})
 * Generate additional libraries (src/*/*[!main].{ext})
 * Generate additional executables (src/*/main.{ext})
 * Generate explicit executables (src/bin/*.{ext})

]]

# Then users can do a Fetch(HUB{dependency-here}) call, and it will auto-link
# in most cases.
# last question is:
# 1) How do we handle optional features? (add a function called feature?)
# 2) How do we handle automatic adding of find_package calls? (Hell if I know)
