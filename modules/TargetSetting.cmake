include_guard(GLOBAL)

function (setting name brief full)
  define_property(TARGET PROPERTY ${name} BRIEF_DOCS ${brief} FULL_DOCS ${full})
endfunction()

