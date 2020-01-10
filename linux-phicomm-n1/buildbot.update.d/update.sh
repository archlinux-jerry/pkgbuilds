#!/bin/bash
# buildbot update hook for kernel packages
set -e -o pipefail

assertPkgname() {
    if [[ "$(basename $(pwd))" != "$PKGNAME" ]]; then
        echo "Please run this script inside the $PKGNAME dir."
        exit 1
    fi
}

## This section does essential preparations
PKGNAME='linux-phicomm-n1' && assertPkgname
PKGBUILD='PKGBUILD'
git pull --ff-only
git checkout $PKGBUILD
pkgver=$(source $PKGBUILD; echo $pkgver)

# This section does actual jobs
newPkgVer() {
    # do not print anything to stdout other than new pkgver here

    #URL='https://cdn.kernel.org/pub/linux/kernel/v5.x/'
    #URL='https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git'
    VER=$pkgver
    #CHANGELOG_FORMAT="patch-"
    CHANGELOG_FORMAT="Linux "

    PATCH=${VER##*.}
    MAJOR_MINOR=${VER%.*}

    URL="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/?h=linux-${MAJOR_MINOR}.y"

    if ! grep -Eq '[0-9].[0-9]' <<< "$MAJOR_MINOR"; then echo "Bad MAJOR_MINOR: ${MAJOR_MINOR}" >&2; return 1; fi
    if ! grep -Eq '[0-9]' <<< "$PATCH"; then echo "Bad PATCH: ${PATCH}" >&2; return 1; fi

    html="$(curl -s ${URL})"

    next=$PATCH
    #[ $next == 0 ] && next=1
    ((next=next+1))
    while true; do
        if grep -Fq "${CHANGELOG_FORMAT}${MAJOR_MINOR}.${next}" <<< "$html"; then
            ((next=next+1))
        else
            ((next=next-1))
            break
        fi
    done
    if (("$PATCH" < "$next")); then
        echo "New patch level found: ${next}" >&2
        echo -n "${MAJOR_MINOR}.${next}"
        return 0
    else
        echo "No new patch level found: ${next}" >&2
        return 0
    fi
}

newpkgver=$(newPkgVer)
[ -z "$newpkgver" ] && exit 0
sed -i "s/^pkgver=.*\$/pkgver=${newpkgver}/g" $PKGBUILD
sed -i "s/^pkgrel=.*\$/pkgrel=1/g" $PKGBUILD
pkgver=$(source $PKGBUILD; echo $pkgver)
pkgrel=$(source $PKGBUILD; echo $pkgrel)
[ "$pkgver" != "$newpkgver" ] && echo "unexpected pkgver: ${pkgver}" >&2 && exit 1
[ "$pkgrel" != '1' ] && echo "unexpected pkgrel: ${pkgrel}" >&2 && exit 1
updpkgsums
git add $PKGBUILD
git commit -m "autoupdate: ${PKGNAME} to ${pkgver}"
git push
