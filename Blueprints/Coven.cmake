include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

import(IXM::Use::Clang::Format)
import(IXM::Use::Clang::Check)
import(IXM::Use::Clang::Tidy)
import(IXM::Use::Sphinx)
import(IXM::Use::IWYU)

import(IXM::Coven::*)
import(IXM::Fetch::*)

#cvn_create_options() #[[ Generate project options ]]
#coven_generate_options()
#coven_generate_component(examples)
#coven_generate_component(benches)
#coven_generate_component(tests)

ixm_coven_common_launcher(SCCache::SCCache)
ixm_coven_common_launcher(CCache::CCache)

ixm_coven_library_create() #[[Generate project library]]
ixm_coven_program_create() #[[Generate project program]]

ixm_coven_component_create(examples) #[[examples/*.* and examples/*/main.*]]
ixm_coven_component_create(benches) #[[benches/*.* and benches/*/*.*]]
ixm_coven_component_create(tests) #[[tests/*.* and tests/*/*.*]]

# ixm_coven_fetch_dependencies() #[[ Sets up generator expression for ixm::fetch ]]

ixm_coven_documentation_create() #[[docs/*.{md|rst}]]

ixm_coven_create_package() #[[Packaging settings]]
