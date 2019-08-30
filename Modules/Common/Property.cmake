include_guard(GLOBAL)

# This allows us to keep track of all properties that should be copied when we
# use `target_copy_properties` for interface/private visibility
function (ixm_property_define name)
  parse(${ARGN}
    @ARGS=? HELP SCOPE
    @FLAGS PRIVATE)
  set(known-scopes GLOBAL DIRECTORY TARGET SOURCE TEST CACHED_VARIABLE)
  assign(scope ? SCOPE : TARGET) 
  if (NOT scope IN_LIST known-scopes)
    error("${scope} is not a supported property")
  endif()
  list(APPEND args ${scope} PROPERTY ${name})
  if (NOT PRIVATE)
    list(APPEND args INHERITED)
  endif()
  if (NOT HELP)
    set(HELP "<none>")
  endif()
  define_property(${args} BRIEF_DOCS " " FULL_DOCS "${HELP}")
  set_property(GLOBAL APPEND PROPERTY IXM_KNOWN_${scope}_PROPERTIES "${name}")
  list(TRANSFORM args PREPEND INTERFACE_ AT 2)
  define_property(${args} BRIEF_DOCS " " FULL_DOCS "${HELP}")
  set_property(GLOBAL APPEND
    PROPERTY IXM_KNOWN_${scope}_INTERFACE_PROPERTIES "${name}")
endfunction()
