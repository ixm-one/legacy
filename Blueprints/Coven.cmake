include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

import(IXM::Use::Clang::Format)
import(IXM::Use::Clang::Check)
import(IXM::Use::Clang::Tidy)
import(IXM::Use::Sphinx)
import(IXM::Use::IWYU)

import(IXM::Coven::*)
import(IXM::Fetch::*)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/.cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(SCCache)
find_package(CCache)
find_package(DistCC)

#cvn_common_launcher(SCCache::SCCache)
#cvn_common_launcher(CCache::CCache)
#
#cvn_create_options() #[[ Generate project options ]]
#coven_generate_options()
#coven_generate_component(examples)
#coven_generate_component(benches)
#coven_generate_component(tests)
#coven_create_options()

ixm_coven_common_launcher(SCCache::SCCache)
ixm_coven_common_launcher(CCache::CCache)

ixm_coven_options_create() #[[Generate project options]]
ixm_coven_library_create() #[[Generate project library]]
ixm_coven_program_create() #[[Generate project program]]

ixm_coven_component_create(examples) #[[examples/*.* and examples/*/main.*]]
ixm_coven_component_create(benches) #[[benches/*.* and benches/*/*.*]]
ixm_coven_component_create(tests) #[[tests/*.* and tests/*/*.*]]

# ixm_coven_fetch_dependencies() #[[ Sets up generator expression for ixm::fetch ]]

ixm_coven_documentation_create() #[[docs/*.{md|rst}]]

ixm_coven_create_install() #[[Various calls to install the above]]
ixm_coven_create_package() #[[Packaging settings]]
