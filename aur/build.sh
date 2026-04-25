#!/bin/bash

set -e

# TODO: come gestisco le dipendenze dei pacchetti aur?
# TODO: devo scrivere una funzione bash ricorsiva che legge un PKGBUILD, ne estrae le dipendenze (non solo quelle di build),
# TODO: le scarica qui, le builda e poi le passa (con -I file) al comando del PKGBUILD finale
# NOTE: raramente i pacchetti AUR hanno come dipendenze altr pacchetti AUR

# if [[ ! -d .chroot ]]; then
#   arch-nspawn .chroot/root pacman -Syu
# fi

for i in ./packages/*; do
  if grep "^$(basename $i)" to-build.txt; then
    echo "The package $i is out of date."
    if [ -d "$i/.git" ]; then
      echo -e "\e[32m[INFO]\e[0m Building $i"
      ( 
        cd "$i" || exit
        makepkg --printsrcinfo > .SRCINFO
        makepkg -crfsi
        # makechrootpkg --printsrcinfo > .SRCINFO
        # makechrootpkg -c -u -n -r ../../.chroot
      )
    else
      echo -e "\e[33m[WARNING]\e[0m Skipping $i (not a git repo)"
    fi
  fi
done
