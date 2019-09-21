find(LIBRARY SDL2_image COMPONENT Image)
find(LIBRARY SDL2_mixer COMPONENT Mixer)
find(LIBRARY SDL2_ttf COMPONENT Font)
find(LIBRARY SDL2main COMPONENT Main)
find(LIBRARY SDL2_net COMPONENT Net)
find(LIBRARY SDL2)
find(INCLUDE SDL2/SDL.h)

# TODO: Some work is needed to abstract this in the same way we do for
# find(PROGRAM)
if (SDL2_INCLUDE_DIR)
  file(STRINGS ${SDL2_INCLUDE_DIR}/SDL2/SDL_version.h version-file
    REGEX "#define[ \t]SDL_(MAJOR|MINOR|PATCHLEVEL).*")
  if (NOT version-file)
    log(WARN "SDL2_INCLUDE_DIR found, but SDL_version.h is missing")
  endif()
  list(GET version-file 0 major-line)
  list(GET version-file 1 minor-line)
  list(GET version-file 2 patch-line)
  string(REGEX REPLACE "^#define[ \t]+SDL_MAJOR_VERSION[ \t]+([0-9]+)$" "\\1" SDL2_VERSION_MAJOR ${version-file})
  string(REGEX REPLACE "^#define[ \t]+SDL_MINOR_VERSION[ \t]+([0-9]+)$" "\\1" SDL2_VERSION_MINOR ${version-file})
  string(REGEX REPLACE "^#define[ \t]+SDL_PATCHLEVEL[ \t]+([0-9]+)$" "\\1" SDL_VERSION_PATCH ${version-file})
  set(SDL_VERSION ${SDL_VERSION_MAJOR}.${SDL_VERSION_MINOR}.${SDL_VERSION_PATCH})
  if (TARGET SDL2::SDL2)
    set_property(TARGET SDL2::SDL2 PROPERTY VERSION ${SDL_VERSION})
  endif()
endif()

# There should be an easier way to allow linking this way
if (TARGET SDL2::SDL2)
  target_link_libraries(SDL2::SDL2 INTERFACE
    $<TARGET_NAME_IF_EXISTS:SDL2::Image>
    $<TARGET_NAME_IF_EXISTS:SDL2::Mixer>
    $<TARGET_NAME_IF_EXISTS:SDL2::Font>
    $<TARGET_NAME_IF_EXISTS:SDL2::Net>)
endif()

# Same with this
if (TARGET SDL2::Main)
  target_link_libraries(SDL2::Main INTERFACE SDL2::SDL2)
endif()
