include_guard(GLOBAL)

import(IXM::Check::*)

#[[
TODO: To remove the dependency on `invoke`, we need to explicitly list out
the supported checks. Currently we plan to support:

 * ENUM -- std::is_enum<T>::value
 * CLASS/STRUCT -- std::is_class<T>::value
 * UNION -- std::is_union<T>::value
 * TRAIT -- std::@trait@<T>::value
 * CONCEPT -- if a concept is true (also works with TRAIT, tbqh)
 * ALIGNOF -- alignof T == N
 * SIZEOF -- sizeof T == N
 * CODE -- compiles (this is the command used for any static_assert based
   commands)
 * OPTION -- compiler option
 * INCLUDE -- header exists (this could also be turned into a static_assert
   with __has_include on newer compilers)
 * LINT -- -W|/W warnings and their equivalent flags to be added.
 

#[[
Meant for checking the current state of the compiler and code
There are several types of checks
1) Exists (does an include file exist, symbol, compiler flag, linker flag, etc)
2) Is a given entity a specific "type", i.e., what trait does it meet? (std::is_*)
3) If the given entity *exists*, is an attribute of said entity true? (sizeof, alignof)
4) Does my code compile?
5) Does my code run? (not available when cross-compiling)
]]
function (check subcommand)
  set(class CLASS STRUCT)
  if (subcommand STREQUAL "POINTER")
    ixm_check_pointer(${ARGN})
  elseif (subcommand STREQUAL "INTEGRAL")
    ixm_check_integral(${ARGN})
  elseif (subcommand STREQUAL "UNION")
    ixm_check_union(${ARGN})
  elseif (subcommand IN_LIST class)
    ixm_check_class(${ARGN})
  elseif (subcommand STREQUAL "ENUM")
    ixm_check_enum(${ARGN})
  elseif (subcommand STREQUAL "TRAIT")
    ixm_check_trait(${ARGN})
  elseif (subcommand STREQUAL "ALIGNOF")
    ixm_check_alignof(${ARGN})
  elseif (subcommand STREQUAL "SIZEOF")
    ixm_check_sizeof(${ARGN})
  elseif (subcommand STREQUAL "LINT")
    ixm_check_lint(${ARGN})
  elseif (subcommand STREQUAL "CODE")
    ixm_check_code(${ARGN})
  elseif (subcommand STREQUAL "INCLUDE")
    ixm_check_include(${ARGN})
  else()
    log(FATAL "check(${subcommand}) is an invalid operation")
  endif()
endfunction()
