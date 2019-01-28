list(APPEND versions 9 8 7 6.0 5.0) # A little bit of future proofing :)

set(format-names ${versions})
set(check-names ${versions})
set(tidy-names ${versions})

list(TRANSFORM format-names PREPEND clang-format-)
list(TRANSFORM check-names PREPEND clang-check-)
list(TRANSFORM tidy-names PREPEND clang-tidy-)

list(APPEND format-names clang-format)
list(APPEND check-names clang-check)
list(APPEND tidy-names clang-tidy)

Find(PROGRAM ${format-names} COMPONENT Format)
Find(PROGRAM ${check-names} COMPONENT Check)
Find(PROGRAM ${tidy-names} COMPONENT Tidy)
