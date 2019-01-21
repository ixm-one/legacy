include_guard(GLOBAL)

# This is where all properties, cache values, builtin options, are declared.

# Build System Settings
global(IXM_SOURCE_EXTENSIONS cxx;cpp;c++;cc;c;mm;m)
global(IXM_TARGET_PROPERTIES)

cache(BOOL IXM_UNITY_BUILD ON)

# Fetch Properties
global(IXM_FETCH_PROVIDERS HUB;LAB;BIT;WEB;SSH;URL;ADD;USE;BIN;S3B;SVN;CVS;CMD)
global(IXM_FETCH_HUB ixm_fetch_hub)
global(IXM_FETCH_LAB ixm_fetch_lab)
global(IXM_FETCH_BIT ixm_fetch_bit)
global(IXM_FETCH_WEB ixm_fetch_web)
global(IXM_FETCH_SSH ixm_fetch_ssh)
global(IXM_FETCH_URL ixm_fetch_url)
global(IXM_FETCH_ADD ixm_fetch_add)
global(IXM_FETCH_USE ixm_fetch_use)
global(IXM_FETCH_BIN ixm_fetch_bin)
global(IXM_FETCH_S3B ixm_fetch_s3b)
global(IXM_FETCH_SVN ixm_fetch_svn)
global(IXM_FETCH_CVS ixm_fetch_cvs)
global(IXM_FETCH_CMD ixm_fetch_cmd)

# Layout Properties
global(IXM_CURRENT_LAYOUT_NAME)
global(IXM_CURRENT_LAYOUT_FILE)
