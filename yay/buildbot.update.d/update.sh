#!/bin/bash
# buildbot update hook for aur packages
set -e -o pipefail

assertPkgname() {
    if [[ "$(basename $(pwd))" != "$PKGNAME" ]]; then
        echo "Please run this script inside the $PKGNAME dir."
        exit 1
    fi
}

## This section does essential preparations
PKGNAME='yay' && assertPkgname
PKGBUILD='PKGBUILD'
UPDATE_DIR='buildbot.update.d'
git pull --ff-only
git checkout $PKGBUILD
VER=$(source $PKGBUILD; printf "%s-%s" "$pkgver" "$pkgrel")

# apply patches to the upstream aur package
PATCHES=(
)

# prepare upstream source
prepare() {
    # sed -i "s/^arch=.*$/arch=('aarch64')/g" PKGBUILD
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

# This section does actual jobs
newPkgVer() {
    # do not print anything to stdout other than new pkgver here

    ver=$(curl -s "https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=${PKGNAME}"| \
          python3 -c 'import json; j=json.loads(input()); print(j.get("results", [dict()])[0].get("Version", 0))')
    if [[ "$ver" == "$VER" ]]; then
        echo "${PKGNAME} is up to date with aur." >&2
    else
        echo "${PKGNAME} has new ver form aur: ${ver}" >&2
        echo "$ver"
    fi
}

newpkgver=$(newPkgVer)
[ -z "$newpkgver" ] && exit 0

incfiles=''
for f in "${INCLUDE_FILES[@]}"; do
    incfiles="$incfiles"$'\n'"$f"
done

excfiles='{'
for f in "${EXCLUDE_FILES[@]}"; do
    excfiles="${excfiles}${f},"
done
excfiles="${excfiles}}"
[[ "$excfiles" == '{}' ]] && excfiles=''

pushd "$UPDATE_DIR" >/dev/null
rm -rf "$PKGNAME"
git clone --depth 1 "https://aur.archlinux.org/${PKGNAME}.git" "$PKGNAME"

cd "$PKGNAME" && prepare
for patch in "${PATCHES[@]}"; do
    git apply "../${patch}"
done

add_files=$(eval ls -1 --almost-all --ignore=${excfiles})
add_files="${add_files}"$'\n'"${incfiles}"

while read f; do
    [[ -z "$f" ]] && continue
    cp -av "$f" ../../
    (cd ../../ && git add "$f")
done <<< "$add_files"

cd ..
rm -rf "$PKGNAME"
popd >/dev/null

git commit -m "autoupdate: ${PKGNAME} to ${newpkgver} from aur"
git push
