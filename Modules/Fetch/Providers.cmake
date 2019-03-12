include_guard(GLOBAL)

# All builtin provider commands are located here

# HUB{user/repo@rev-parse}
function (ixm_fetch_hub package)
  ixm_fetch_platform_package(${package} ${ARGN} PROVIDER "HUB")
endfunction()

# LAB{user/repo@rev-parse}
function (ixm_fetch_lab package)
  ixm_fetch_platform_package(${package} ${ARGN} PROVIDER "LAB")
endfunction()

# BIT{user/repo@rev-parse}
function (ixm_fetch_bit package)
  ixm_fetch_platform_package(${package} ${ARGN} PROVIDER "BIT")
endfunction()

# BIN{subject/repo@file-path}
function (ixm_fetch_bin)
  error("Not yet implemented")
  ixm_fetch_web_package(${package} ${ARGN} PROVIDER "BIN")
endfunction()

# URL{name}
function (ixm_fetch_url)
  error("Not yet implemented")
  ixm_fetch_web_package(${package} ${ARGN} PROVIDER "ANY")
endfunction()

# ADD{name}
function (ixm_fetch_add package)
  ixm_fetch_script_subdirectory(${package} ${ARGN})
endfunction()

# USE{name}
function (ixm_fetch_use package)
  ixm_fetch_script_run(${package} ${ARGN})
endfunction()

# GIT{repo@rev-parse}
function (ixm_fetch_git package)
  ixm_fetch_vcs_git(${package} ${ARGN})
endfunction()

# SVN{name@revision}
function (ixm_fetch_svn package)
  ixm_fetch_vcs_svn(${package} ${ARGN})
endfunction()

# CVS{root/module@tag}
function (ixm_fetch_cvs package)
  ixm_fetch_vcs_cvs(${package} ${ARGN})
endfunction()

# HG{name@tag}
function (ixm_fetch_hg package)
  ixm_fetch_vcs_hg(${package} ${ARGN})
endfunction()

