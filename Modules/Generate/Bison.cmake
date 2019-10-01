include_guard(GLOBAL)

function (ixm_generate_bison_sources target)
  aspect(GET path:generate AS directory)

  string(CONCAT bison-output-language $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_OUTPUT_LANGUAGE>>:
    -L$<TARGET_PROPERTY:${target},BISON_OUTPUT_LANGUAGE>
  >)

  string(CONCAT bison-skeleton-file $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_SKELETON_FILE>>:
    --skeleton=$<TARGET_PROPERTY:${target},BISON_SKELETON_FILE>
  >)

  string(CONCAT bison-no-lines $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_NO_LINES>>:--no-lines
  >)

  string(CONCAT bison-output-graph $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_OUTPUT_GRAPH>>:
    --graph=$<TARGET_PROPERTY:${target},BISON_OUTPUT_GRAPH>
  >)

  string(CONCAT bison-file-prefix $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_FILE_PREFIX>>:
    --file-prefix=$<TARGET_PROPERTY:${target},BISON_FILE_PREFIX>
  >)

  string(CONCAT bison-report-file $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_REPORT_FILE>>:
    --report-file=$<TARGET_PROPERTY:${target},BISON_REPORT_FILE>
  >)

  string(CONCAT bison-verbose $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_VERBOSE>>:--verbose
  >)

  string(CONCAT bison-header $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_DEFINES_HEADER>>:
    --defines=$<TARGET_PROPERTY:${target},BISON_DEFINES_HEADER>
  >)

  string(CONCAT bison-token-table $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_TOKEN_TABLE>>:
    --token-table
  >)

  string(CONCAT bison-locations $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_LOCATIONS>>:
    --locations
  >)

  string(CONCAT bison-errors-caret $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_ERRORS_CARET>>:
    --feature=caret
  >)

  string(CONCAT bison-report $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_REPORT>>:
    --report=$<JOIN:$<TARGET_PROPERTY:${target},BISON_REPORT>,$<COMMA>>
  >)

  string(CONCAT bison-warnings $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_WARNINGS>>:
    --warnings=$<JOIN:$<TARGET_PROPERTY:${target},BISON_WARNINGS>,$<COMMA>>
  >)

  string(CONCAT bison-defines $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_DEFINES>>:
    -D$<JOIN:$<TARGET_PROPERTY:${target},BISON_DEFINES>,$<SEMICOLON>-D>
  >)

  string(CONCAT bison-force-defines $<
    $<BOOL:$<TARGET_PROPERTY:${target},BISON_FORCE_DEFINES>>:
    -F$<JOIN:$<TARGET_PROPERTY:${target},BISON_FORCE_DEFINES>,$<SEMICOLON>-F>
  >)

  string(CONCAT bison-posix-compat $<
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
