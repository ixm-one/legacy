include_guard(GLOBAL)

# Control Flow (yes... control flow)

import(Option) # CMakeDependentOption/PROJECT_NAME support builtin
import(Return) # Given any arguments, it becomes like a return_if
import(Target) # Enhanced target_${NAME} functions
import(Find) # Find functions, handle a bit of additional environment stuff
import(Add) # add_subdirectory/add_executable override
            # Adds second time no-nop add_subdirectory
            # Adds support for an APPIMAGE flag for add_executable

# Miscellaneous
#import(DefineProperty) # Registers properties with IXM
#import(Project)        # Used for some... "magic" with IXM :)
#import(TryCompile)     # Can pass in a TARGET for compile flags
#import(TryRun)         # Same as above
#
#import(CMake)          # For cmake_minimum_required
#import(Property)       # Some stuff for modifying non-IMPORTED ALIAS libraries
                       # Some stuff for tracking properties
                       # (Might combine Target/Property with Project into one
                       # file)
                       # Also lets add a new "PROJECT" scope for some
                       # properties related to IXM
