#!/bin/sh -
#
# Creates a temporary build directory in /tmp and builds all packages in there
# based on the provided package list file. Also supports signing the packages
# and creates an appropriate repository database. The articats are finally
# stored in one build directory.
#
# Supported environment variables:
#
#   PACKAGE_AUTHOR:      Defines who is the packager, set to 'John Doe
#                        <john@example.com>' if not defined
#
#   PACKAGE_BASE_URL:    Base URL where the source repositories are located,
#                        set to 'https://aur.archlinux.org' if not defined
#
#   PACKAGE_CONFIG:      File containing the package list to build, set to
#                        'packages.lst' if not defined
#
#   PACKAGE_DESTINATION: Defines where to store the built packages, set to
#                        '$HOME/build' if not defined
#
#   PACKAGE_GPG_ID:      GPG ID of the private key to use for signing the
#                        packages, if not set the packages will not be signed
#
# USAGE: ./build.sh

set -eo pipefail

readonly DEPENDENCIES="id git makepkg pacman-key repo-add"

readonly PKG_BASE_URL="${PACKAGE_BASE_URL:-https://aur.archlinux.org}"
readonly PKG_CFG="${PACKAGE_CONFIG:-packages.lst}"

# Specific options for makepkg and repo-add, see their respective man pages
export GPGKEY="${PACKAGE_GPG_ID:-}"
export PKGDEST="${PACKAGE_DESTINATION:-${HOME}/build}"
export PACKAGER="${PACKAGE_AUTHOR:-John Doe <john@example.com>}"

# Required by makepkg to ensure signature files are stored along the packages
export SRCPKGDEST="${PKGDEST}"

# Check if all dependencies are available
for DEPENDENCY in ${DEPENDENCIES}; do
  if [[ ! $(type "${DEPENDENCY}" 2> /dev/null) ]]; then
    echo "Dependency '${DEPENDENCY}' not found in PATH, exiting..."
    exit 1
  fi
done

# Check if we are executed as root which does not work with makepkg
if [[ "$(id -u)" -eq 0 ]]; then
  echo "Script must not be executed as root, exiting..."
  exit 1
fi

echo $HOME
# Check if package config file exists
if [[ ! -f "${PKG_CFG}" ]]; then
  echo "No file named '${PKG_CFG}' found at script location, exiting..."
  exit 1
fi

# Create temporary build directory
readonly TMP_BUILD_DIR=$(mktemp --directory --suffix=pkgbuild)

# Create package destination directory if required
echo "All packages will be placed in '${PKGDEST}'"
if [[ ! -d "${PKGDEST}" ]]; then
  mkdir "${PKGDEST}"
fi

# Build all packages
while read -r PACKAGE; do
  # Skip all lines starting with a hashtag
  [[ "${PACKAGE}" =~ ^#.*$ ]] && continue

  echo "Starting build process for package '${PACKAGE}'"

  # Clone source repository
  git clone "${PKG_BASE_URL}/${PACKAGE}" "${TMP_BUILD_DIR}/${PACKAGE}"

  # Build package
  cd "${TMP_BUILD_DIR}/${PACKAGE}"
  if [[ ! -z "${GPGKEY}" ]]; then
    echo "Package will be built and signed with the GPG key '${GPGKEY}'"
    makepkg --noconfirm --syncdeps --install --sign
  else
    echo "Package will be built without signing it"
    makepkg --noconfirm --syncdeps --install
  fi
done < "${PKG_CFG}"

echo "Finished building all packages, check the '${PKGDEST}' directory"

if [[ ! -z "${GPGKEY}" ]]; then
  echo "Creating package repository database and sign it with the GPG key '${GPGKEY}'"
  repo-add --sign "${PKGDEST}/karras.db.tar.xz" ${PKGDEST}/*.zst
else
  echo "Creating package repository database without signing it"
  repo-add "${PKGDEST}/karras.db.tar.xz" ${PKGDEST}/*.zst
fi

echo "Finished generating repository database, check the '${PKGDEST}' directory"
