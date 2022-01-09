# AUR Package Builds

Arch Linux AUR package builds, published via GitHub Releases.

[![Build & Publish](https://github.com/karras/aur-package-builds/actions/workflows/build-publish.yml/badge.svg)](https://github.com/karras/aur-package-builds/actions/workflows/build-publish.yml)

## Packages

The following packages are covered (see [package.lst](./package.lst)):

* [greetd](https://aur.archlinux.org/packages/greetd/)
* [greetd-gtkgreet](https://aur.archlinux.org/packages/greetd-gtkgreet/)
* [wayfire](https://aur.archlinux.org/packages/wayfire/)
* [wf-config](https://aur.archlinux.org/packages/wf-config/)

## Usage

The actual package builds can be found in the latest
[Releases](https://github.com/karras/aur-package-builds/releases). All releases
also include the required repository database in order to install them directly
via pacman:

* Import and trust the [package signing key](./builder_public_key.asc):
  ```sh
  pacman-key --add builder_public_key.asc
  pacman-key --lsign-key 25267573FD638312C5EBE4C40C758F9503EDE7AF
  ```

* Add the repository to `/etc/pacman.conf` (replace `$RELEASE` in the URL with
  the desired version):
  ```ini
  [karras]
  Server = https://github.com/karras/aur-package-builds/releases/download/$RELEASE
  ```

* Refresh the local repository databases:
  ```sh
  pacman -Sy
  ```

* Install the required packages (e.g. `wayfire`):
  ```sh
  pacman -S wayfire
  ```

## License

See [LICENSE](./LICENSE)
