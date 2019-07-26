include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

import(IXM::Coven::*)
import(IXM::Fetch::*)

ixm_coven_library_create() #[[Generate project library]]
ixm_coven_program_create() #[[Generate project program]]

ixm_coven_component_create(examples) #[[examples/*.* and examples/*/main.*]]

ixm_coven_documentation_create() #[[docs/*.{md|rst}]]
