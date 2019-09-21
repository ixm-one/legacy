include_guard(GLOBAL)

function(aspect @aspect:action @aspect:name)
  void(WITH AS)
  if (@aspect:action STREQUAL "SET")
    parse(${ARGN} @ARGS=+ WITH)
    string(TOLOWER "${\@aspect\:name}" @aspect:name)
    set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY 🈯::${\@aspect\:name} ${WITH})
  elseif (@aspect:action STREQUAL "GET")
    parse(${ARGN} @ARGS=? AS)
    assign(@aspect:as ? AS : "${\@aspect\:name}")
    string(TOLOWER "${\@aspect\:name}" @aspect:name)
    get_property(@aspect:current DIRECTORY PROPERTY 🈯::${\@aspect\:name})
    get_property(@aspect:root DIRECTORY "${CMAKE_SOURCE_DIR}"
      PROPERTY
        🈯::${\@aspect\:name})
    if (DEFINED PROJECT_SOURCE_DIR)
      get_property(@aspect:project DIRECTORY "${PROJECT_SOURCE_DIR}"
        PROPERTY
          🈯::${\@aspect\:name})
    endif()
    get_property(@aspect:ixm DIRECTORY "${ixm_SOURCE_DIR}"
      PROPERTY
        🈯::${\@aspect\:name})
    assign(@aspect:value ? @aspect:root @aspect:project @aspect:current @aspect:ixm)
    if (NOT DEFINED @aspect:value)
      return()
    endif()
    set(${\@aspect\:as} ${\@aspect\:value} PARENT_SCOPE)
  endif()
endfunction()
