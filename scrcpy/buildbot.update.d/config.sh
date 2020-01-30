#!/bin/bash
# buildbot update hook for aur packages

PKGNAME='scrcpy'
PKGBUILD='PKGBUILD'

# prepare upstream source
prepare() {
    sed -i "s/^arch=.*$/arch=('aarch64')/g" PKGBUILD
    sed -i "/^[ \t]*-Db_lto=true.*$/d" PKGBUILD
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
