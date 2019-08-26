include_guard(GLOBAL)

import(IXM::Fetch::*)
#[[
This does all the work of extracting the provider name, getting the command
itself, and then invoking said provider command with the requested arguments.
]]
function (fetch reference)
  parse(${ARGN}
    @ARGS=? ALIAS DICT
    @ARGS=* COMPONENT)

  #[[ Prepare some basic information for invoking commands ]]
  ixm_fetch_prepare_reference(${reference}) # creates 'provider' and 'package'
  ixm_fetch_prepare_command(${provider}) # creates 'command'
  ixm_fetch_prepare_name(${package}) # creates 'name'

  var(alias ALIAS ${name})
  var(dict DICT ixm::fetch::${alias})

  ixm_fetch_prepare_dict(${dict})

  ixm_fetch_common_status(${package})

  invoke(${command} ${package} arguments) # Sets arguments for the call to 'download'

  #ixm_fetch_common_noexclude()
  # Allows for non-download resources
  if (arguments)
    ixm_fetch_common_download(${alias} ${arguments})
  endif()

  var(target TARGET ${name})
  var(quiet QUIET OFF)

  #### POST
  #[[ PATCH ]]
  ixm_fetch_common_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_common_options("${OPTIONS}")
  ixm_fetch_common_exclude()

  get_property(previous-quiet GLOBAL PROPERTY ixm::print::quiet)
  set_property(GLOBAL PROPERTY ixm::print::quiet ${quiet})

  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${EXCLUDE})

  set_property(GLOBAL PROPERTY ixm::print::quiet ${previous-quiet})

  #[[ TARGET ]]
  ixm_fetch_common_target(${target} ${alias})
  set(${alias}_SOURCE_DIR ${${alias}_SOURCE_DIR} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${${alias}_BINARY_DIR} PARENT_SCOPE)

  #[[ COMPONENTS ]]
  foreach (component IN LISTS COMPONENTS)
    if (NOT TARGET ${PROJECT_NAME}::${component})
      warning("'${component}' does not exist for ${PROJECT_NAME}")
      continue()
    endif()
    target_link_libraries(${PROJECT_NAME}::${component}
      INTERFACE
        ${alias}::${alias})
  endforeach()
endfunction()
