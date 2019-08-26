include_guard(GLOBAL)

#[[
This function replaces the need for `include(CPack)`. It generates a
CPackConfig.cmake file via `file(GENERATE)`. It ONLY creates a `package`
target, as well as a `dist` target. `package_source` is not created.

Additionally, we ONLY permit the use of the `install()` command.
]]
function (ixm_project_generate_package)
  genexp(cpack-package-name $<IF:
    $<BOOL:$<TARGET_PROPERTY:ixm::package,PACKAGE_NAME>>,
    $<TARGET_PROPERTY:ixm::package,PACKAGE_NAME>,
    ${PROJECT_NAME}
  >)
  genexp(cpack-package-vendor $<IF:
    $<BOOL:$<TARGET_PROPERTY:ixm::package,PACKAGE_VENDOR>>,
    $<TARGET_PROPERTY:ixm::package,PACKAGE_VENDOR>,
    "Humanity"
  >)
  genexp(cpack-config-file $<IF:
      $<BOOL:$<TARGET_PROPERTY:ixm::package,PACKAGE_FILE>>,
      $<TARGET_PROPERTY:ixm::package,PACKAGE_FILE>,
      "${CMAKE_BINARY_DIR}/CPackConfig.cmake"
  >)
  genexp(cpack-input-file $<IF:
      $<BOOL:$<TARGET_PROPERTY:ixm::package,PACKAGE_CONFIG_FILE>>,
      $<TARGET_PROPERTY:ixm::package,PACKAGE_CONFIG_FILE>
      "${IXM_ROOT}/Templates/cpack.cmake"
  >)
  file(GENERATE
    OUTPUT ${cpack-output-file}
    INPUT ${cpack-input-file}
    CONDITION $<TARGET_EXISTS:ixm::package>)
endfunction()
