include_guard(GLOBAL)

#Find(PACKAGE CCache)
find_package(CCache)

if (TARGET CCache::CCache)
  foreach (language IN ITEMS CXX C)
    get_property(CMAKE_${language}_COMPILER_LAUNCHER
      TARGET CCache::CCache
      PROPERTY IMPORTED_LOCATION)
  endforeach ()
endif()
