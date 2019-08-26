include_guard(GLOBAL)

#[[
This file contains everything that MUST be set before we do anything else
]]

list(APPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Languages")
list(APPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Packages")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)

# IXM API Directory Locations
set_property(GLOBAL PROPERTY ixm::directory::generate "${CMAKE_CURRENT_BINARY_DIR}/IXM/Generate")
set_property(GLOBAL PROPERTY ixm::directory::target "${CMAKE_CURRENT_BINARY_DIR}/IXM/Target")
set_property(GLOBAL PROPERTY ixm::directory::output "${CMAKE_CURRENT_BINARY_DIR}/IXM/Output")
set_property(GLOBAL PROPERTY ixm::directory::invoke "${CMAKE_CURRENT_BINARY_DIR}/IXM/Invoke")
set_property(GLOBAL PROPERTY ixm::directory::fetch "${CMAKE_CURRENT_BINARY_DIR}/IXM/Fetch")
set_property(GLOBAL PROPERTY ixm::directory::check "${CMAKE_CURRENT_BINARY_DIR}/IXM/Check")
set_property(GLOBAL PROPERTY ixm::directory::find "${CMAKE_CURRENT_BINARY_DIR}/IXM/Find")
set_property(GLOBAL PROPERTY ixm::directory::log "${CMAKE_CURRENT_BINARY_DIR}/IXM/Logs")

# Toolchain related properties
set_property(GLOBAL PROPERTY ixm::toolchain::raspberrypi "${IXM_ROOT}/Toolchains/RaspberryPi.cmake")
set_property(GLOBAL PROPERTY ixm::toolchain::android "${IXM_ROOT}/Toolchains/Android.cmake")
set_property(GLOBAL PROPERTY ixm::toolchain::arduino "${IXM_ROOT}/Toolchains/Arduino.cmake")
set_property(GLOBAL PROPERTY ixm::toolchain::rpi "${IXM_ROOT}/Toolchains/RaspberryPi.cmake")
set_property(GLOBAL PROPERTY ixm::toolchain::qnx "${IXM_ROOT}/Toolchains/QNX.cmake")

# TODO: Need to consider possibly having each of ixm::command::<name>
# stored subcommands then be named `ixm::command::<name>::<subcommand>`
# This would allow for more customization hooks on a per-command basis.
# Just something to keep in mind...
# Command Properties (Used for subcommand redirection)
set_property(GLOBAL PROPERTY ixm::command::check
  struct class enum union integral pointer include sizeof alignof)

set_property(GLOBAL PROPERTY ixm::command::dict
  load save json transform insert set remove clear merge keys get)

set_property(GLOBAL PROPERTY ixm::command::event send remove rm add)

set_property(GLOBAL PROPERTY ixm::command::fetch
  git svn cvs hg hub lab bit bin url use add)

set_property(GLOBAL PROPERTY ixm::command::find
  framework program library include)

set_property(GLOBAL PROPERTY ixm::command::generate
  unity header pch rsp)

set_property(GLOBAL PROPERTY ixm::command::log
  notice fatal panic trace debug info warn error)

set_property(GLOBAL PROPERTY ixm::command::target
  executable framework archive shared object plugin test)

# Check Command Properties
set_property(GLOBAL PROPERTY ixm::check::integral ixm_check_integral)
set_property(GLOBAL PROPERTY ixm::check::include ixm_check_include)
set_property(GLOBAL PROPERTY ixm::check::pointer ixm_check_pointer)
set_property(GLOBAL PROPERTY ixm::check::struct ixm_check_class)
set_property(GLOBAL PROPERTY ixm::check::class ixm_check_class)
set_property(GLOBAL PROPERTY ixm::check::union ixm_check_union)
set_property(GLOBAL PROPERTY ixm::check::enum ixm_check_enum)

set_property(GLOBAL PROPERTY ixm::check::alignof ixm_check_alignof)
set_property(GLOBAL PROPERTY ixm::check::sizeof ixm_check_sizeof)

# Dict Command Properties
set_property(GLOBAL PROPERTY ixm::dict::transform ixm_dict_transform)
set_property(GLOBAL PROPERTY ixm::dict::insert ixm_dict_insert)
set_property(GLOBAL PROPERTY ixm::dict::remove ixm_dict_remove)
set_property(GLOBAL PROPERTY ixm::dict::clear ixm_dict_clear)
set_property(GLOBAL PROPERTY ixm::dict::merge ixm_dict_merge)
set_property(GLOBAL PROPERTY ixm::dict::load ixm_dict_load)
set_property(GLOBAL PROPERTY ixm::dict::save ixm_dict_save)
set_property(GLOBAL PROPERTY ixm::dict::json ixm_dict_json)
set_property(GLOBAL PROPERTY ixm::dict::keys ixm_dict_keys)
set_property(GLOBAL PROPERTY ixm::dict::set ixm_dict_set)
set_property(GLOBAL PROPERTY ixm::dict::get ixm_dict_get)

# Event Command Properties
set_property(GLOBAL PROPERTY ixm::event::remove ixm_event_remove)
set_property(GLOBAL PROPERTY ixm::event::rm ixm_event_remove)
set_property(GLOBAL PROPERTY ixm::event::send ixm_event_send)
set_property(GLOBAL PROPERTY ixm::event::add ixm_event_add)

# Fetch Command Properties
set_property(GLOBAL PROPERTY ixm::fetch::hub ixm_fetch_hub)
set_property(GLOBAL PROPERTY ixm::fetch::lab ixm_fetch_lab)
set_property(GLOBAL PROPERTY ixm::fetch::bit ixm_fetch_bit)
set_property(GLOBAL PROPERTY ixm::fetch::bin ixm_fetch_bin)
set_property(GLOBAL PROPERTY ixm::fetch::url ixm_fetch_url)
set_property(GLOBAL PROPERTY ixm::fetch::add ixm_fetch_add)
set_property(GLOBAL PROPERTY ixm::fetch::use ixm_fetch_use)
set_property(GLOBAL PROPERTY ixm::fetch::git ixm_fetch_git)
set_property(GLOBAL PROPERTY ixm::fetch::svn ixm_fetch_svn)
set_property(GLOBAL PROPERTY ixm::fetch::cvs ixm_fetch_cvs)
set_property(GLOBAL PROPERTY ixm::fetch::hg ixm_fetch_hg)

# Find Command Properties
set_property(GLOBAL PROPERTY ixm::find::framework ixm_find_framework)
set_property(GLOBAL PROPERTY ixm::find::program ixm_find_program)
set_property(GLOBAL PROPERTY ixm::find::library ixm_find_library)
set_property(GLOBAL PROPERTY ixm::find::include ixm_find_include)

# Generate Command Properties
set_property(GLOBAL PROPERTY ixm::generate::pch ixm_generate_precompiled_header)
set_property(GLOBAL PROPERTY ixm::generate::rsp ixm_generate_response_file)

# Target Command Properties
set_property(GLOBAL PROPERTY ixm::target::executable ixm_target_executable)
set_property(GLOBAL PROPERTY ixm::target::framework ixm_target_framework)
set_property(GLOBAL PROPERTY ixm::target::archive ixm_target_archive)
set_property(GLOBAL PROPERTY ixm::target::shared ixm_target_shared)
set_property(GLOBAL PROPERTY ixm::target::object ixm_target_object)
set_property(GLOBAL PROPERTY ixm::target::plugin ixm_target_plugin)
set_property(GLOBAL PROPERTY ixm::target::test ixm_target_test)

# Blueprint Properties
set_property(GLOBAL PROPERTY ixm::current::blueprint::file)
set_property(GLOBAL PROPERTY ixm::current::blueprint::name)

# Log Properties
set_property(GLOBAL PROPERTY ixm::log::strftime "%Y-%b-%d@%H:%M:%S")
set_property(GLOBAL PROPERTY ixm::log::format TEXT)
set_property(GLOBAL PROPERTY ixm::log::level INFO)
set_property(GLOBAL PROPERTY ixm::log::color ON)
set_property(GLOBAL PROPERTY ixm::log::rotate 5000000) # 5MB

# message()/print override properties
set_property(GLOBAL PROPERTY ixm::print::quiet OFF)
set_property(GLOBAL PROPERTY ixm::print::colors ON)
set_property(GLOBAL PROPERTY ixm::print::install ALWAYS)
# This is used to set CMAKE_INSTALL_MESSAGE

# parse() properties
set_property(GLOBAL PROPERTY ixm::parse::max 9)

# inspect() properties
set_property(GLOBAL PROPERTY ixm::inspect::prefix)

# Project related properties
set_property(GLOBAL PROPERTY ixm::extensions::source cxx;cpp;c++;cc;c;mm;m)
set_property(GLOBAL PROPERTY ixm::extensions::custom)
