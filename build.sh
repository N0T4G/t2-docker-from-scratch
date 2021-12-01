# Copyright (C) 2021 NoTag
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version 3 (AGPLv3).
#
# You should have received a copy of the GNU General Public License
# along. If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.

#!/bin/bash
set -xe

# Define useful variables
VERSION="21.7"

ARCH="x86-64"
CC="gcc"
LIBC="glibc"
VARIANT="minimal-desktop"

ISO="t2-${VERSION}-${ARCH}-${VARIANT}-${CC}-${LIBC}.iso"
URL="https://dl.t2sde.org/binary/2021/${ISO}"

DOCKER_ROOT="$HOME/TMP/docker"
IMG_DEST="$HOME/TMP"
IMG="t2-$VERSION-$ARCH-container.tar.gz"

# Download latest T2 iso
curl --progress-bar -C - -LO "${URL}"

# Verify iso checksum
sha224sum --ignore-missing -c ./checksums.sha224

# Setup our build environment
mkdir -pv "${DOCKER_ROOT}"

# Mount the download iso
mount -o loop "${ISO}" /mnt

# Ignore useless stuff and graphical packages (current mirror only ship xorgs iso)
pkgslist="$(ls /mnt/*/pkgs | grep -v '^x.*.zst\|wayland\|^libx\|gdk\|gtk\|harfbuzz\|wm\|^linux-5\|^linux-firmware\|pixman\|glew\|at-spi\|firefox\|cairo\|blackbox\|cups\|rxvt\|packages.db\|mesa\|llvm\|clang\|rust\|libinput\|libice\|libgphoto\|libdrm\|libburn\|ghostscript\|font\|ffpmeg\|grub\|pulseaudio\|alsa\|dbus\|glu\|libevdev\|libevent')"

# Add xz as we stripped to much from the abouve list
pkgslist="${pkgslist} xz*.zst"

# Install the T2 system
for x in $pkgslist 
do
	tar -xf /mnt/*/pkgs/$x -C "${DOCKER_ROOT}/"
done

# We are a docker image
#echo "T2 SDE $VERSION Container Image" > "${DOCKER_ROOT}/etc/SDE-VERSION"

# Unmount the iso
umount /mnt

# Package the installed system into a tarball
tar -C "${DOCKER_ROOT}/" --numeric-owner -czf "${IMG_DEST}/${IMG}" .

# Generate the Dockerfile
cat <<EOF > "${IMG_DEST}/Dockerfile"
FROM scratch
ADD  ${IMG} /
CMD ["/bin/bash"]
EOF

# Actually build the docker image
cd "${IMG_DEST}" && docker build -t t2sde .

# Optionally jump into it immediately
# docker run -i -t t2sde

echo 'Done!'
