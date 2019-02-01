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
  ixm_fetch_git_package(${package} ${ARGN} SCHEME ssh:// SEPARATOR ":")
endfunction()

#[[ Git https ]]
function (ixm_fetch_web ${package})
  ixm_fetch_git_package(${package} ${ARGN} SCHEME https:// SEPARATOR "/")
endfunction()

#[[ JFrog's BinTray ]]
function (ixm_fetch_bin)
  #  ixm_fetch_https_package(${package} ${ARGN}
  #    DOMAIN "https://dl.bintray.com/"
endfunction()

#[[ S3 Buckets ]]
function (ixm_fetch_s3b)
  # parse(
  #   @ARGS=1 ENDPOINT ACCESS_KEY SECRET_ACCESS_KEY REGION ENV_AUTH PROVIDER ACL
  #   LOCATION_CONSTRAINT SERVER_SIDE_ENCRYPTION STORAGE_CLASS
  # )
#ixm_fetch_https_package(${package} ${ARGN})
endfunction()

#[[ URL ]]
function (ixm_fetch_url)
endfunction()

#[[ add_subdirectory (used to be `extern()`) ]]
function (ixm_fetch_add package)
  ixm_fetch_script_subdirectory(${package} ${ARGN})
endfunction()

#[[ cmake -P script ]]
function (ixm_fetch_use package)
  ixm_fetch_script_run(${package} ${ARGN})
endfunction()

#[[ CVS ]]
function (ixm_fetch_cvs)
endfunction()

#[[ subversion ]]
function (ixm_fetch_svn)
endfunction()
