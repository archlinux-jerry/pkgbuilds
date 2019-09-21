#!/bin/bash
# buildbot update hook
set -e -o pipefail

## This section does essential preparations
PKGBUILD='PKGBUILD'
git pull --ff-only
git checkout $PKGBUILD
pkgver=$(source $PKGBUILD; echo $pkgver)

# This section does actual jobs
newPkgVer() {
    # do not print anything to stdout other than new pkgver here

    URL='https://cdn.kernel.org/pub/linux/kernel/v5.x/'
    VER=$pkgver
    CHANGELOG_FORMAT="ChangeLog-"

    PATCH=${VER##*.}
    MAJOR_MINOR=${VER%.*}

    if ! grep -Eq '[0-9].[0-9]' <<< "$MAJOR_MINOR"; then echo "Bad MAJOR_MINOR: ${MAJOR_MINOR}" >&2; return 1; fi
    if ! grep -Eq '[0-9]' <<< "$PATCH"; then echo "Bad PATCH: ${PATCH}" >&2; return 1; fi

    html="$(curl -s ${URL})"

    next=$PATCH
    while true; do
        if grep -Fq "${MAJOR_MINOR}.${next}" <<< "$html"; then
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
git commit -m "autoupdate: linux-phicomm-n1 to ${pkgver}"
git push
