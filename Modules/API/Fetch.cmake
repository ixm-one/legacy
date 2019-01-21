include_guard(GLOBAL)

# TODO: Add IXM_FETCH_API_PROVIDERS as a cache variable, values are all providers
# TODO: Add IXM_FETCH_API_<PROVIDERS> as a cache variable (of some kind)
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

(Actual name not yet determined)
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

XXX: If we ever pass a filepath/directory to Fetch, we include it, as if the
contents of the file had been passed to us in the following way below.
Fetch(
  HUB {
    redis/hiredis@v0.14.0,
    PATCH:path/to/patch
  }
  Fetch(HUB{cpp-netlib/uri@v1.1.0},TARGET:network-uri,DISABLE:Uri_BUILD_TESTS;Uri_BUILD_DOCS;Uri_WARNINGS_AS_ERRORS}
)

Basically it's a way for us to generically construct URLs based on arguments,
as well as define the TLA for a given variable at the head of the URI scheme

]]

# Each Provider MUST define a function titled: FetchContent_<PROVIDER>
# Providers may only be 3 letters

#[[This function prepares all the Fetch API providers for a regex]]
function (ixm_fetch_providers_prepare var)
  if (NOT IXM_FETCH_API_PROVIDERS_REGEX)
    foreach (provider IN LISTS IXM_FETCH_API_PROVIDERS)
      string(REGEX REPLACE "([A-Z])" "\[\\1\]" prepared ${provider})
      list(APPEND providers ${prepared})
    endforeach()
    list(JOIN providers "|" providers)
    set(IXM_FETCH_API_PROVIDERS_REGEX ${providers} CACHE INTERNAL
      "Regex for finding valid Fetch providers")
  endforeach()
  set(${var} ${IXM_FETCH_API_PROVIDERS_REGEX} PARENT_SCOPE)
endfunction()

#[[
Prepares the resource to receive both the provider and recipe, as well as any

]]
function (ixm_fetch_resource_prepare var)
  ixm_fetch_providers_prepare(providers)
  string(REGEX REPLACE "(${providers}){(.*)}" "\\1;\\2" ${var} ${var})
  upvar(${var})
endfunction()

function (Fetch)

endfunction()
