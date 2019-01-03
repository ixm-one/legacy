include_guard(GLOBAL)

#[[
NOTES:
We need to overhaul the syntax we use for getting dependencies via
FetchContent. Basically, we want to do something like ExternalData's
DATA{} variables.
Current variable types are (in order of supported priority):
(Planned) IXM{$NAME@$REV} IXM.ALIASA.IO download (but reserved for CMake projects)
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
AS3{S3 storage compatible info...} -> S3 Bucket access
SVN{BecauseYouHateYourSelf} -> SVN
CVS{WhoHurtYou?} -> CVS
CMD{Command} -> We'll look up how to do this later, but it's important to
                support for extension purposes.

Possible TLA's include AWS, S3B (S3 Bucket), AS3 and others. We'll figure out
what to do later

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

XXX: If we ever pass a filepath/directory to Fetch, we include it, as if the
contents of the file had been passed to us in the following way below.
Fetch(
  HUB {
    redis/hiredis@v0.14.0,
    PATCH:path/to/patch
  }
  HUB {
    cpp-netlib/uri@v1.1.0,
    TARGET:network-uri,
    DISABLE:
      Uri_BUILD_TESTS
      Uri_BUILD_DOCS
      Uri_WARNINGS_AS_ERRORS
  }
)

Basically it's a way for us to generically construct URLs based on arguments,
as well as define the TLA for a given variable at the head of the URI scheme

]]

import(Support)
import(Content)
import(Archive)
import(Aliasa)
import(Extern)
import(Header)
import(Git)

# TODO: Move to Vars module
set(IXM_PREFER_CLONE OFF)
set(IXM_BITBUCKET_PREFER_CLONE ${IXM_PREFER_CLONE})
set(IXM_GITHUB_PREFER_CLONE ${IXM_PREFER_CLONE})
set(IXM_GITLAB_PREFER_CLONE ${IXM_PREFER_CLONE})

macro (github pkg)
  if (IXM_GITHUB_PREFER_CLONE)
    githttps(${pkg} DOMAIN github.com ${ARGN})
  else()
    aliasa(${pkg} PROVIDER hub ${ARGN})
  endif()
endmacro()

macro (gitlab pkg)
  if (IXM_GITLAB_PREFER_CLONE)
    githttps(${pkg} DOMAIN github.com ${ARGN})
  else()
    aliasa(${pkg} PROVIDER hub ${ARGN})
  endif()
endmacro()

macro (bitbucket pkg)
  if (IXM_BITBUCKET_PREFER_CLONE)
    githttps(${pkg} DOMAIN bitbucket.com ${ARGN})
  else()
    aliasa(${pkg} PROVIDER bit ${ARGN})
  endif()
endmacro()

macro (githttps pkg)
  gitclone(${pkg} ${ARGN} SCHEME "https://")
endmacro()

macro(gitssh pkg)
  gitclone(${pkg} ${ARGN} SCHEME "ssh://" SEPARATOR ":")
endmacro()
