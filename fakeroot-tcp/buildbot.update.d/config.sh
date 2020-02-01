#!/bin/bash
# buildbot update hook for aur packages

PKGNAME='fakeroot-tcp'
PKGBUILD='PKGBUILD'

# prepare upstream source
prepare() {
    true
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
