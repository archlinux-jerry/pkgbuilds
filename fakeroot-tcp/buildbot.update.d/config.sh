#!/bin/bash
# buildbot update hook for aur packages

PKGNAME='fakeroot-tcp'
PKGBUILD='PKGBUILD'

# prepare upstream source
prepare() {
    sed -i 's/^\([ \t]*\)po4a/\1\/usr\/bin\/vendor_perl\/po4a/g' PKGBUILD
}

# which files to include, overrides exclude_files below
INCLUDE_FILES=(
#    'PKGBUILD'
#    '.gitignore'
)

# which files to exclude, use '*' and '.*' to exclude all
EXCLUDE_FILES=(
    '.SRCINFO'
    '.git'
)
