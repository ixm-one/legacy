include_guard(GLOBAL)

option(IXM_ENABLE_MACRO "Enable IXM Macros" ON)

ixm_enable(MACRO UPVAR "Enable IXM upvar() wrapper macro")
ixm_enable(MACRO IMPORT "Enable IXM import() wrapper macro")

ixm_enable(MACRO UPVAR "Enable IXM upvar() wrapper macro")
ixm_enable(MACRO IMPORT "Enable IXM import() wrapper macro")
ixm_enable(MACRO MODULE "Enable IXM module() wrapper macro")
ixm_enable(MACRO INVOKE "Enable IXM invoke() wrapper macro")
ixm_enable(MACRO PARSE "Enable IXM parse() wrapper macro")
ixm_enable(MACRO INTERNAL "Enable IXM internal() wrapper macro")
ixm_enable(MACRO CACHE "Enable IXM cache() wrapper macro")
ixm_enable(MACRO BOOLEAN "Enable IXM boolean() wrapper macro")
ixm_enable(MACRO VAR "Enable IXM var() wrapper macro")

if (NOT IXM_ENABLE_MACRO)
  return()
endif()

# Upvar.cmake
if (IXM_ENABLE_MACRO_UPVAR)
  macro(upvar)
    ixm_upvar(${ARGN})
  endmacro()
endif()

#Import.cmake
if (IXM_ENABLE_MACRO_IMPORT)
  macro(module)
    ixm_module(${ARGN})
  endmacro()
endif()

#Import.cmake
if (IXM_ENABLE_MACRO_MODULE)
  macro(module)
    ixm_module(${ARGN})
  endmacro()
endif()

# Invoke.cmake
if (IXM_ENABLE_MACRO_INVOKE)
  macro(invoke)
    ixm_invoke(${ARGN})
  endmacro()
endif()

# Parse.cmake
if (IXM_ENABLE_MACRO_PARSE)
  macro(parse)
    ixm_parse(${ARGN})
  endmacro()
endif()

# Cache.cmake
if (IXM_ENABLE_MACRO_INTERNAL)
  macro(internal)
    ixm_internal(${ARGN})
  endmacro()
endif()

# Cache.cmake
if (IXM_ENABLE_MACRO_CACHE)
  macro(cache)
    ixm_cache(${ARGN})
  endmacro()
endif()

# Cache.cmake
if (IXM_ENABLE_MACRO_BOOLEAN)
  macro(boolean)
    ixm_boolean(${ARGN})
  endmacro()
endif()

# Var.cmake
if (IXM_ENABLE_MACRO_VAR)
  macro(var)
    ixm_var(${ARGN})
  endmacro()
endif()
