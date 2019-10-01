include_guard(GLOBAL)

# TODO: Need to come up with a new model to delay actual creation of custom
# targets and custom commands until *after* everything is done configuring.
function (ixm_generate_flex target)
  aspect(GET path:generate AS directory)

  # Table Compression
  string(CONCAT flex-align $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_ALIGN>>:--align
  >)

  string(CONCAT flex-ecs $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_EQUIVALENCE_CLASSES>>:
    --ecs
  >)

  string(CONCAT flex-meta-ecs $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_META_EQUIVALENCE_CLASSES>>:
    --meta-ecs
  >)

  string(CONCAT flex-full $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_FULL>>:--full>)
  string(CONCAT flex-fast $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_FAST>>:--fast>)
  string(CONCAT flex-read $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_READ>>:--read>)

  # Codegen
  string(CONCAT flex-prefix $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_PREFIX>>:
    --prefix=$<TARGET_PROPERTY:${target},FLEX_PREFIX>
  >)

  string(CONCAT flex-reentrant $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_REENTRANT>>:
    --reentrant
  >)

  string(CONCAT flex-noline $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_NOLINE>>:
    --noline
  >)

  string(CONCAT flex-no-unistd $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_NO_UNISTD>>:--nounistd
  >)

  string(CONCAT flex-bison-locations $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_BISON_LOCATIONS>>--bison-locations
  >)

  string(CONCAT flex-bison-bridge $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_BISON_BRIDGE>>:--bison-bridge
  >)

  string(CONCAT flex-cxx $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_CXX>>:--c++>)

  string(CONCAT flex-no-func $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_DISABLE_FUNCTION>>:
    --no$<JOIN:
      $<TARGET_PROPERTY:${target},FLEX_DISABLE_FUNCTION>,
      $<SEMICOLON>--no
    >
  >)

  string(CONCAT flex-macros $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_DEFINES>>:
    -D$<JOIN:$<TARGET_PROPERTY:${target},FLEX_DEFINES>,$<SEMICOLON>-D>
  >)

  # Debugging
  string(CONCAT flex-backup $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_BACKUP>>:--backup>)
  string(CONCAT flex-debug $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_DEBUG>>:--debug>)
  string(CONCAT flex-perf-report $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_PERF_REPORT>>:--perf-report
  >)
  string(CONCAT flex-no-default $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_NO_DEFAULT>>:--nodefault
  >)
  string(CONCAT flex-trace $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_TRACE>>:--trace
  >)
  string(CONCAT flex-no-warn $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_NO_WARN>>:--flex-nowarn
  >)
  string(CONCAT flex-verbose $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_VERBOSE>>:--verbose
  >)
  string(CONCAT flex-hex $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_HEX>>:--hex
  >)

  # Scanner options
  string(CONCAT flex-7bit $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_7BIT>>:--7bit
  >)

  string(CONCAT flex-8bit $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_8BIT>>:--8bit
  >)

  string(CONCAT lex-compat $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_LEX_COMPATIBILITY>>:
    --posix-compat
  >)

  string(CONCAT flex--line-count $<
    $<$BOOL:$<TARGET_PROPERTY,${target},FLEX_COUNT_LINES>=FLEX_TRACK_LINE_COUNT>
    --yylineno
  >)

  string(CONCAT flex-insensitive $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_CASE_INSESNSITIVE>>:
    --case-insensitive
  >)

  # Files
  string(CONCAT flex-skeleton $<
    $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_SKELETON_FILE>>:
    --skel=$<TARGET_PROPERTY:${target},FLEX_SKELETON_FIL>
  >)

  string(CONCAT flex-cxx-class $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_CXX_CLASS>>:
    --yyclass=$<TARGET_PROPERTY:${target}>
  >)

  string(CONCAT flex-header-file $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_HEADER_FILE>>:
    --header-file=$<TARGET_PROPERTY:${target}>
  >)

  string(CONCAT flex-tables-files $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_TABLES_FILE>>:
    --tables-file=$<TARGET_PROPERTY:${target},FLEX_TABLES_FILE>
  >)

  string(CONCAT flex-backup-files $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_BACKUP_FILE>>:
    --backup-file=$<TARGET_PROPERTY:${target},FLEX_BACKUP_FILE>
  >)

  string(CONCAT flex-out-file $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_OUTPUT_FILE>>:
    --outfile=$<TARGET_PROPERTY:${target},FLEX_OUTPUT_FILE>
  >)

  target(SOURCES ${target} PRIVATE $<TARGET_PROPERTY:FLEX_OUTPUT_FILE>)
endfunction()
