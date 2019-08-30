include_guard(GLOBAL)

#[[ This function is intended to replace the need for `include(CPack)`.
It generates a CPackConfig.cmake file via file(GENERATE), rather than via
`configure_file`. It creates a package and dist target. `package_source` is
not created.
]]
function (ixm_generate_package)
# This code must be cleaned up and modernized
#  genexp(cpack-package-name $<IF:
#    $<BOOL:$<TARGET_PROPERTY:ixm::package,PACKAGE_NAME>>,
#    $<TARGET_PROPERTY:ixm::package,PACKAGE_NAME>,
#    ${PROJECT_NAME}
#  >)
#  genexp(cpack-package-vendor $<IF:
#    $<BOOL:$<TARGET_PROPERTY:ixm::package,PACKAGE_VENDOR>>,
#    $<TARGET_PROPERTY:ixm::package,PACKAGE_VENDOR>,
#    "Humanity"
#  >)
#  genexp(cpack-config-file $<IF:
#      $<BOOL:$<TARGET_PROPERTY:ixm::package,PACKAGE_FILE>>,
#      $<TARGET_PROPERTY:ixm::package,PACKAGE_FILE>,
#      "${CMAKE_BINARY_DIR}/CPackConfig.cmake"
#  >)
#  genexp(cpack-input-file $<IF:
#      $<BOOL:$<TARGET_PROPERTY:ixm::package,PACKAGE_CONFIG_FILE>>,
#      $<TARGET_PROPERTY:ixm::package,PACKAGE_CONFIG_FILE>
#      "${IXM_ROOT}/Templates/cpack.cmake"
#  >)
#  file(GENERATE
#    OUTPUT ${cpack-output-file}
#    INPUT ${cpack-input-file}
#    CONDITION $<TARGET_EXISTS:ixm::package>)
endfunction()