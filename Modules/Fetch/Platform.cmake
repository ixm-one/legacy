include_guard(GLOBAL)

# This is the shared set of functions for git based platforms like github,
# gitlab, bitbucket, etc.

function (ixm_fetch_platform_package package)
  parse(${ARGN}
    @FLAGS ALL QUIET CLONE
    @ARGS=1 PROVIDER
    @ARGS=? ALIAS TARGET PATCH
    @ARGS=* POLICIES TARGETS OPTIONS)
  if (NOT QUIET OR NOT IXM_FETCH_QUIET)
    info("[FETCH]: ${package}")
  endif()

  ixm_fetch_common_check_target()
  ixm_fetch_platform_recipe(${package}) # sets user, repo, rev

  var(target TARGET ${repo})
  var(alias ALIAS ${repo})

  ixm_fetch_common_exclude()
  ixm_fetch_platform_download()

  #[[PATCH]]
  ixm_fetch_common_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_common_options("${OPTIONS}")
  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${all})

  #[[ TARGET ]]
  ixm_fetch_common_target(${target} ${alias})
  upvar(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()

function (ixm_fetch_platform_recipe package)
  string(REGEX MATCH "([^/]+)/([^@/]+)(@.+)?" matched ${package})
  if (NOT matched)
    error("Could not understand package recipe: '${package}'")
  endif()
  set(user "${CMAKE_MATCH_1}" PARENT_SCOPE)
  set(repo "${CMAKE_MATCH_2}" PARENT_SCOPE)
  var(rev CMAKE_MATCH_3 HEAD)
  string(REPLACE "@" "" rev ${rev})
  upvar(rev)
endfunction()

function (ixm_fetch_platform_download)
  if (CLONE)
    list(APPEND properties IXM_FETCH_${PROVIDER}_CLONE_${alias})
    list(APPEND properties IXM_FETCH_${PROVIDER}_CLONE)

    foreach (property IN LISTS properties)
      get_property(url GLOBAL PROPERTY ${property})
      if (url)
        break()
      endif()
    endforeach()
    if (NOT url)
      error("Cannot find CLONE URL for '${alias}'")
    endif()
    set(declare-args
      GIT_REPOSITORY "${url}/${user}/${repo}.git"
      GIT_SHALLOW ON
      GIT_TAG ${rev})
  else()
    if (PROVIDER STREQUAL "HUB")
      set(url "https://codeload.github.com/${user}/${repo}/zip/${rev}")
    elseif (PROVIDER STREQUAL "LAB")
      set(url "https://gitlab.com/${user}/${repo}/-/archive/${rev}/${user}-${rev}.zip")
    elseif (PROVIDER STREQUAL "BIT")
      set(url "https://bitbucket.org/${user}/${repo}/get/${rev}")
    else()
      error("Unknown provider '${PROVIDER}'")
    endif()
    set(declare-args URL "${url}")
  endif()

  FetchContent_Declare(${alias} ${declare-args})
  FetchContent_GetProperties(${alias})
  if (NOT ${alias}_POPULATED)
    FetchContent_Populate(${alias})
  endif()
  upvar(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()
