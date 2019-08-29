include_guard(GLOBAL)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

find_package(NuGet QUIET)
find_package(WiX QUIET)

function (coven_package_init)
  string(MAKE_C_IDENTIFIER "${PROJECT_NAME}" project)
  string(TOUPPER "${project}" project)
  set(var BUILD_PACKAGE)
  set(unix-only "NOT WIN32" "NOT APPLE" "NOT ANDROID")

  cmake_dependent_option(BUILD_PACKAGE_ARCHIVE "Generate tarball" ON
    "${var}" OFF)
  cmake_dependent_option(BUILD_PACKAGE_ZIP "Generate zip archive" ON
    "${var}" OFF)

  cmake_dependent_option(BUILD_PACKAGE_APPIMAGE "Generate an AppImage" ON
    "${unix-only}" OFF)
  cmake_dependent_option(BUILD_PACKAGE_RPM "Generate an RPM" ON
    "${unix-only}" OFF)
  cmake_dependent_option(BUILD_PACKAGE_DEB "Generate a DEB" ON
    "${unix-only}" OFF)

  cmake_dependent_option(BUILD_PACKAGE_NUGET "Generate a NuGet package" ON
    "${var};WIN32;NuGet_FOUND" OFF)
  cmake_dependent_option(BUILD_PACKAGE_MSI "Generate an MSI" ON
    "${var};WIN32;WiX_FOUND" OFF)

  cmake_dependent_option(BUILD_PACKAGE_BUNDLE "Generate a .app" ON
    "${var};APPLE" OFF)
  cmake_dependent_option(BUILD_PACKAGE_PKG "Generate a .pkg" ON
    "${var};APPLE" OFF)

  coven_package_configuration()
endfunction()

function (coven_package_configuration)
  set(version "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake")
  set(config "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake")
  set(template "${IXM_ROOT}/Templates/package-config.cmake.in")
  set(dest "${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}")
  write_basic_package_version_file(${version} COMPATIBILITY SameMajorVersion)
  configure_package_config_file(${template} ${config}
    INSTALL_DESTINATION ${dest})
  install(FILES ${version} ${config} DESTINATION ${dest})
endfunction()

function (coven_package_export)
endfunction()
