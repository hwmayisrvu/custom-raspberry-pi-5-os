#!/bin/bash -e

install -v -d					"${ROOTFS_DIR}/etc/wpa_supplicant"
install -v -m 600 files/wpa_supplicant.conf	"${ROOTFS_DIR}/etc/wpa_supplicant/"

if [ -v WPA_COUNTRY ]; then
	on_chroot <<- EOF
		SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_wifi_country "${WPA_COUNTRY}"
	EOF

    if [ -v WPA_ESSID ] && [ -v WPA_PASSWORD ]; then
        on_chroot <<- EOF
            SUDO_USER="${FIRST_USER_NAME}" /usr/lib/raspberrypi-sys-mods/imager_custom set_wlan "${WPA_ESSID}" "${WPA_PASSWORD}" "${WPA_COUNTRY}"
EOF
    fi
fi

# Disable wifi on 5GHz models if WPA_COUNTRY is not set
mkdir -p "${ROOTFS_DIR}/var/lib/systemd/rfkill/"
if [ -n "$WPA_COUNTRY" ]; then
    echo 0 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-3f300000.mmcnr:wlan"
    echo 0 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-fe300000.mmcnr:wlan"
    echo 0 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-1001100000.mmc:wlan"
else
    echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-3f300000.mmcnr:wlan"
    echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-fe300000.mmcnr:wlan"
    echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-1001100000.mmc:wlan"
fi
