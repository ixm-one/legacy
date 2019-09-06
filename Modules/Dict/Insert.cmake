include_guard(GLOBAL)

function (ixm_dict_insert @dict:name @dict:key)
endfunction()


function (ixm_dict_assign @dict:name @dict:key)
  set(message "dict(ASSIGN) requires at least one value")
endfunction()

function (ixm_dict_append @dict:name @dict:key)
  set(message "dict(APPEND) requires at least one value")
endfunction()

function (ixm_dict_concat @dict:name @dict:key)
  set(message "dict(CONCAT) requires at least one value")
endfunction()