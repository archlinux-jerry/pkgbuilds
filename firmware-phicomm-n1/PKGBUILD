# Maintainer: Megumifox <i@megumifox.com>

buildarch=28

pkgname=firmware-phicomm-n1
pkgver=7
pkgrel=4
pkgdesc="Additional firmware for Phicomm N1"
arch=('any')
conflicts=('firmware-raspberrypi')
depends=('wireless-regdb' 'uboot-tools')
install=${pkgname}.install
url="https://github.com/RPi-Distro"
license=('custom')
_commitid_wl=00daf85ffa373ecce7836df7543c6ebe4cf43639
_commitid_bt=fff76cb15527c435ce99a9787848eacd6288282c
_ver="${pkgver}.${pkgrel}"
options=('!strip')
source=("brcmfmac43455-sdio_$_ver.clm_blob::https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/$_commitid_wl/brcm/brcmfmac43455-sdio.clm_blob"
        "brcmfmac43455-sdio_$_ver.txt::https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/$_commitid_wl/brcm/brcmfmac43455-sdio.txt"
        "brcmfmac43455-sdio_$_ver.bin::https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/$_commitid_wl/brcm/brcmfmac43455-sdio.bin"
        "BCM4345C0_$_ver.hcd::https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/$_commitid_bt/broadcom/BCM4345C0.hcd")
sha256sums=('8e2250518bc789e53109728c3c0a6124bc3801a75a1cb4966125753cf1f0252e'
            'bddee0eff55a11e939e000ad341c951c7ee67758fc26b838b0472792aed33639'
            '0f1817f50649df707f521dec9f2d5905e4c01939c8aabfa9a06b2ce0a36952ee'
            '9a4beeb7ca6d2ed8d6ecdf5ee7b0dac3c6042a702ac232eec812744129bfe640')

package() {
  install -d "${pkgdir}/usr/lib/firmware/updates/brcm"
  install -m 0644 brcmfmac43455-sdio_$_ver.clm_blob "${pkgdir}/usr/lib/firmware/updates/brcm/brcmfmac43455-sdio.clm_blob"
  install -m 0644 brcmfmac43455-sdio_$_ver.txt "${pkgdir}/usr/lib/firmware/updates/brcm/brcmfmac43455-sdio.txt"
  install -m 0644 brcmfmac43455-sdio_$_ver.bin "${pkgdir}/usr/lib/firmware/updates/brcm/brcmfmac43455-sdio.bin"
  install -m 0644 BCM4345C0_$_ver.hcd "${pkgdir}/usr/lib/firmware/updates/brcm/BCM4345C0.hcd"

  install -m 0644 brcmfmac43455-sdio_$_ver.txt "${pkgdir}/usr/lib/firmware/updates/brcm/brcmfmac43455-sdio.phicomm,n1.txt"
}
