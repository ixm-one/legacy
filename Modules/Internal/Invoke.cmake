include_guard(GLOBAL)

#[[ Sets the variables the given function will expect]]
function(ixm_invoke_prepare)
endfunction()

#[[ Performs the actual 'include' of the output file ]]
function(ixm_invoke_execute)
endfunction()

#[[ Sets variables executed into the parent scope ]]
# XXX: Kinda hacky, but YOLO
function(ixm_invoke_debrief)
endfunction()

#[[ Performs the 'generation' of the file to be included ]]
function(ixm_invoke_compile)
endfunction()

#[[ Used to set the properties on a given function ]]
function(ixm_invoke_purview)
endfunction()

#[[
Options needed for this function to be SUPER USEFUL:
  Directory
  Namespace
  Basically, given a name X, we need to make sure we can ACTUALLY FIND X

  Anyhow, as for use, we do the following operations:
   * Calculate a fully qualified name for the function based on module info
   * Search to see if we've already DONE all the work for this dang function
     that we're looking for. If we did, then HOORAY! We can just *yoink* that
     sweet sweet boy into a variable and then we skip to the last step
   * Calculate an "origin" file. If it doesn't exist, we dump a FATAL to output
   * Generate a regexp that will extract the contents of the function. This
     regexp might seem fragile, but despite CMake's awful builtin regex, it
     handles a BUNCH of edge cases that would drive most others MAD.
   * We read in the origin file entirely.
   * We run the regexp on the contents
   * We not check to see if the function/command we were searching for is actually
     there. If not, WE ERROR!
   * If there is no body to the function, we do nothing.
   * We write the contents of the function's body to the output file
   * We turn the parameters of the function into a list based on
     WINDOWS argv generation. This is the closest to CMake's approach to
     quoted arguments.
   * We get the arity (argc) of the function. If it's 0, we don't care. Other
     wise we generate an ARGV<N> property name for [0, argc).
   * We generate a list of properties to set on the "commands" specific
     project target.
   * We add the function to the list of functions "defined" by the project.
   * We set the variables based on properties from the command and then
     call `include()` on the final generated path.
  
   NOTE: The variables set are the same as they would be passed into the
   command if it WERE NOT dynamically invoked.

]]
function(ixm_invoke name)
  set(qualname ${name}) # Temporary until "qualified" lookup exists
  get_property(output CACHE @${qualname} PROPERTY VALUE)
  if (output)
    ixm_invoke_prepare(${qualname})
    ixm_invoke_execute(${output})
    ixm_invoke_debrief(${qualname})
  endif()
  # TODO: Move this part to ixm_invoke_compile()
  # This needs to be a SAFE and GUARANTEED path
  set(output "${PROJECT_BINARY_DIR}/CMakeFiles/IXM/Invoke/${qualname}.cmake")
  set(regexp "[\r\n]?function[ \t]*\\(@(${name})([^)]*)\\)")
  set(regexp "${regexp}(.+)[\r\n]?endfunction\\([^)]\\)?(.*function)?")
  file(READ ${origin} content)
  string(REGEX MATCH "${regex}" results ${content})
  set(function "${CMAKE_MATCH_1}")
  if (NOT function)
    #error("Could not find '{0:reset}'" ${name})
    return()
  endif()
  if (NOT CMAKE_MATCH_3)
    # It's an empty function, we don't execute those, BUT we also don't error
    # Maybe give an optional warning?
    return()
  endif()
  # TODO: Move this part to ixm_invoke_expands
  file(WRITE ${output} ${CMAKE_MATCH_3})
  separate_arguments(parameters WINDOWS_COMMAND "${CMAKE_MATCH_2}")
  list(LENGTH parameters argc)
  set(arity 0)
  if (argc)
    math(EXPR arity "${argc} - 1" DECIMAL)
  endif()
  list(APPEND properties "${function}_ORIGIN" "${origin}")
  list(APPEND properties "${function}_OUTPUT" "${output}")
  list(APPEND properties "${function}_NAME" "${name}")
  list(APPEND properties "${function}_ARGC" "${argc}")
  foreach (N RANGE ${arity})
    list(GET parameters 0 argv)
    list(APPEND properties "${function}_ARGV${N}" "${argv}")
  endforeach()
  list(TRANSFORM properties PREPEND INTERFACE_)
  set_property(ixm::${PROJECT_NAME}::functions PROPERTIES ${properties})
  set_property(ixm::${PROJECT_NAME}::properties APPEND PROPERTY
    INTERFACE_functions "${function}")
  ixm_internal(@${qualname} ${output} "Path to the cached 'dynamic' function ${name}")
  ixm_invoke_prepare(${qualname})
  ixm_invoke_execute(${output})
  ixm_invoke_debrief(${qualname})
endfunction()
