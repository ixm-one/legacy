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
  if (NOT ARGN)
    error("Find(${action}) requires at least one argument")
  endif()
  if (NOT DEFINED CMAKE_FIND_PACKAGE_NAME)
    error("Find(${action}) may only be used in a find_package() module")
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
function (ixm_find_common_components)
  set(${CMAKE_FIND_PACKAGE_NAME}_FOUND OFF)
  if (NOT TARGET ${CMAKE_FIND_PACKAGE_NAME}::${CMAKE_FIND_PACKAGE_NAME})
    return()
  endif()

  foreach (component IN LISTS ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
    if (${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${component})
      list(APPEND required-components ${component})
    else()
      list(APPEND optional-components ${component})
    endif()
  endforeach()
  foreach (component IN LISTS required-components)
    if (NOT TARGET ${CMAKE_FIND_PACKAGE_NAME}::${component})
      set(${CMAKE_FIND_PACKAGE_NAME}_FOUND OFF)
      return()
    endif()
  endforeach()
endfunction()
