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

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/.cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

#[[Generates all possible targets based on location]]
ixm_coven_generate_targets() 
ixm_coven_generate_component_program() # these refer to src/bin/*.{ext} and src/*/main.{ext}
ixm_coven_generate_component_library() # These refer to all modules as one, plus src/*/lib.{ext}
ixm_coven_generate_modules() # New rules for "modules", so we can move to proper modules later

#[[
In order of execution we do:

 * Generate primary library (src/[!main]*.{ext}) (then cache the extension)
 * Generate primary executable (src/main.{ext})
 * Generate additional libraries (src/*/*[!main].{ext})
 * Generate additional executables (src/*/main.{ext})
 * Generate explicit executables (src/bin/*.{ext})

]]

# These are always run, but will return if the given setting isn't true
ixm_coven_generate_benchmarks() #[[ Generate Benchmarks ]]
ixm_coven_generate_examples() #[[ Generate Examples ]]
ixm_coven_generate_tests() #[[ Generate Tests (acquire DocTest/Catch here)]]
ixm_coven_generate_docs() #[[ Generate Docs ]]

ixm_coven_generate_install() #[[ Various calls to install ]]
#[[ Various settings for CPack(Do we generate our own CPackConfig.cmake file?) ]]
ixm_coven_generate_package() 

# Then users can do a Fetch(HUB{dependency-here}) call, and it will auto-link
# in most cases.
# last question is:
# 1) How do we handle optional features? (add a function called feature?)
# 2) How do we handle automatic adding of find_package calls? (Hell if I know)
