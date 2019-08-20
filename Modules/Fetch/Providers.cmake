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
    github
    "https://github.com"
    "https://codeload.github.com/${root}/${name}/zip/${tag}")
  set(${out-var} ${github} PARENT_SCOPE)
endfunction()

# LAB{user/repo@rev-parse}
function (ixm_fetch_lab package out-var)
  ixm_fetch_recipe_advanced(${package} HEAD)
  ixm_fetch_platform(
    ${package}
    gitlab
    "https://gitlab.com"
    "${uri}/${root}/${name}/-/archive/${tag}/${name}-${tag}.zip")
  set(${out-var} ${gitlab} PARENT_SCOPE)
endfunction()

# BIT{user/repo@rev-parse}
function (ixm_fetch_bit package out-var)
  ixm_fetch_recipe_advanced(${package} HEAD)
  ixm_fetch_platform(
    ${package}
    bitbucket
    "https://bitbucket.org"
    "${uri}/${root}/${name}/get/${tag}")
  set(${out-var} ${bitbucket} PARENT_SCOPE)
endfunction()

# BIN{subject/repo@file-path}
function (ixm_fetch_bin package out-var)
  ixm_fetch_recipe_advanced(${package})
  # Additional customization points
  var(tag tag ${PATH})
  if (NOT tag)
    log(FATAL "BIN{${package}} requires an explicit path to be given")
  endif()
  set(arguments URL)
  if (PREMIUM)
    list(APPEND arguments "https://${root}.bintray.com/${name}/${tag}")
  else()
    list(APPEND arguments "https://dl.bintray.com/${root}/${name}/${tag}")
  endif()
  # TODO: Check for env vars for http proxies before setting this
  list(APPEND arguments TLS_VERIFY ON)
  if (USERNAME AND PASSWORD)
    list(APPEND HTTP_USERNAME ${USERNAME})
    list(APPEND HTTP_PASSWORD ${PASSWORD})
  endif()
  set(${out-var} ${arguments})
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
  dict(GET ${dict} USERNAME username)
  dict(GET ${dict} PASSWORD password)
  dict(GET ${dict} REPOSITORY repository)
  dict(GET ${dict} REVISION revision)
  var(tag tag "${revision}")
  if (NOT repository)
    error("SVN{${package}} requires a repository PATH")
  endif()
  list(APPEND arguments SVN_REPOSITORY ${repository})
  if (username AND password)
    list(APPEND arguments SVN_USERNAME username)
    list(APPEND arguments SVN_PASSWORD password)
  endif()
  if (tag)
    list(APPEND arguments SVN_REVISION -r${tag})
  endif()
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

