include_guard(GLOBAL)

function (ixm_detect_library name)
  find_library(${name}_LIBRARY ${name})
  ixm_parse(${ARGN}
    @FLAGS LOCAL
    @ARGS=? LOCATION
    @ARGS=*

      INCLUDE_DIRECTORIES

      COMPILE_DEFINITIONS
      COMPILE_FEATURES
      COMPILE_OPTIONS

      LINK_DIRECTORIES
      LINK_LIBRARIES
      LINK_OPTIONS)
endfunction()
