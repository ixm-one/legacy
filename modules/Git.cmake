include_guard(GLOBAL)

include(ParentScope)
include(AddPackage)
include(Fetch)
include(Print)

find_package(Git REQUIRED)

#[=[ SYNOPSIS

XXX: This entire module will either be named AcquirePackages,
AcquireDependencies, or AcquireProjects. Most likely it'll be named
AcquireDependencies

These all share a common set of flags. This is good!

Aliases are also automatically run through target_link_libraries to
${PROJECT_NAME}/

If a given repository *does not* have a CMakeLists.txt, it will instead try to
`add_package(${PROJECT_SOURCE_DIR}/[.cmake|cmake]/patch/${ALIAS})`, or rather,
it'll generate a minimal CMakeLists.txt, while also inserting a patch file
via CMAKE_${PROJECT_NAME}_INCLUDE_FILE. The exact semantics are yet to be seen.

This allows subprojects for non-CMake based builds


NOTE: gitlab/bitbucket/github all have the same signature
github(<repo[@tag]>
  [ALIAS <name>]
  [[TARGET <library>] | [TARGETS <libraries>...]]
  [POLICIES <CMPNNNN>...]
  [OPTIONS <option> <value>...]
  [INSTALL]
  [QUIET])

gitssh(<repo[@tag]>
       [DOMAIN <host>]
       [ALIAS <name>]
       [[TARGET <library>] | [TARGETS <libraries>...]]
       [POLICIES <CMPNNNN>...]
       [OPTIONS <option> <value>...]
       [INSTALL]
       [QUIET])

githttps(<repo[@tag]>
         [DOMAIN <host>]
         [ALIAS <name>]
         [[TARGET <library> | [TARGETS <libraries>...]]
         [POLICIES <CMPNNNN> <ON|OFF>...]
         [OPTIONS <option> <value>...]
         [INSTALL]
         [QUIET])

archive(<url>
        [ALIAS <name>]
        [[TARGET <library> | [TARGETS <libraries>...]]
        [POLICIES <CMPNNNN>...]
        [OPTIONS <option> <value>...]
        [INSTALL]
        [QUIET])

Autoconfigures subproject located in the primary project. It *must* be located
at `${PROJECT_SOURCE_DIR}/extern/${name}`.

extern(<name>
       [ALIAS <name>]
       [[TARGET <library>] | [TARGETS <libraries>...]]
       [POLICIES <CMPNNNN>...]
       [OPTIONS <option> <value>...]
       [INSTALL]
       [QUIET])

Create an interface library from a single header download
header(<url> [ALIAS <name>] [INSTALL] [QUIET])

]=]

function (__git_args)
  set(option PACKAGE)
  set(single ALIAS)
  set(multi)
  cmake_parse_arguments(ARG "${option}" "${single}" "${multi}" ${ARGN})
  parent_scope(ARG_PACKAGE ARG_ALIAS ARG_UNPARSED_ARGUMENTS)
endfunction()

macro (__git_package name tag)
  if (ARG_PACKAGE)
    info("Package - ${name}@${tag}")
    add_package(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
  endif()
endmacro()

macro (__git_name repository)
  set(name ${ARG_ALIAS})
  if (NOT ARG_ALIAS)
    get_filename_component(name ${repository} NAME)
  endif()
endmacro()

macro (__git website repository tag)
  __git_args(${ARGN})
  __git_name(${repository})
  git(${name} "${website}/${repository}" ${tag})
  __git_package(${name} ${tag})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endmacro()

function (git name path tag)
  fetch(${name}
    GIT_REPOSITORY ${path}.git
    GIT_TAG ${tag}
    GIT_SHALLOW ON
    ${ARGN})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction ()

function (gitssh host repository tag)
  __git_args(${ARGN})
  __git_name(${repository})
  git(${name} "git@${host}:${repository}" ${tag})
  __git_package(${name})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction()

function (github repository tag)
  __git("https://github.com" ${repository} ${tag} ${ARGN})
endfunction()

function (gitlab repository tag)
  __git("https://gitlab.com" ${repository} ${tag} ${ARGN})
endfunction ()

function (bitbucket repository tag)
  __git("https://bitbucket.com" ${repository} ${tag} ${ARGN})
endfunction ()
