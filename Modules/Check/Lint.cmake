include_guard(GLOBAL)

# This is an experimental function. The idea is that given a "well known" name
# like 'unused-parameter', a generator expression is produced that can be 
# added to a target. This generator expression will
# 1) Check if the LINT_<NAME> value is set to ALLOW, DENY, or FORBID
# 2) Select the correct flag for a given compiler if possible
# 3) Only require users to set the LINT_<NAME> properties
# 
# in practice, users will most likely just do
#[[
```cmake
target(LINT <target-name>
  PRIVATE
    lint-name1
    lint-name2
  PUBLIC
    lint-name3
  INTERFACE
    lint-name4)
```]]
# However this *doesn't* handle the case of ALLOW, DENY, FORBID. For that we
# would need something like `PRIVATE ALLOW X Y Z DENY A B C FORBID G H I`, which
# will probably get hairy. How this is handled does not matter. The important part
# is that this function simply checks if you *can* use any of these lints in the
# first place.
function(ixm_check_lint)
endfunction()
