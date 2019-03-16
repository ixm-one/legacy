find(LIBRARY mbedTLS)
find(LIBRARY mbedcrypto COMPONENT Crypto)
find(LIBRARY mbedx509 COMPONENT x509)
find(INCLUDE mbedtls/version.h)

if (mbedTLS_INCLUDE_DIR)
  file(STRINGS ${mbedTLS_INCLUDE_DIR}/mbedtls/version.h version-file
    REGEX "#define MBEDTLS_VERSION_(MAJOR|MINOR|PATCH).*")
endif()
