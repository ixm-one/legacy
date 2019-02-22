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

if (TARGET SCCache::SCCache)
  get_property(CMAKE_CXX_COMPILER_LAUNCHER
    TARGET SCCache::SCCache
    PROPERTY IMPORTED_LOCATION)
  get_property(CMAKE_C_COMPILER_LAUNCHER
    TARGET SCCache::SCCache
    PROPERTY IMPORTED_LOCATION)
endif()

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/.cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

ixm_coven_options_create() #[[Generate project options]]
ixm_coven_library_create() #[[Generate project library]]
ixm_coven_program_create() #[[Generate project program]]

if (BUILD_EXAMPLES)
  ixm_coven_component_create(examples) #[[examples/*.* and examples/*/main.*]]
endif()

if (BUILD_BENCHMARKS)
  ixm_coven_component_create(benches) #[[ benches/*.* and benches/*/*.* ]]
endif()

if (BUILD_TESTS)
  ixm_coven_component_create(tests) #[[ tests/*.* and tests/*/*.* ]]
endif()

if (BUILD_DOCS)
  ixm_coven_create_docs() #[[docs/*.{md|rst}]]
endif()

ixm_coven_create_install() #[[ Various calls to install the above ]]
ixm_coven_create_package() #[[ Packaging settings (creates our own CPackConfig.cmake file) ]]
