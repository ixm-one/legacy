# Contributing to IXM

Thank you for your interest in making IXM better! There are several ways you
can get involved to help improve IXM for everyone.

## Reporting Issues

If you've run into an issue with IXM, please file an issue here on GitHub.
Make sure you select the correct template. If you've discovered an actual issue
with CMake itself, be sure to instead file the issue upstream with them.

## Suggesting New Features

IXM provides a slew of features that are typically needed in most projects.
However, in some cases, we might find it necessary to add new features, such as
programming languages, toolchains, or new API calls. Suggestions for new
features are welcome, however they must not violate the one rule of IXM:

 * We cannot break existing IXM projects

This means that after the 1.0 release, we will *never* change the existing
behavior of IXM unless there is an opt-in solution for a specific project *or*
if the feature never worked correctly in the first place.

The primary reason for this is to make sure projects stay stable. IXM is, after
all, a stepping stone to eventually let users migrate to other build systems.

## Localizing Documentation

IXM's documentation is currently written in english. However, this doesn't have
to be the case! Bilingual users might want to provide documentation for their
colleagues in their native tongue. To allow this, we use [Sphinx][1] and
[ReadTheDocs][2] localization facilities. More information on how to contribute
to the localization of IXM can be found in the [documentation][3]

## Accepted Contributions

IXM has a high bar for code quality, even if it is just for a bug fix. New
features must have a reason to be added if it is to the library and not for the
general CMake ecosystem (such as a programming language or toolchain).
Effectively, if the feature adds a new Core API call, or modifies existing
calls, serious work must be done to show its effectiveness.

## Code Changes

This section is mostly a work in progress. It will be updated at a later date.

### Preparing Your Development Environment

To make changes to IXM, be sure to do the following steps:

 * Fork IXM to your own repository
 * Clone your forked IXM into an easy to reach location
 * Configure a test project with `-DFETCHCONTENT_SOURCE_DIR_IXM=path/to/clone`
 * Begin making your changes to your local IXM fork

### Style Guidelines

### Testing


[1]: https://sphinx-doc.org
[2]: https://readthedocs.org
[3]: https://docs.ixm.one/en/latest/contributing.html
