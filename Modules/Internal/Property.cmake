include_guard(GLOBAL)

#[[
A smaller, better, form of define_property, which also is added to a custom
target called define-properties. 

This override also allows us to keep track of ALL properties that should be
copied when we use `target_copy_properties` for interface/private visibility.

The signature change depends on what the first value is. If it is one of the
known scopes, we pass it on to the old signature. Otherwise, we use our new
signature. If there is no SCOPE passed in, we assume it is defined as SOURCE.

Documentation is not important, as we place that information inside separate
files. However, it is useful when actively developing a library.
]]
function (define_property scope-or-property)
  set(known-scopes GLOBAL DIRECTORY TARGET SOURCE TEST CACHED_VARIABLE)
  if (scope-or-property IN_LIST known-scopes)
    _define_property(${scope-or-property} ${ARGN})
    list(GET ARGN 1 name)
    set_property(GLOBAL APPEND PROPERTY IXM_KNOWN_PROPERTIES "${name}")
    return()
  endif()

  parse(${ARGN}
    @FLAGS PRIVATE # Implies no INTERFACE_ and no INHERITED
    @ARGS=? HELP SCOPE)
  list(APPEND args ${SCOPE} PROPERTY ${scope-or-property})
  if (NOT PRIVATE)
    list(APPEND args INHERITED)
  endif()
  if (NOT HELP)
    set(HELP "<none>")
  endif()
  list(APPEND args BRIEF_DOCS "${HELP}")
  list(APPEND args FULL_DOCS "${HELP}")
  _define_property(${args} BRIEF_DOCS " " FULL_DOCS "${HELP}")
  if (NOT PRIVATE)
    list(TRANSFORM args PREPEND INTERFACE_ AT 2)
    _define_property(${args} BRIEF_DOCS "" FULL_DOCS "${HELP}")
  endif()
endfunction()
