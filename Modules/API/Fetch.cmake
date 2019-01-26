include_guard(GLOBAL)

import(IXM::Fetch::*)
#[[
NOTES:
We need to overhaul the syntax we use for getting dependencies via
FetchContent. Basically, we want to do something like ExternalData's
DATA{} variables.
Current variable types are (in order of supported priority):
HUB{$USER/$REPO@$REV} -> HUB.ALIASA.IO download
LAB{$USER/$REPO@$REV} -> LAB.ALIASA.IO download
BIT{$USER/$REPO@$REV} -> BIT.ALIASA.IO download
WEB{Path/To/Web/Server@revision} -> Git Clone
SSH{user@domain:~/path@rev-parse} -> Git Clone
URL{Path/To/File} -> Direct Download
ADD{Path/In/Local/Project} -> add_subdirectory
USE{Path/To/Script.cmake} -> Executes script 
BIN{subject/repo@version:file} -> BinTray

S3B{S3 storage compatible info...} -> S3 Bucket access
SVN{BecauseYouHateYourSelf} -> SVN
CVS{WhoHurtYou?} -> CVS
CMD{Command} -> We'll look up how to do this later, but it's important to
                support for extension purposes.

Aliasa download also support a special `:` addition, as this lets them
specify directories to add_subdirectory from *or* specific files to pull
from the releases API for each platform.
Directories MUST end with a `/` for it to be considered a directory.
Unlike DATA{}, we ONLY support uppercase for these operations. This makes the
regex on CMake's engine less of a pain to write/support

This also lets us replace our various functions with a simple call to
a SINGLE function named Fetch (since we replicate the behavior everywhere
anyhow...)

Following ExternalData's templates approach, we can kind of do something like

set(Fetch_RESOURCE_TEMPLATES
  "hub://hub.aliasa.io/%(user)/%(repository)@%(tag)"
  "hub://hub.aliasa.io/%(user)/%(repository)"
  "bit://etc. etc."
  "ssh://%(user)@%(domain):%[path/]?%(repository)@%(tag)"
)

The regex for getting both the "scheme" data out, as well as its contents looks
like:

To capture ALL matches passed to Fetch, we do (something) like the following
set(regexp "[ \t\r\n]*(<SCHEMES-JOINED-BY-A-PIPE>)[ \t]*{([^}]*)}")
string(REGEX MATCH "${regexp}" output "${input}")
string(LENGTH "${output}" length)
while(length)
  string(SUBSTRING "${input}" ${length} -1 input)
  string(REGEX MATCH "${regexp}" output "${input}")
  string(LENGTH "${output}" length)
endwhile()

For some reason, this do-while loop is more accurate than a traditional one.
No idea why! :v

The more interesting part here is how we can specify additional arguments for
Fetch *FROM WITHIN EACH PROVIDER*. Just do what ExternalData does:
Separate by commas, turn each (.*): into a value! Easy!

Full example of "hiredis" from days of "yore"
Fetch(HUB{redis/hiredis@v0.14.0,PATCH:path/to/patchfile.cmake})

#[[ This approach SHOULD eventually allow for

Fetch(HUB{
  catchorg/catch2@v2.5.0,
  PATCH:my/cmake/path,
  SETTINGS:
    Uri_BUILD_TESTING OFF
    Uri_BUILD_EXAMPLES OFF
})

]]

#[[
This does all the work of extracting the provider name, getting the command
iself, and then invoking said provider command with the requested arguments.
]]
function (Fetch)
  ixm_fetch_prepare_parameters("${ARGN}")
  ixm_fetch_prepare_command(command ${command})
  ixm_fetch_prepare_options(options "${options}")
  invoke(${command} ${package} ${options})
endfunction()
