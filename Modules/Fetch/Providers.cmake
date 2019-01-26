include_guard(GLOBAL)

# All builtin provider commands are located here

#[[ hub.aliasa.io ]]
function (ixm_fetch_hub package)
  ixm_fetch_aliasa_package(${package} ${ARGN} PROVIDER hub)
endfunction()

#[[ lab.aliasa.io ]]
function (ixm_fetch_lab package)
  ixm_fetch_aliasa_package(${package} ${ARGN} PROVIDER lab)
endfunction()

#[[ bit.aliasa.io ]]
function (ixm_fetch_bit package)
  ixm_fetch_aliasa_package(${package} ${ARGN} PROVIDER bit)
endfunction()

#[[ Git SSH ]]
function (ixm_fetch_ssh ${package})
  ixm_fetch_git_package(${package} ${ARGN} SCHEME ssh://)
endfunction()

#[[ Git https ]]
function (ixm_fetch_web ${package})
  ixm_fetch_git_package(${package} ${ARGN} SCHEME https://)
endfunction()

#[[ JFrog's BinTray ]]
function (ixm_fetch_bin)
endfunction()

#[[ S3 Buckets ]]
function (ixm_fetch_s3b)
endfunction()

#[[ URL ]]
function (ixm_fetch_url)
endfunction()

#[[ add_subdirectory ]]
function (ixm_fetch_add)
endfunction()

#[[ invoke() ]]
function (ixm_fetch_cmd)
endfunction()

#[[ cmake -P script ]]
function (ixm_fetch_use)
endfunction()

#[[ CVS ]]
function (ixm_fetch_cvs)
endfunction()

#[[ subversion ]]
function (ixm_fetch_svn)
endfunction()
