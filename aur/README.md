## AUR

My take on managing AUR packages in a simple and predictable way.

## Context

These scripts assume that there is a folder called `~/.aur/packages` in your system, where all the AUR package sources are located.

From there, the scripts will detect changes and build the packages.

> [!NOTE]
> Use `pacman -Qm` to list packages not present in the official repositories.

## Usage

Whenever you want to install a new AUR package, go to the [AUR Packages List](https://aur.archlinux.org/packages),
search for a package, copy its html download url, cd into `~/.aur/packages` and clone it with git
(es. `git clone https://aur.archlinux.org/airshipper.git`).

Then cd into `~/.aur` and run `./update.sh` followed by `./build.sh`.

> [!NOTE]
> Following the official Arch Linux guidelines, all AUR packages are updated and built together
> It's recommended to update the AUR packages only after updating the official Arch Linux packages.
