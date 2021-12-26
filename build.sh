#!/bin/sh
#
# Creates a directory in /tmp, clones the AUR repository into it and finally
# builds the package. Definitely not gold, lots of room for improvement.
#
# ./build.sh GIT_URL [COMMIT_HASH]

set -eo pipefail

# Required tools
DEPENDENCIES="mktemp git"

# Test if dependencies are available
for DEPENDENCY in ${DEPENDENCIES}; do
  if [[ ! $(type "${DEPENDENCY}" 2> /dev/null) ]]; then
    echo "Dependency '${DEPENDENCY}' not found in PATH, exiting..."
    exit 1
  fi
done

if [[ -z "${1}" ]]; then
  echo "No AUR git URL provided as the first parameter, exiting..."
  exit 1
fi

# Create temporary build directory
BUILD_DIR=$(mktemp --directory --suffix=pkgbuild)

# Clone (AUR) repository
git clone "${1}" "${BUILD_DIR}"

# Switch to build directory
cd "${BUILD_DIR}"

# Optionally checkout specific commit (i.e. AUR version pinning)
if [[ ! -z "${2}" ]]; then
  echo "Checking out commit '${2}'"
  git checkout --quiet "${2}"
fi

# Build package
makepkg --noconfirm --syncdeps
