include(FindPackage)

push_find_state(Realtime)
find_library(Realtime_LIBRARY rt)
find_path(Realtime_INCLUDE_DIRS NAMES time.h)
pop_find_state()

check_find_package(Realtime LIBRARY INCLUDE_DIRS)
halt_unless(Realtime LIBRARY INCLUDE_DIRS FOUND)
import_library(Realtime::Realtime
  INCLUDES ${Realtime_INCLUDE_DIRS}
  LOCATION ${Realtime_LIBRARY} GLOBAL)
