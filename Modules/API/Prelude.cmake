include_guard(GLOBAL)

list(APPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Languages")
list(APPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Packages")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)

# First we set properties. These are intrinsic for us to run, but more
# importantly are just used to reduce hardcoding lists.

aspect(SET toolchain:raspberrypi WITH "${IXM_ROOT}/Toolchains/RaspberryPi.cmake")
aspect(SET toolchain:arduino WITH "${IXM_ROOT}/Toolchains/Arduino.cmake")
aspect(SET toolchain:android WITH "${IXM_ROOT}/Toolchains/Android.cmake")
aspect(SET toolchain:rpi WITH "${IXM_ROOT}/Toolchains/RaspberryPi.cmake")
aspect(SET toolchain:qnx WITH "${IXM_ROOT}/Toolchains/QNX.cmake")

aspect(SET path:generate WITH "${CMAKE_CURRENT_BINARY_DIR}/Generate")
aspect(SET path:target WITH "${CMAKE_CURRENT_BINARY_DIR}/Target")
aspect(SET path:invoke WITH "${CMAKE_CURRENT_BINARY_DIR}/Invoke")
aspect(SET path:fetch WITH "${CMAKE_CURRENT_BINARY_DIR}/Fetch")
aspect(SET path:check WITH "${CMAKE_CURRENT_BINARY_DIR}/Check")
aspect(SET path:find WITH "${CMAKE_CURRENT_BINARY_DIR}/Find")
aspect(SET path:log WITH "${CMAKE_CURRENT_BINARY_DIR}/Logs")

# Command Aspects (Used for dynamic subcommand lookup)

# fetch() aspects -- These will change once the provider refactor is complete
aspect(SET fetch:hub WITH ixm_fetch_hub)
aspect(SET fetch:lab WITH ixm_fetch_lab)
aspect(SET fetch:bit WITH ixm_fetch_bit)
aspect(SET fetch:bin WITH ixm_fetch_bin)
aspect(SET fetch:url WITH ixm_fetch_url)
aspect(SET fetch:add WITH ixm_fetch_add)
aspect(SET fetch:use WITH ixm_fetch_use)
aspect(SET fetch:git WITH ixm_fetch_git)
aspect(SET fetch:svn WITH ixm_fetch_svn)
aspect(SET fetch:cvs WITH ixm_fetch_cvs)
aspect(SET fetch:hg WITH ixm_fetch_hg)

# generate() aspects
aspect(SET generate:pch WITH ixm_generate_precompiled_header)
aspect(SET generate:rsp WITH ixm_generate_response_file)

aspect(SET generate:unity WITH ixm_generate_unity_build)
aspect(SET generate:bison WITH ixm_generate_bison)
aspect(SET generate:flex WITH ixm_generate_flex)
aspect(SET generate:yacc WITH ixm_generate_bison)
aspect(SET generate:lex WITH ixm_generate_flex)

# log() aspects
aspect(SET log:strftime WITH "%Y-%b-%d@%H:%M:%S")
aspect(SET log:format WITH TEXT FILE)
aspect(SET log:level WITH INFO)
aspect(SET log:color WITH ON)

aspect(SET print:colors WITH ON)
aspect(SET print:quiet WITH OFF)

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

# Event Command Properties
set_property(GLOBAL PROPERTY ixm::event::remove ixm_event_remove)
set_property(GLOBAL PROPERTY ixm::event::emit ixm_event_emit)
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
set_property(GLOBAL PROPERTY ixm::target::interface ixm_target_interface)
set_property(GLOBAL PROPERTY ixm::target::program ixm_target_program)
set_property(GLOBAL PROPERTY ixm::target::library ixm_target_library)
set_property(GLOBAL PROPERTY ixm::target::archive ixm_target_archive)
set_property(GLOBAL PROPERTY ixm::target::plugin ixm_target_plugin)
set_property(GLOBAL PROPERTY ixm::target::test ixm_target_test)

set_property(GLOBAL PROPERTY ixm::target::command ixm_target_command)
set_property(GLOBAL PROPERTY ixm::target::import ixm_target_import)
set_property(GLOBAL PROPERTY ixm::target::phony ixm_target_phony)
set_property(GLOBAL PROPERTY ixm::target::unity ixm_target_unity)

set_property(GLOBAL PROPERTY ixm::target::framework ixm_target_framework)
set_property(GLOBAL PROPERTY ixm::target::service ixm_target_service)
set_property(GLOBAL PROPERTY ixm::target::tool ixm_target_tool)
set_property(GLOBAL PROPERTY ixm::target::app ixm_target_app)

set_property(GLOBAL PROPERTY ixm::target::compile ixm_target_compile)
set_property(GLOBAL PROPERTY ixm::target::link ixm_target_link)
set_property(GLOBAL PROPERTY ixm::target::list ixm_target_list)

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

# Project related properties
set_property(GLOBAL PROPERTY ixm::extensions::source cxx;cpp;c++;cc;c;mm;m)
set_property(GLOBAL PROPERTY ixm::extensions::custom)

# IXM Import API settings
set_property(GLOBAL PROPERTY ixm::import::cmake PREFIX)