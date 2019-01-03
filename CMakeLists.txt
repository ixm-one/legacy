#[[
This is basically our bootstrap file. All statements placed here are done so
specifically so once we are included, we can not only rely on ourselves (and
thus dogfood our behavior!) but we are also able to set a few cache vars and
work *around* some of CMake's proclivities.
]]
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/languages)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/packages)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Modules)

set(IXM_ROOT "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "IXM installation root")

# These files do not depend on each other and *thus* we do not care about their
# order of inclusion except as to make them look nice.
# Additonally, each function inside *is* now namespace with the exception of
# a few macros. These macros can be disabled by users by setting the 
# IXM_ENABLE_MACRO option to false.
# Each macro can also be disabled on a case by case basis. This could
# potentially cause problems with dependencies downstream, so please be careful
include("${IXM_ROOT}/Modules/Internal/Import.cmake")
include("${IXM_ROOT}/Modules/Internal/Invoke.cmake")
include("${IXM_ROOT}/Modules/Internal/Enable.cmake")
include("${IXM_ROOT}/Modules/Internal/Parse.cmake") # The "new" ArgParse
include("${IXM_ROOT}/Modules/Internal/Scope.cmake") # DONE (for now~)
include("${IXM_ROOT}/Modules/Internal/Macro.cmake") # Options and macro wrappers

# TODO: Planned modules are
# IXM::Internal::* # Auto 'imported'
# IXM::Project::Properties STANDALONE, etc
# IXM::Project::Commands
# IXM::Project::Layout
# IXM::Project::Cache
# IXM::Project::Fetch # Our version of FetchContent (inspired by ExternalData)
# IXM::Detect::Component # Special way to find components for package
# IXM::Detect::Library # Our version of find_library
# IXM::Detect::Program # Our version of find_program
# IXM::Detect::Package # Our version of find_package
# IXM::Detect::Version # Our way of finding the actual version of a packaget
# IXM::Detect::File # Our Version of find_file
# IXM::Detect::Path # Our version of find_path
# IXM::Check::Headers # Can the compiler support including the given headers
# IXM::Check::Symbols # Can the compiler support the given symbols?
# IXM::Check::Flags # Does the compiler support the given flag?
# IXM::Check::Type # Does the given decltype(type) compile successfully?
# IXM::Check::File # Does the given file compile successfully?
# IXM::Check::Code # Does the given code compile successfully?
# TODO: More tool paths, right?
# IXM::Tool::Cython
# IXM::Tool::Bloaty
# IXM::Tool::SCCache
# IXM::Tool::CCache
# IXM::Tool::ClangFormat
# IXM::Tool::ClangCheck
# IXM::Tool::ClangTidy
# IXM::Tool::IWYU
# IXM::Tool::Python
# IXM::Tool::Poetry
# IXM::Tool::Pip

# These are less for Importing and more for general target adding.

# IXM::Generators::Protobuf
# IXM::Generators::Cython
# IXM::Generators::SpirV
# IXM::Generators::Unity # Unity Builds!
# IXM::Generators::Header # Amalgam Header!
# IXM::Generators::PCH # Precompiled Header!
#
# Additionally, we supply the following language support:
# Rust
# Golang
#
# We also try supply the following layouts:
# Coven
# Pitchfork (support coming soon?)

# Now we can start using them "safely".
# We do our DAMNDEST to never let this be overriden
ixm_internal(IXM_MODULE_ROOT
  "${CMAKE_CURRENT_LIST_DIR}/modules/IXM.cmake"
  "Root module for the IXM library")
ixm_internal(IXM_BINARY_DIR
  "${CMAKE_CURRENT_BINARY_DIR}"
  "Directory for generated files for the IXM Library")
