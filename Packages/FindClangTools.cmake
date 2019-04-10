list(APPEND versions 9 8 7 6.0 5.0) # A little bit of future proofing :)

list(TRANSFORM versions PREPEND clang-format- OUTPUT_VARIABLE format-names)
list(TRANSFORM versions PREPEND clang-check- OUTPUT_VARIABLE check-names)
list(TRANSFORM versions PREPEND clang-tidy- OUTPUT_VARIABLE tidy-names)

list(APPEND format-names clang-format)
list(APPEND check-names clang-check)
list(APPEND tidy-names clang-tidy)

find(PROGRAM ${format-names} COMPONENT Format)
find(PROGRAM ${check-names} COMPONENT Check)
find(PROGRAM ${tidy-names} COMPONENT Tidy)
