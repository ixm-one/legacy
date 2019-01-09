import(IXM::Brujeria::*)
import(IXM::Fetch::*)

find_package(Python REQUIRED)

# This is a simpler layout than most others. In short, given a directory,
# inside, we generate a python module, adding all sources from src/*.{ext}
# and an include directory. The output module is placed into a specific
# directory passed from the brujeria tool.
ixm_brujeria_generate_module()


