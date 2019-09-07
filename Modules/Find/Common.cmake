include_guard(GLOBAL)

function (ixm_find_common_names var)
  set(${var} ${CMAKE_FIND_PACKAGE_NAME}::${CMAKE_FIND_PACKAGE_NAME} PARENT_SCOPE)
  set(name ${CMAKE_FIND_PACKAGE_NAME} PARENT_SCOPE)

  if (NOT COMPONENT)
    return()
  endif()

  set(name ${CMAKE_FIND_PACKAGE_NAME}_${COMPONENT} PARENT_SCOPE)
  set(${var} ${CMAKE_FIND_PACKAGE_NAME}::${COMPONENT} PARENT_SCOPE)
endfunction()

function (ixm_find_common_check action)
  list(LENGTH ARGN length)
  if (NOT length)
    log(FATAL "find(${action}) requires at least one argument")
  endif()
  if (action STREQUAL PACKAGE)
    return()
  endif()
  if (NOT DEFINED CMAKE_FIND_PACKAGE_NAME)
    log(FATAL "find(${action}) may only be used in a find_package() module")
  endif()
endfunction()

function (ixm_find_common_hints var)
  string(TOUPPER ${name} pkg)
  set(${var}
    ENV ${pkg}_ROOT_DIR
    ENV ${pkg}_DIR
    ENV ${pkg}DIR
    "${${name}_ROOT_DIR}"
    "${${name}_DIR}"
    "${${name}DIR}"
    "${${pkg}_ROOT_DIR}"
    "${${pkg}_DIR}"
    "${${pkg}DIR}"
    PARENT_SCOPE)
endfunction()

# TODO: Come up with a better name
# TODO: Put shared behavior into this function, as its not being used correctly
function (ixm_find_common_append var)
  set(required-component ${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${COMPONENT})
  if (DEFINED ${required-component})
    dict(APPEND ixm::find::${CMAKE_FIND_PACKAGE_NAME} REQUIRED ${var})
  endif()
endfunction()