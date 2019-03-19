include_guard(GLOBAL)

# All builtin provider commands are located here

function (ixm_fetch_platform package out-var clone-uri default-uri)
  var(uri URI "${clone-uri}")
  if (CLONE)
    list(APPEND arguments GIT_REPOSITORY "${uri}/${root}/${name}.git")
    list(APPEND arguments GIT_SHALLOW ON)
    list(APPEND arguments GIT_TAG ${tag})
  else()
    list(APPEND arguments URL "${default-uri}")
    list(APPEND arguments TLS_VERIFY ON)
  endif()
  set(${out-var} ${arguments} PARENT_SCOPE)
endfunction()

# HUB{user/repo@rev-parse}
function (ixm_fetch_hub package out-var)
  ixm_fetch_recipe_advanced(${package} HEAD)
  ixm_fetch_platform(
    ${package}
    ${out-var}
    "https://github.com"
    "https://codeload.github.com/${root}/${name}/zip/${tag}")
  upvar(${out-var})
endfunction()

# LAB{user/repo@rev-parse}
function (ixm_fetch_lab package out-var)
  ixm_fetch_recipe_advanced(${package} HEAD)
  ixm_fetch_platform(
    ${package}
    ${out-var}
    "https://gitlab.com"
    "${uri}/${root}/${name}/-/archive/${tag}/${name}-${tag}.zip")
  upvar(${out-var})
endfunction()

# BIT{user/repo@rev-parse}
function (ixm_fetch_bit package out-var)
  ixm_fetch_recipe_advanced(${package} HEAD)
  ixm_fetch_platform(
    ${package}
    ${out-var}
    "https://bitbucket.org"
    "${uri}/${root}/${name}/get/${tag}")
  set(${out-var} ${arguments} PARENT_SCOPE)
endfunction()

# BIN{subject/repo@file-path}
function (ixm_fetch_bin package out-var)
  error("Not yet implemented")
  #ixm_fetch_web_package(${package} ${ARGN} PROVIDER "BIN")
endfunction()

# URL{name}
function (ixm_fetch_url package out-var)
  error("Not yet implemented")
  #ixm_fetch_web_package(${package} ${ARGN} PROVIDER "ANY")
endfunction()

# ADD{name}
function (ixm_fetch_add package out-var)
  error("Not yet implemented")
  ixm_fetch_script_subdirectory(${package} ${ARGN})
endfunction()

# USE{name}
function (ixm_fetch_use package out-var)
  error("Not yet implemented")
  ixm_fetch_script_run(${package} ${ARGN})
endfunction()

# GIT{name@rev-parse}
function (ixm_fetch_git package out-var)
  ixm_fetch_recipe_basic(${package} HEAD)
  if (NOT PATH)
    error("GIT requires a PATH option to be set")
  endif()
  list(APPEND arguments GIT_REPOSITORY "${PATH}")
  list(APPEND arguments GIT_SHALLOW ON)
  list(APPEND arguments GIT_TAG ${tag})
  set(${out-var} ${arguments} PARENT_SCOPE)
endfunction()

# SVN{name@revision}
function (ixm_fetch_svn package out-var)
  ixm_fetch_recipe_basic(${package})
  error("Not yet implemented")
endfunction()

# CVS{root/module@tag}
function (ixm_fetch_cvs package out-var)
  ixm_fetch_recipe_advanced(${package})
  error("Not yet implemented")
endfunction()

# HG{name@tag}
function (ixm_fetch_hg package out-var)
  ixm_fetch_recipe_basic(${package} default)
  if (NOT PATH)
    error("HG requires a PATH option to be set")
  endif()
  list(APPEND arguments HG_REPOSITORY "${PATH}")
  list(APPEND arguments HG_TAG ${tag})
  set(${out-var} ${arguments} PARENT_SCOPE)
endfunction()

