get_filename_component(mono-sdk-install-root
  [HKEY_LOCAL_MACHINE\\Software\\Mono;SdkInstallRoot]
  ABSOLUTE)
list(APPEND CMAKE_PREFIX_PATH ${mono-sdk-install-root})
find(PROGRAM mcs.bat mcs COMPONENT Compiler)
find(PROGRAM monodis COMPONENT Disassembler)
find(PROGRAM mono-sgen COMPONENT SGen)
find(PROGRAM mono)
