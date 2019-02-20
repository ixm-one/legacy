include_guard(GLOBAL)

if (NOT WIN32) # We are looking for the mingw64 cross-compiler
  set(CMAKE_SYSTEM_NAME Windows)
  set(prefix x86_64-w64-mingw32)
  find_program(CMAKE_C_COMPILER "${prefix}-gcc")
  if (NOT CMAKE_C_COMPILER)
    error("Could not find '${prefix}-gcc'")
  endif()

  get_filename_component(CMAKE_STAGING_PREFIX "${CMAKE_C_COMPILER}" DIRECTORY)
  get_filename_component(CMAKE_SYSROOT "${CMAKE_STAGING_PREFIX}/.." ABSOLUTE)

  find_program(CMAKE_CXX_COMPILER "${prefix}-g++" PATHS bin)
  find_program(CMAKE_ASM_COMPILER "${prefix}-as" PATHS bin)
  find_program(CMAKE_RC_COMPILER "${prefix}-windres" PATHS bin)

  internal(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
endif()
