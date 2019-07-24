include_guard(GLOBAL)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

function (coven_package_init)
  string(MAKE_C_IDENTIFIER "${PROJECT_NAME}" project)
  string(TOUPPER "${project}" project)
  # Only generate these options if BUILD_PACKAGE is enabled
  # Additionally, only do these if certain tools have been found.
  # Basically, we need a 
  #option(${project}_PACKAGE_ARCHIVE "<DESCRIPTION NEEDED>")
  #if (NOT WIN32 AND NOT APPLE AND NOT ANDROID)
  #  option(${project}_PACKAGE_APPIMAGE "<DESCRIPTION NEEDED>")
  #  option(${project}_PACKAGE_RPM "<DESCRIPTION NEEDED>")
  #  option(${project}_PACKAGE_DEB "<DESCRIPTION NEEDED>")
  #endif()
  #if (APPLE)
  #  option(${project}_PACKAGE_BUNDLE "<DESCRIPTION NEEDED>")
  #  option(${project}_PACKAGE_PKG "<DESCRIPTION NEEDED>") 
  #endif()
  #if (WIN32)
  #  option(${project}_PACKAGE_NUGET "")
  #  option(${project}_PACKAGE_MSI "")
  #endif()
  #if (CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
  #  option(${project}_PACKAGE_BSD)
  #endif()
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
