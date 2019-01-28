import(IXM::API::Find)

Find(FRAMEWORK)

Find(LIBRARY mbedTLS INCLUDE mbedtls/version.h)
Find(LIBRARY mbedcrypto COMPONENT Crypto)

ixm_add_package(mbedTLS
  LIBRARIES mbedtls
  PATHS mbedtls/version.h)

ixm_add_package_component(mbedTLS
  NAME Crypto
  LIBRARIES mbedcrypto)

ixm_package_create(Cocoa)
ixm_package_find_library(Cocoa)
ixm_package_find_path(Cocoa/Cocoa.h)
ixm_pacakge_import(Cocoa::Cocoa
  INCLUDE_DIRECTORIES ${Cocoa_INCLUDE_DIRS}
  LINK_LIBRARIES ${Cocoa_LIBRARY})
ixm_package_finish()

ixm_detect_library(Cocoa)
ixm_detect_path(Cocoa/Cocoa.h)

ixm_detect_library(Cocoa_LIBRARY Cocoa) # Returns if it can't be found
ixm_detect_path(Cocoa_INCLUDE_DIRS Cocoa/Cocoa.h) # Returns if it can't be found
ixm_detect_import(Cocoa
  INCLUDE_DIRECTORIES ${Cocoa_INCLUDE_DIRS}
  LINK_LIBRARIES ${Cocoa_LIBRARY})

ixm_detect_package(Cocoa)
ixm_detect_library(NAMES Cocoa)
ixm_detect_include(Cocoa/Cocoa.h)

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
