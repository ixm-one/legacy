include_guard(GLOBAL)

define_property(TARGET PROPERTY APPIMAGE_NAME
  BRIEF_DOCS "Name of the application"
  FULL_DOCS "Specific name of the application, for example 'Mozilla'")

define_property(TARGET PROPERTY APPIMAGE_GENERIC_NAME
  BRIEF_DOCS "Generic name of the application"
  FULL_DOCS "Generic name of the application, for example 'Web Browser'")

define_property(TARGET PROPERTY APPIMAGE_NO_DISPLAY
  BRIEF_DOCS "Don't display the application in menus"
  FULL_DOCS
[=[
`NoDisplay` means "this application exists, but don't display it in the menus".
This can be useful to e.g., associate this application with MIME types, so that
it gets launched from a file manager (or other apps), without having a menu
entry for it (there are tons of good reasons for this, including e.g., the
`netscape -remote` or kfmclient openURL kind of stuff).
]=])

define_property(TARGET PROPERTY APPIMAGE_COMMENT
  BRIEF_DOCS "Tooltip for the entry"
  FULL_DOCS
[=[
Tooltip for the entry, for example "View sites on the Internet". The value
should not be redundant with the values of `APPIMAGE_NAME` and
`APPIMAGE_GENERIC_NAME`
]=])

define_property(TARGET PROPERTY APPIMAGE_ICO
  BRIEF_DOCS "Icon to display in menus, etc."
  FULL_DOCS
[=[
Icon to display in the file manager, menus, etc. If the name is an absolute
path, the given file will be used. If the name is not an absolute path, the
algorithm described in the FreeDesktop Icon Theme Specification will be used to
locate the icon
]=])

define_property(TARGET PROPERTY APPIMAGE_HIDDEN
  BRIEF_DOCS "User 'deleted' the application'"
  FULL_DOCS
[=[
`Hidden` should have been called `Deleted`. It means the user deleted (at his
level) something that was present (at an upper level, e.g. in the system dirs).
It's strictly equivalent to the .desktop file not existing at all, as far as
that user is concerned. This can also be used to "uninstall" existing files
(e.g. due to a renaming) - by letting `make install` install a file with
`Hidden=true` in it.
]=])

define_property(TARGET PROPERTY APPIMAGE_ONLY_SHOW_IN
  BRIEF_DOCS "Desktop environments that should display this AppImage"
  FULL_DOCS
[=[
Mutually exclusive with `APPIMAGE_NOT_SHOW_IN`

A list of strings identifying the desktop environments that should display/not
display a given desktop entry.

By default, a desktop file should be shown, unless an `OnlyShowIn` key is
present, in which case, the default is for the file not to be shown.

If `$XDG_CURRENT_DESKTOP` is set then it contains a colon-separated list of
strings. In order, each string is considered. If a matching entry is found in
`OnlyShowIn` then the desktop file is shown. If none of the strings match then
the default action is taken (as above).

$XDG_CURRENT_DESKTOP should have been set by the login manager, according to
the value of the DesktopNames found in the session file. The entry in the
session file has multiple values separated in the usual way: with a semicolon.

The same desktop name may not appear in both `OnlyShowIn` and `NotShowIn` of a
group.
]=])

define_property(TARGET PROPERTY APPIMAGE_NOT_SHOW_IN
  BRIEF_DOCS "Desktop environments that should display this AppImage"
  FULL_DOCS
[=[
Mutually exclusive with `APPIMAGE_ONLY_SHOW_IN`

A list of strings identifying the desktop environments that should display/not
display a given desktop entry.

By default, a desktop file should be shown, unless a `NotShowIn` key is
present, in which case, the default is for the file not to be shown.

If `$XDG_CURRENT_DESKTOP` is set then it contains a colon-separated list of
strings. In order, each string is considered.  If an entry is found in
NotShowIn then the desktop file is not shown. If none of the strings match then
the default action is taken (as above).

$XDG_CURRENT_DESKTOP should have been set by the login manager, according to
the value of the DesktopNames found in the session file. The entry in the
session file has multiple values separated in the usual way: with a semicolon.

The same desktop name may not appear in both `OnlyShowIn` and `NotShowIn` of a
group.
]=])

define_property(TARGET PROPERTY APPIMAGE_DBUS_ACTIVATABLE
  BRIEF_DOCS "Whether D-Bus Activation is supported"
  FULL_DOCS
[=[
A boolean value specifying if D-Bus activation is supported for this
application. If this key is missing, the default value is `false`. If the value
is true then implementations should ignore the `Exec` key and send a D-Bus
message to launch the application. See D-Bus Activation for more information on
how this works. Applications should still include `Exec=` lines in their
desktop files for compatibility with implementations that do not understand the
DBusActivatable key.
]=])

define_property(TARGET PROPERTY APPIMAGE_TRY_EXEC
  BRIEF_DOCS "Path to program to see if app is installable"
  FULL_DOCS
[=[
Path to an executable file on disk used to determine if the program is actually
installed. If the path is not an absolute path, the file is looked up in the
`$PATH` environment variable. If the file is not present or if it is not
executable, the entry may be ignored (not be used in menus, for example).
]=])

define_property(TARGET PROPERTY APPIMAGE_EXEC
  BRIEF_DOCS "Program to execute, possibly with arguments"
  FULL_DOCS
[=[
Program to execute, possibly with arguments. See the FreeDesktop documentation
on the `Exec` key for details on how this key works. The `Exec` key is required
if `DBusActivatable` is not set to `true`. Even if `DBusActivatable` is `true`,
`Exec` should be specified for compatibility with implementations that do not
understand `DBusActivatable`.
]=])

define_property(TARGET PROPERTY APPIMAGE_PATH
  BRIEF_DOCS "Working directory to run the program in"
  FULL_DOCS "Working directory to run the program in")

define_property(TARGET PROPERTY APPIMAGE_TERMINAL
  BRIEF_DOCS "Whether the program runs in a terminal window"
  FULL_DOCS "Whether the program runs in a terminal window")

define_property(TARGET PROPERTY APPIMAGE_ACTIONS
  BRIEF_DOCS "List of identifiers for application actions."
  FULL_DOCS
[=[
Identifiers for application actions. This can be used to tell the application
to make a specific action, different from the default behavior. The FreeDesktop
Desktop Entry Spec Application actions section describes how actions work.

Each entry is used to search for Action specific keys
]=])

define_property(TARGET PROPERTY APPIMAGE_MIME_TYPE
  BRIEF_DOCS "The MIME type(s) supported by this application"
  FULL_DOCS "The MIME type(s) supported by this application")

define_property(TARGET PROPERTY APPIMAGE_CATEGORIES
  BRIEF_DOCS "Categories in which the entry should be shown in a menu"
  FULL_DOCS
[=[
Categories in which the entry should be shown in a menu. Non-standard entries
must begin with an `X-`. The standard categories are
 * AudioVideo
 * Audio (Requires AudioVideo as well)
 * Video (Requires AudioVideo as well)
 * Development
 * Education
 * Game
 * Graphics
 * Network
 * Office
 * Science
 * Settings
 * System
 * Utility
]=])

define_property(TARGET PROPERTY APPIMAGE_IMPLEMENTS
  BRIEF_DOCS "A list of interfaces that this application implements"
  FULL_DOCS
[=[
A list of interfaces that this application implements. By default, a desktop
file implements no interfaces. See Interfaces for more information on how this
works.
]=])

define_property(TARGET PROPERTY APPIMAGE_KEYWORDS
  BRIEF_DOCS "A list which may be used in addition to other metadata"
  FULL_DOCS
[=[
A list of strings which may be used in addition to other metadata to describe
this entry. This can be useful e.g. to facilitate searching through entries.
The values are not meant for display, and should not be redundant with the
values of Name or GenericName.
]=])

define_property(TARGET PROPERTY APPIMAGE_STARTUP_NOTIFY
  BRIEF_DOCS "Boolean whether this application works at startup"
  FULL_DOCS
[=[
If true, it is KNOWN that the application will send a "remove" message when
started with the `DESKTOP_STARTUP_ID` environment variable set. If false, it is
KNOWN that the application does not work with startup notification at all (does
not shown any window, breaks even when using StartupWMClass, etc.). If absent,
a reasonable handling is up to implementations (assuming false, using
StartupWMClass, etc.).
]=])

define_property(TARGET PROPERTY APPIMAGE_STARTUP_WM_CLASS
  BRIEF_DOCS "Value the app will map at least one window as the WM class"
  FULL_DOCS
[=[
If specified, it is known that the application will map at least one window
with the given string as its WM class or WM name hint (see the Startup
Notification Protocol Specification for more details).
]=])

define_property(TARGET PROPERTY APPIMAGE_LOCALES
  BRIEF_DOCS "List of locales used to search for locale specific properties"
  FULL_DOCS "List of locales used to search for locale specific properties")

define_property(TARGET PROPERTY APPIMAGE_DESKTOP_FILE
  BRIEF_DOCS "Simply use the given .desktop file"
  FULL_DOCS
[=[
Instructs IXM aware CMake tooling to simply use the .desktop file given.
If other properties are set, a warning should be emitted
]=])

define_property(TARGET PROPERTY APPIMAGE_APPEND_FILE
  BRIEF_DOCS "A file to append to the generated .desktop file"
  FULL_DOCS
[=[
Instructs IXM aware CMake tooling to append the given file to the generated
.desktop file.
]=])

# These are here for writing documentation later
# APPIMAGE_<LOCALE>_GENERIC_NAME
# APPIMAGE_<LOCALE>_KEYWORDS
# APPIMAGE_<LOCALE>_COMMENT
# APPIMAGE_<LOCALE>_NAME
# APPIMAGE_<LOCALE>_ICON
# APPIMAGE_<ACTION>_LOCALES -- XXX: Like primary locales, but for singular
# APPIMAGE_<ACTION>_<LOCALE>_NAME
# APPIMAGE_<ACTION>_<LOCALE>_ICON
# APPIMAGE_<ACTION>_NAME
# APPIMAGE_<ACTION>_ICON
# APPIMAGE_<ACTION>_EXEC -- XXX: Required if DBUS_ACTIVATABLE is not set

