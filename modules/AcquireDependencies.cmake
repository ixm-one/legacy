include_guard(GLOBAL)

include(PushState)
include(IXM)

push_module_path(AcquireDependencies)
include(Arguments)
include(Archive)
include(Extern)
include(Header)
include(Git)
pop_module_path()

# Settings specific to this module
# These can be overridden as cache variables
set(IXM_HEADER_DIR header)

#[[ Acquire a package from github. This is a macro around githttps ]]
macro (github pkg)
  githttps(${pkg} DOMAIN github.com ${ARGN})
endmacro()

#[[ Acquire a package from gitlab. This is a macro around githttps ]]
macro (gitlab pkg)
  githttps(${pkg} DOMAIN gitlab.com ${ARGN})
endmacro()

#[[ Acquire a package from bitbucket. This is a macro around githttps ]]
macro (bitbucket pkg)
  githttps(${pkg} DOMAIN bitbucket.com ${ARGN})
endmacro ()

#[[ Acquire a package from an https location. This is a macro around gitacquire ]]
macro (githttps pkg)
  gitacquire(${pkg} ${ARGN} SCHEME "https://")
endmacro()

#[[ Acquire a package from an ssh location. This is a macro around gitacquire ]]
macro (gitssh pkg)
  gitacquire(${pkg} ${ARGN} SCHEME "ssh://" SEPARATOR ":")
endmacro()
