include_guard(GLOBAL)

# DNS UUID 6ba7b810-9dad-11d1-80b4-00c04fd430c8

function (ixm_check_common_prepare out name)
  string(TOUPPER "${name}" item)
  string(REPLACE "::" ":" item "${item}")
  string(MAKE_C_IDENTIFIER "HAVE_${item}" variable)
  set(${out} ${variable} PARENT_SCOPE)
endfunction()

function (ixm_check_common_hash output name)
  get_property(is-found CACHE ${variable} PROPERTY VALUE)
  get_property(hash CACHE 🈯::hash::${variable} PROPERTY VALUE)

  get_property(blueprint DIRECTORY PROPERTY ixm::blueprint::name)
  assign(blueprint ? blueprint ? : "cmake")
  string(TOLOWER "${blueprint}" blueprint)
  string(TOLOWER "${name}" name)
  string(JOIN "&" uri "one.ixm.${blueprint}/${PROJECT_NAME}/check/${name}?" ${ARGN})
  string(UUID uuid
    NAMESPACE 6ba7b810-9dad-11d1-80b4-00c04fd430c8
    NAME "${uri}"
    TYPE SHA1)
  if (uuid STREQUAL hash AND is-found)
    set(${output} ON PARENT_SCOPE)
    set(🈯::hash::${variable} ${uuid} CACHE INTERNAL "${variable} hash")
  else()
    set(${output} OFF PARENT_SCOPE)
  endif()
endfunction()

# TODO: This entire thing needs a *massive* overhaul. It's very tricky, and
# could with a little work, be cleaned up and made more generic. It would
# require breaking it up into multiple arguments however
function (ixm_check_common_symbol name)
 endfunction()
