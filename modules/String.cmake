include_guard(GLOBAL)

macro (lowercase var)
  if (${ARGC} EQUAL 2)
    string(TOLOWER ${${var}} ${ARGV1})
  else()
    string(TOLOWER ${${var}} ${var})
  endif()
endmacro()

macro (uppercase var)
  if (${ARGC} EQUAL 2)
    string(TOUPPER ${${var}} ${ARGV1})
  else()
    string(TOUPPER ${${var}} ${var})
  endif()
endmacro()


