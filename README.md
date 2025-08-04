# AUR Package Builds

Arch Linux AUR package builds, published via GitHub Releases.

[![Build & Publish](https://github.com/karras/aur-package-builds/actions/workflows/build-publish.yml/badge.svg)](https://github.com/karras/aur-package-builds/actions/workflows/build-publish.yml)

## Why

Providing a custom Arch repository using GitHub Releases (or Pages) can reduce
the need for additional backend services.

## Packages

Among others the following packages are provided (see
[packages.lst](./packages.lst)):

* [oidc-agent](https://aur.archlinux.org/packages/oidc-agent)
* [wayfire](https://aur.archlinux.org/packages/wayfire)
* [wayland-logout](https://aur.archlinux.org/packages/wayland-logout)
* [wazuh-agent](https://aur.archlinux.org/packages/wazuh-agent)
* [wf-config](https://aur.archlinux.org/packages/wf-config)
* [wlay-git](https://aur.archlinux.org/packages/wlay-git)

### Deprecated

The packages below were at some point built and provided by this project but
then deprecated, either because they are no longer needed, the upstream project
is unmaintained or official builds are being provided:

* [google-chrome](https://aur.archlinux.org/packages/google-chrome)
* [greetd](https://archlinux.org/packages/extra/x86_64/greetd)
* [greetd-gtkgreet](https://archlinux.org/packages/extra/x86_64/greetd-gtkgreet/)
* [wayfire-git](https://aur.archlinux.org/packages/wayfire-git)

## Repositories

The built packages are provided as pacman repositories in the form of [GitHub
releases](https://github.com/karras/aur-package-builds/releases). This makes it
possible to conveniently install and update the packages directly without
downloading them first.

All packages and the repository databases are signed thus the [GPG
key](./builder_public_key.asc) should be imported and trusted first (see
instructions below).

There are two types of repositories to choose from:

* **[latest](https://github.com/karras/aur-package-builds/releases/tag/latest)**

    Provides weekly updates of the most recent version of all packages

* **[stable](https://github.com/karras/aur-package-builds/releases)**

    All repositories (i.e. releases) with a semantic version are frozen and
    considered stable, they will not be updated automatically. Instead new
    releases will be created to update the packages.

## Usage

Follow the below steps to install any of the available packages:

* Import and trust the [package signing key](./builder_public_key.asc):
  ```sh
  pacman-key --add builder_public_key.asc
  pacman-key --lsign-key 25267573FD638312C5EBE4C40C758F9503EDE7AF
  ```

* Add the repository to `/etc/pacman.conf` (replace `$RELEASE` in the URL with
  the desired version or choose `latest`):
  ```ini
  # Example latest repository
  [karras]
  Server = https://github.com/karras/aur-package-builds/releases/download/latest

  # Example frozen repository
  [karras]
  Server = https://github.com/karras/aur-package-builds/releases/download/$RELEASE
  ```

* Refresh the local repository databases:
  ```sh
  pacman -Sy
  ```

* Install the required packages (e.g. `wayfire-git`):
  ```sh
  pacman -S wayfire-git
  ```

## License

See [LICENSE](./LICENSE)
