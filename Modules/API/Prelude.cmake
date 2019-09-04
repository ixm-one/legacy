include_guard(GLOBAL)

#[[
## Attributes are a powerful customization hook that allow us to do things like
have per-project command overrides, add new subcommands to existing APIs,
and do so in a non-intrusive way.

This differs from CMake's approach which is currently a combination of
undocumented cache variables, properties, and a "well it seems to work"
attitude.

There are two types of attributes
1) API
    These are just customization points for commands, settings, and other
    'hooks' so that a user can customize behavior within IXM without having
    to understand how its internals work.
2) Targets
   Unlike CMake, we don't have an issue with passing in ALIAS targets. This has
   the advantage of being more flexible, while also allowing blueprints to
   hide the actual names of targets generated under the hood.

Target Attributes are just target properties, but we can keep track of them and
make sure that "linking" them will be transitive in nature.

Additionally, attributes can understand the difference between a COMMAND
attribute and a value attribute. Command attributes put a small bit of logic
in so that they can be a pipeline of commands instead of just one that gets 
overridden.

Currently this logic isn't available, so we are still using ASSIGN, but once
it is in place, you'll be able to do NAME <name> COMMAND <command>.

Lastly, attributes customization points can be restored to their initial state
(to some degree).

## Events are special wrappers around `variable_watch` that allow us to handle
changes to the IXM environment. We can't easily hook into CMake's changes, but
IXM wraps enough CMake APIs that it makes enough of a difference. :)

## Target Properties/Attributes are SCREAMING_SNAKE_CASE to keep in line with
CMake's current style.

## API Attributes are in the style of URNs. Though we do not implement a parser,
and are not to spec (we create our own namespace that is unregistered), the
style of a URN is what we are really going for in these instances. Effectively,
the only style supported is <api>:<setting|command>[/<dependent-setting>].
Any number of paths may be attached after the initial command or setting name.
It is up to the implementor of a command on how many customization points should
be offered. It is also up to the user how deep they would want to store their
various settings and in what hierarchy.
]]

#[[
Rules for "customization hook" naming conventions

 Variables are set as UPPERCASE_VARIABLE_NAMES
 This applies for all environment, cache, and scoped variables
 If a variable is for a specific API call, it will be named IXM_<API>_<SETTING>
 Global properties are `namespaced::via::colons`. If global, they are set
 as ixm::<api>::<setting>. Emojis might be used to keep properties "safe" from
 common tampering.
 Target properties are set as UPPERCASE_VARIABLE_NAMES to stay in line with
 CMake itself.
 Blueprint specific properties are set as <blueprint>::<setting>
 Dictionaries are used for project specific settings. These are sometimes
 named like `ixm::<api>::<name>`, such as in the case of ixm::fetch::
 dictionaries. These should be transitioned to something else. e.g.,
 nothing says these can't be `${PROJECT_NAME}::fetch::<name>`, or similar.
]]

# TODO: We need a way to *restore* these values, or mark them as read only in
# some manner

list(APPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Languages")
list(APPEND CMAKE_MODULE_PATH "${IXM_ROOT}/Packages")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)

# First we set properties. These are intrinsic for us to run, but more
# importantly are just used to reduce hardcoding lists.

#setting(NAME RaspberryPi CATEGORY Toolchain VALUE ...)
#setting(GET CMAKE_TOOLCHAIN_FILE KEY ${CMAKE_SYSTEM_NAME} FROM Toolchain)
#setting(GET directory KEY Generate FROM Path)

#trait(SET "${IXM_ROOT}/Toolchains/RaspberryPi.cmake" TO RPi RaspberryPi)
#trait(GET CMAKE_TOOLCHAIN_FILE FROM ${CMAKE_SYSTEM_NAME})

set_property(GLOBAL PROPERTY ixm:toolchain:raspberrypi "${IXM_ROOT}/Toolchains/RaspberryPi.cmake")
set_property(GLOBAL PROPERTY ixm:toolchain:arduino "${IXM_ROOT}/Toolchains/Arduino.cmake")
set_property(GLOBAL PROPERTY ixm:toolchain:android "${IXM_ROOT}/Toolchains/Android.cmake")
set_property(GLOBAL PROPERTY ixm:toolchain:rpi "${IXM_ROOT}/Toolchains/RaspberryPi.cmake")
set_property(GLOBAL PROPERTY ixm:toolchain:qnx "${IXM_ROOT}/Toolchains/QNX.cmake")

# Attributes are defined for user customization. Not everything can be
# customized but we provide hooks for some specific calls so that things like
# fetching dependencies or printing output can be customized.
# Other than that, we really can't provide many customization points for
# performance reasons :<

#attribute(DEFINE blueprint:file HELP "Current Blueprint File")
#attribute(DEFINE blueprint:name HELP "Current Blueprint Name")
#
#attribute(DEFINE path:generate DEFAULT "${CMAKE_CURRENT_BINARY_DIR}/IXM/Generate")
#attribute(DEFINE path:target DEFAULT "${CMAKE_CURRENT_BINARY_DIR}/IXM/Target")
#attribute(DEFINE path:invoke DEFAULT "${CMAKE_CURRENT_BINARY_DIR}/IXM/Invoke")
#attribute(DEFINE path:fetch DEFAULT "${CMAKE_CURRENT_BINARY_DIR}/IXM/Fetch")
#attribute(DEFINE path:check DEFAULT "${CMAKE_CURRENT_BINARY_DIR}/IXM/Check")
#attribute(DEFINE path:find DEFAULT "${CMAKE_CURRENT_BINARY_DIR}/IXM/Find")
#attribute(DEFINE path:log DEFAULT "${CMAKE_CURRENT_BINARY_DIR}/IXM/Logs")

# TODO: These need to be properties. They are not customizable.
attribute(NAME blueprint:file)
attribute(NAME blueprint:name)

# Path Attributes
attribute(NAME path:generate ASSIGN "${CMAKE_CURRENT_BINARY_DIR}/IXM/Generate")
attribute(NAME path:target ASSIGN "${CMAKE_CURRENT_BINARY_DIR}/IXM/Target")
attribute(NAME path:invoke ASSIGN "${CMAKE_CURRENT_BINARY_DIR}/IXM/Invoke")
attribute(NAME path:fetch ASSIGN "${CMAKE_CURRENT_BINARY_DIR}/IXM/Fetch")
attribute(NAME path:check ASSIGN "${CMAKE_CURRENT_BINARY_DIR}/IXM/Check")
attribute(NAME path:find ASSIGN "${CMAKE_CURRENT_BINARY_DIR}/IXM/Find")
attribute(NAME path:log ASSIGN "${CMAKE_CURRENT_BINARY_DIR}/IXM/Logs")

# Command Attributes

# fetch() Attributes -- These will stay dynamic.
# However, they will not be attributes...
attribute(NAME fetch:hub ASSIGN ixm_fetch_hub)
attribute(NAME fetch:lab ASSIGN ixm_fetch_lab)
attribute(NAME fetch:bit ASSIGN ixm_fetch_bit)
attribute(NAME fetch:bin ASSIGN ixm_fetch_bin)
attribute(NAME fetch:url ASSIGN ixm_fetch_url)
attribute(NAME fetch:add ASSIGN ixm_fetch_add)
attribute(NAME fetch:use ASSIGN ixm_fetch_use)
attribute(NAME fetch:git ASSIGN ixm_fetch_git)
attribute(NAME fetch:svn ASSIGN ixm_fetch_svn)
attribute(NAME fetch:cvs ASSIGN ixm_fetch_cvs)
attribute(NAME fetch:hg ASSIGN ixm_fetch_hg)

# find() Attributes # TODO: Hard code these.
attribute(NAME find:framework ASSIGN ixm_find_framework)
attribute(NAME find:program ASSIGN ixm_find_program)
attribute(NAME find:library ASSIGN ixm_find_library)
attribute(NAME find:include ASSIGN ixm_find_include)

# generate() Attributes
attribute(NAME generate:unity ASSIGN ixm_generate_unity_build)
attribute(NAME generate:pch ASSIGN ixm_generate_precompiled_header)
attribute(NAME generate:rsp ASSIGN ixm_generate_response_file)

# inspect() Attributes
#attribute(NAME inspect:prefix)

# log() Attributes
attribute(NAME log:strftime ASSIGN "%Y-%b-%d@%H:%M:%S")
attribute(NAME log:rotate ASSIGN 5000000) # 5MB
attribute(NAME log:format ASSIGN TEXT)
attribute(NAME log:level ASSIGN INFO)
attribute(NAME log:color ASSIGN ON)

# parse() Attributes
attribute(NAME parse:max ASSIGN 9)

# print() Attributes
attribute(NAME print:install ASSIGN ALWAYS)
attribute(NAME print:colors ASSIGN ON)
attribute(NAME print:quiet ASSIGN OFF)

# target() Attributes
attribute(NAME target:interface ASSIGN ixm_target_interface)
attribute(NAME target:program ASSIGN ixm_target_program)
attribute(NAME target:library ASSIGN ixm_target_library)
attribute(NAME target:archive ASSIGN ixm_target_archive)
attribute(NAME target:sources ASSIGN ixm_target_sources)
attribute(NAME target:plugin ASSIGN ixm_target_plugin)
attribute(NAME target:test ASSIGN ixm_target_test)

attribute(NAME target:command ASSIGN ixm_target_command)
attribute(NAME target:import ASSIGN ixm_target_import)
attribute(NAME target:phony ASSIGN ixm_target_phony)
attribute(NAME target:unity ASSIGN ixm_target_unity)

attribute(NAME target:framework ASSIGN ixm_target_framework)
attribute(NAME target:service ASSIGN ixm_target_service)
attribute(NAME target:tool ASSIGN ixm_target_tool)
attribute(NAME target:app ASSIGN ixm_target_app)

attribute(NAME target:compile ASSIGN ixm_target_compile)
attribute(NAME target:link ASSIGN ixm_target_link)
attribute(NAME target:list ASSIGN ixm_target_list)

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

# parse() properties
set_property(GLOBAL PROPERTY ixm::parse::max 9)

# inspect() properties
set_property(GLOBAL PROPERTY ixm::inspect::prefix)

# Project related properties
set_property(GLOBAL PROPERTY ixm::extensions::source cxx;cpp;c++;cc;c;mm;m)
set_property(GLOBAL PROPERTY ixm::extensions::custom)

# IXM Import API settings
set_property(GLOBAL PROPERTY ixm::import::cmake PREFIX)