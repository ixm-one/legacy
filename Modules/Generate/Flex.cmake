include_guard(GLOBAL)

# TODO: Need to come up with a new model to delay actual creation of custom
# targets and custom commands until *after* everything is done configuring.
function (ixm_generate_flex target)
  aspect(GET path:generate AS directory)

  # Table Compression
  genexp(flex-align $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_ALIGN>>:--align
  >)

  genexp(flex-ecs $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_EQUIVALENCE_CLASSES>>:
    --ecs
  >)

  genexp(flex-meta-ecs $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_META_EQUIVALENCE_CLASSES>>:
    --meta-ecs
  >)

  genexp(flex-full $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_FULL>>:--full>)
  genexp(flex-fast $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_FAST>>:--fast>)
  genexp(flex-read $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_READ>>:--read>)

  # Codegen
  genexp(flex-prefix $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_PREFIX>>:
    --prefix=$<TARGET_PROPERTY:${target},FLEX_PREFIX>
  >)

  genexp(flex-reentrant $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_REENTRANT>>:
    --reentrant
  >)

  genexp(flex-noline $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_NOLINE>>:
    --noline
  >)

  genexp(flex-no-unistd $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_NO_UNISTD>>:--nounistd
  >)

  genexp(flex-bison-locations $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_BISON_LOCATIONS>>--bison-locations
  >)

  genexp(flex-bison-bridge $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_BISON_BRIDGE>>:--bison-bridge
  >)

  genexp(flex-cxx $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_CXX>>:--c++>)

  genexp(flex-no-func $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_DISABLE_FUNCTION>>:
    --no$<JOIN:
      $<TARGET_PROPERTY:${target},FLEX_DISABLE_FUNCTION>,
      $<SEMICOLON>--no
    >
  >)

  genexp(flex-macros $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_DEFINES>>:
    -D$<JOIN:$<TARGET_PROPERTY:${target},FLEX_DEFINES>,$<SEMICOLON>-D>
  >)

  # Debugging
  genexp(flex-backup $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_BACKUP>>:--backup>)
  genexp(flex-debug $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_DEBUG>>:--debug>)
  genexp(flex-perf-report $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_PERF_REPORT>>:--perf-report
  >)
  genexp(flex-no-default $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_NO_DEFAULT>>:--nodefault
  >)
  genexp(flex-trace $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_TRACE>>:--trace
  >)
  genexp(flex-no-warn $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_NO_WARN>>:--flex-nowarn
  >)
  genexp(flex-verbose $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_VERBOSE>>:--verbose
  >)
  genexp(flex-hex $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_HEX>>:--hex
  >)

  # Scanner options
  genexp(flex-7bit $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_7BIT>>:--7bit
  >)

  genexp(flex-8bit $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_8BIT>>:--8bit
  >)

  genexp(lex-compat $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_LEX_COMPATIBILITY>>:
    --posix-compat
  >)

  genexp(flex--line-count $<
    $<$BOOL:$<TARGET_PROPERTY,${target},FLEX_COUNT_LINES>=FLEX_TRACK_LINE_COUNT>
    --yylineno
  >)

  genexp(flex-insensitive $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_CASE_INSESNSITIVE>>:
    --case-insensitive
  >)

  # Files
  genexp(flex-skeleton $<
    $<$<BOOL:$<TARGET_PROPERTY:${target},FLEX_SKELETON_FILE>>:
    --skel=$<TARGET_PROPERTY:${target},FLEX_SKELETON_FIL>
  >)

  genexp(flex-cxx-class $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_CXX_CLASS>>:
    --yyclass=$<TARGET_PROPERTY:${target}>
  >)

  genexp(flex-header-file $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_HEADER_FILE>>:
    --header-file=$<TARGET_PROPERTY:${target}>
  >)

  genexp(flex-tables-files $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_TABLES_FILE>>:
    --tables-file=$<TARGET_PROPERTY:${target},FLEX_TABLES_FILE>
  >)

  genexp(flex-backup-files $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_BACKUP_FILE>>:
    --backup-file=$<TARGET_PROPERTY:${target},FLEX_BACKUP_FILE>
  >)

  genexp(flex-out-file $<
    $<BOOL:$<TARGET_PROPERTY:${target},FLEX_OUTPUT_FILE>>:
    --outfile=$<TARGET_PROPERTY:${target},FLEX_OUTPUT_FILE>
  >)

  target(SOURCES ${target} PRIVATE $<TARGET_PROPERTY:FLEX_OUTPUT_FILE>)
endfunction()
