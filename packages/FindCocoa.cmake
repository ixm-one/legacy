include(FindPackage)

push_framework_state(ONLY)
push_find_state(Cocoa)
find_library(Cocoa_LIBRARY Cocoa)
find_path(Cocoa_INCLUDE_DIRS NAMES Cocoa/Cocoa.h)
pop_framework_state()
pop_find_state()

check_find_package(Cocoa LIBRARY INCLUDE_DIRS)
halt_unless(Cocoa LIBRARY INCLUDE_DIRS FOUND)
import_library(Cocoa::Cocoa
  INCLUDES ${Cocoa_INCLUDE_DIRS}
  LOCATION ${Cocoa_LIBRARY} GLOBAL)
