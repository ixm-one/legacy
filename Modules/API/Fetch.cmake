include_guard(GLOBAL)

import(IXM::Fetch::*)
#[[
This does all the work of extracting the provider name, getting the command
itself, and then invoking said provider command with the requested arguments.
]]
function (fetch reference)
  void(VERBOSE CLONE)
  void(ALIAS DICT TARGET PATCH)
  void(COMPONENT TARGETS OPTIONS POLICIES)
  parse(${ARGN}
    @FLAGS VERBOSE CLONE
    @ARGS=? ALIAS DICT TARGET PATCH
    @ARGS=* COMPONENT TARGETS OPTIONS POLICIES)

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

  #### POST
  #[[ PATCH ]]
  ixm_fetch_common_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_common_policies("${POLICIES}")
  ixm_fetch_common_options("${OPTIONS}")
  ixm_fetch_common_exclude()

  ixm_fetch_common_verbose(previous-quiet)
  set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${EXCLUDE})
  aspect(SET print:quiet WITH ${previous-quiet})

  #[[ TARGET ]]
  ixm_fetch_common_target(${target} ${alias})
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
