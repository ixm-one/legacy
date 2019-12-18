include_guard(GLOBAL)

import(IXM::Fetch::*)
#[[
This does all the work of extracting the provider name, getting the command
itself, and then invoking said provider command with the requested arguments.
]]
function (fetch reference)
  void(ALIAS DICT COMPONENT VERBOSE OPTIONS POLICIES IMPORTS PATCH CLONE)
  parse(${ARGN}
    @FLAGS VERBOSE CLONE
    @ARGS=? ALIAS DICT PATCH
    @ARGS=* COMPONENT OPTIONS POLICIES IMPORTS)

  #[[ Prepare some basic information for invoking commands ]]
  ixm_fetch_prepare_reference(${reference}) # creates 'provider' and 'package'
  ixm_fetch_prepare_command(${provider}) # creates 'command'
  ixm_fetch_prepare_name(${package}) # creates 'name'

  assign(alias ? ALIAS : ${name})
  assign(dict ? DICT : ixm::fetch::${alias})

  ixm_fetch_prepare_dict(${dict})

  ixm_fetch_common_status(${package})

  invoke(${command} ${package} arguments) # Sets arguments for the call to 'download'

  # Allows for non-download resources
  if (arguments)
    ixm_fetch_common_download(${alias} ${arguments})
  endif()

  assign(target ? TARGET : ${name})
  assign(verbose ? VERBOSE : OFF)
  assign(imports ? IMPORTS)

  #### POST
  #[[ PATCH ]]
  ixm_fetch_common_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_common_policies("${POLICIES}")
  ixm_fetch_common_options("${OPTIONS}")
  ixm_fetch_common_exclude()

  ixm_fetch_common_verbose(previous-quiet)
  set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
  get_property(included GLOBAL PROPERTY ixm::fetch::${alias} SET)
  if (NOT included)
    add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${EXCLUDE})
  endif()
  set_property(GLOBAL PROPERTY ixm::fetch::${alias} ON)
  aspect(SET print:quiet WITH ${previous-quiet})

  if (imports)
    ixm_fetch_common_imports(${imports} ${alias})
  endif()

  set(${alias}_SOURCE_DIR ${${alias}_SOURCE_DIR} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${${alias}_BINARY_DIR} PARENT_SCOPE)

  #[[ COMPONENTS ]]
  foreach (component IN LISTS COMPONENT)
    if (TARGET ${PROJECT_NAME}::${component})
      target_link_libraries(${PROJECT_NAME}::${component}
        INTERFACE
          ${alias}::${alias})
    else()
      log(WARN "COMPONENT '${component}' does not exist for project ${PROJECT_NAME}")
    endif()
  endforeach()
endfunction()
