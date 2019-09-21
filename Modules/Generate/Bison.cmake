include_guard(GLOBAL)

function (ixm_generate_bison_sources target)
  aspect(GET path:generate AS directory)

  genexp(bison-output-language $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_OUTPUT_LANGUAGE>>:
    -L$<TARGET_PROPERTY:${target},BISON_OUTPUT_LANGUAGE>
  >)

  genexp(bison-skeleton-file $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_SKELETON_FILE>>:
    --skeleton=$<TARGET_PROPERTY:${target},BISON_SKELETON_FILE>
  >)

  genexp(bison-no-lines $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_NO_LINES>>:--no-lines
  >)

  genexp(bison-output-graph $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_OUTPUT_GRAPH>>:
    --graph=$<TARGET_PROPERTY:${target},BISON_OUTPUT_GRAPH>
  >)

  genexp(bison-file-prefix $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_FILE_PREFIX>>:
    --file-prefix=$<TARGET_PROPERTY:${target},BISON_FILE_PREFIX>
  >)

  genexp(bison-report-file $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_REPORT_FILE>>:
    --report-file=$<TARGET_PROPERTY:${target},BISON_REPORT_FILE>
  >)

  genexp(bison-verbose $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_VERBOSE>>:--verbose
  >)

  genexp(bison-header $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_DEFINES_HEADER>>:
    --defines=$<TARGET_PROPERTY:${target},BISON_DEFINES_HEADER>
  >)

  genexp(bison-token-table $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_TOKEN_TABLE>>:
    --token-table
  >)

  genexp(bison-locations $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_LOCATIONS>>:
    --locations
  >)

  genexp(bison-errors-caret $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_ERRORS_CARET>>:
    --feature=caret
  >)

  genexp(bison-report $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_REPORT>>:
    --report=$<JOIN:$<TARGET_PROPERTY:${target},BISON_REPORT>,$<COMMA>>
  >)

  genexp(bison-warnings $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_WARNINGS>>:
    --warnings=$<JOIN:$<TARGET_PROPERTY:${target},BISON_WARNINGS>,$<COMMA>>
  >)

  genexp(bison-defines $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_DEFINES>>:
    -D$<JOIN:$<TARGET_PROPERTY:${target},BISON_DEFINES>,$<SEMICOLON>-D>
  >)

  genexp(bison-force-defines $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_FORCE_DEFINES>>:
    -F$<JOIN:$<TARGET_PROPERTY:${target},BISON_FORCE_DEFINES>,$<SEMICOLON>-F>
  >)

  genexp(bison-posix-compat $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_POSIX_COMPATIBILITY>>:
    --yacc
  >)

  add_custom_command(
    OUTPUTS # TODO
    COMMAND Bison::Bison
      ${bison-output-language}
      ${bison-skeleton-file}
      ${bison-force-defines}
      ${bison-errors-caret}
      ${bison-output-graph}
      ${bison-posix-compat}
      ${bison-token-table}
      ${bison-report-file}
      ${bison-file-prefix}
      ${bison-locations}
      ${bison-no-lines}
      ${bison-defines}
      ${bison-verbose}
      ${bison-header}
      ${bison-report}
    COMMENT "Generating Bison sources for '${target}'"
    COMMAND_EXPAND_LISTS
    VERBATIM)

endfunction()
