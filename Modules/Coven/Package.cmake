include_guard(GLOBAL)

include(CMakePackageConfigHelpers)

function (ixm_coven_package_options)
  option(${PROJECT_NAME}_PACKAGE_APPIMAGE)
  option(${PROJECT_NAME}_PACKAGE_ARCHIVE) # Classic TarBall
  option(${PROJECT_NAME}_PACKAGE_BUNDLE) # .app
  option(${PROJECT_NAME}_PACKAGE_NUGET)
  option(${PROJECT_NAME}_PACKAGE_MSI) # WiX
  option(${PROJECT_NAME}_PACKAGE_RPM)
  option(${PROJECT_NAME}_PACKAGE_DEB)
  option(${PROJECT_NAME}_PACKAGE_PKG) # productbuild
  # pkg(8), but they don't end with a file extension
  option(${PROJECT_NAME}_PACKAGE_BSD)
endfunction()

# Initial tidbits for generating an automatic packaging system :)
function(ixm_coven_generate_package)
  set(version "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake")
  set(config "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake")
  set(template "${IXM_ROOT}/Templates/package-config.cmake.in")
  set(dest "share/cmake/${PROJECT_NAME}")
  write_basic_package_version_file(${version} COMPATIBILITY SameMajorVersion)
  configure_package_config_file(${template} ${config}
    INSTALL_DESTINATION ${dest})
  install(FILES ${version} ${config} DESTINATION ${dest})
endfunction()
