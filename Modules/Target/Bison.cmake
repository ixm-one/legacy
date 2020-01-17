include_guard(GLOBAL)

# TODO: Move this to Target/Bison.cmake (this way it's just a simple include
# once kind of deal)
function (target_bison_sources target)
  target_source_files(${target} ${ARGN} FILETYPE "BISON")
endfunction()

function (add_bison_target name)
  add_library(${name} OBJECT)
  target_sources(${name} PRIVATE ${ARGN})

  # These options take a list (and should thus be appended to)
  set(force-defines $<TARGET_PROPERTY:${name},BISON_FORCE_DEFINES>)
  set(warnings $<TARGET_PROPERTY:${name},BISON_WARNINGS>)
  set(defines $<TARGET_PROPERTY:${name},BISON_DEFINES>)
  set(options $<TARGET_PROPERTY:${name},BISON_OPTIONS>)
  set(report $<TARGET_PROPERTY:${name},BISON_REPORT>)

  # These properties take one value
  set(output-language $<TARGET_PROPERTY:${name},BISON_OUTPUT_LANGUAGE>)
  set(file-prefix $<TARGET_PROPERTY:${name},BISON_FILE_PREFIX>)
  set(skeleton-file $<TARGET_PROPERTY:${name},BISON_SKELETON_FILE>)
  set(header-file $<TARGET_PROPERTY:${name},BISON_HEADER_FILE>)
  set(report-file $<TARGET_PROPERTY:${name},BISON_REPORT_FILE>)
  set(graph-file $<TARGET_PROPERTY:${name},BISON_OUTPUT_GRAPH>)

  # These options are simple toggle flags
  set(posix-compatibility $<TARGET_PROPERTY:${name},BISON_POSIX_COMPATIBILITY>)
  set(errors-caret $<TARGET_PROPERTY:${name},BISON_ERRORS_CARET>)
  set(token-table $<TARGET_PROPERTY:${name},BISON_TOKEN_TABLE>)
  set(locations $<TARGET_PROPERTY:${name},BISON_LOCATIONS>)
  set(no-lines $<TARGET_PROPERTY:${name},BISON_NO_LINES>)
  set(verbose $<TARGET_PROPERTY:${name},BISON_VERBOSE>)

  set(output-language $<$<BOOL:${output-language}>:--language=${output-language}>)
  set(skeleton-file $<$<BOOL:${skeleton-file}>:--skeleton=${skeleton-file}>)
  set(header-file $<$<BOOL:${header-file}>:--defines=${header-file}>)
  set(report-file $<$<BOOL:${report-file}>:--report-file=${report-file}>)
  set(file-prefix $<$<BOOL:${file-prefix}>:--file-prefix=${file-prefix}>)
  set(graph-file $<$<BOOL:${graph-file}>:--graph=${graph-file}>)

  string(CONCAT force-defines $<
    $<BOOL:${force-defines}>:-F$<JOIN:${force-defines},$<SEMICOLON>-F>
  >)
  set(defines $<$<BOOL:${defines}>:-D$<JOIN:${defines},$<SEMICOLON>-D>>)
  set(options $<$<BOOL:${options}>:$<JOIN:${options},$<SEMICOLON>>>)
  set(warnings $<$<BOOL:${warnings}>:--warnings=$<JOIN:${warnings},$<COMMA>>)
  set(report $<$<BOOL:${report}>:--report=$<JOIN:${report}>,$<COMMA>>)

  set(posix-compatibility $<$<BOOL:${posix-compatibility}>:--yacc>)
  set(errors-caret $<$<BOOL:${errors-caret}>:--feature=caret>)
  set(token-table $<$<BOOL:${token-table}>:--token-table>)
  set(locations $<$<BOOL:${locations}>:--locations>)
  set(no-lines $<$<BOOL:${no-lines}>:--no-lines>)
  set(verbose $<$<BOOL:${verbose}>:--verbose>)

  # TODO: add_custom_command doesn't understand the idea of generator expressions
  # So the output needs to be something else, possibly a function that is set via
  # variable_watch and then executes on exit...
  aspect(GET path:generate AS directory)
  add_custom_command(
    OUTPUTS "${name}.bison.cxx"
    COMMAND Bison::Bison
      ${force-defines}
      ${defines}
      ${options}
      ${warnings}
      ${reports}

      ${output-language}
      ${skeleton-file}
      ${header-file}
      ${report-file}
      ${file-prefix}
      ${graph-file}

      ${posix-compatibility}
      ${errors-caret}
      ${token-table}
      ${locations}
      ${no-lines}
      ${verbose}
    DEPENDS $<TARGET_PROPERTY:${name},BISON_SOURCES>
            $<TARGET_PROPERTY:${name},BISON_DEPENDS>
    COMMENT "Generating sources for '${name}'"
    COMMAND_EXPAND_LISTS
    VERBATIM)
endfunction()
