#!/bin/bash


# NOTE: This file is a demo of all the different functionalities
# NOTE: All functionalities will remain separated for now
# NOTE: this script will bundle the ./build.sh and ./update.sh

# TODO: list all packages in the repo ?
# TODO: list all installed AUR packages ?
# TODO: get info about given package ?
# TODO: get list of deps of given package ?
# TODO: get list of packages that require a given package ?
# TODO: downgrade given package ?
# TODO: bulk install from list of packages given a plain-text/csv file ?
# TODO: bulk remove from list of packages given a plain-text/csv file ?

# https://wiki.archlinux.org/title/DeveloperWiki:Building_in_a_clean_chroot#Setting_up_a_chroot

AUR_ROOT="$HOME/.aur"
PACKAGES_ROOT="$AUR_ROOT/packages"
CHROOT="$AUR_ROOT/.chroot"

# TODO: usare un array per elencare i pacchetti
# TODO: trovare le deps di ogni pacchetto e metterle prima di quel pacchetto nell'array
# TODO: far scorrere l'array si a update che a build
# TODO: usa file di testo chiamato to-build.txt
# NOTE: l'array e' la source of truth della lista pacchetti


###############
## Functions ##
###############

help() {
	cat << EOF
Usage: $(basename "$0") [options]

Description:
  A simple and minimal AUR helper that manages locally built AUR packages and handles them with a custom repository.
  
  Packages are built following the official method, by using an arch-nspawn container to install the necessary
  depdendencies and build the package.
  
  All dependencies for AUR packages are recursively downloaded.

Options:
  -h	Show this help message and exits
  -i	Install a given package
  -u	Removes a given package
  -U	Updates all packages present in $HOME/.aur/packages
  -b	Builds a given package
  -B Builds all packages present in $HOME/.aur/packages

Examples:
  $(basename "$0") -h
EOF
  exit 0
}

install() {
	echo -e "\e[32m[INFO]\e[0m Installing $1..."
	cd "$HOME/.aur/packages" || exit
	git clone "gttps://aur.archlinux.org/$1.git"
}

remove() {
	echo ""
}

update() {
	echo ""
}

build(){
	echo ""
}

build_all() {
	for i in ./packages/*; do
		if [ -d "$i/.git" ]; then
			echo "Building $i"
			(
				cd "$i" || exit
				makepkg --printsrcinfo > .SRCINFO
				makepkg -crfsi
				# makechrootpkg --printsrcinfo > .SRCINFO
				# makechrootpkg -c -u -n -r ../../.chroot
			)
		else
			echo "Skipping $i (not a git repo)"
		fi
	done
}

main() {
	for i in "$@"; do
		echo ""
	done
}


#########
## Old ##
#########

build_pkg() {
	arch-nspawn "$CHROOT"/root pacman -Syu
	cd pkgdir || exit
	updpkgsums PKGBUILD
	makechrootpkg --printsrcinfo > .SRCINFO
	makechrootpkg -c -u -n -r "$CHROOT"
}

install_pkg() {
	# TODO: move pkg bin to folder for all pkg bin files
	echo ""
}

remove_pkg() {
	# TODO: move pkg bin to folder for all pkg bin files
	echo ""
}

update_pkg() {
	# TODO: move pkg bin to folder for all pkg bin files
	echo ""
}

list_pkgs() {
	diff -w pkgs.txt pkgs_aur.txt
	diff -wy pkgs.txt pkgs_aur.txt
	diff -w -u --color=always pkgs.txt pkgs_aur.txt > temp.txt
	diff -a -u -N pkgs.txt pkgs_aur.txt > diff.patch
}

add_pkg() {
	PKGS=""
	for i in $PKGS; do
		cp "./packages/$i/$i.pkg.tar.zst" "./repo/"
		repo-add "./repo/aur.db.tar.zst" "./repo/$i.pkg.tar.zst"
	done
}

# Check if a pkg has 777 permissions
check_777() {
	# LIST=$(ls -l "/home/raffaele/.cache/paru/clone" | awk '{print $9}')
	LIST=$(find /home/raffaele/.cache/paru/clone -type d -maxdepth 1 | sed 's|/home/raffaele/.cache/paru/clone/||g')
	cd "/home/raffaele/.cache/paru/clone" || exit
	for i in $LIST; do
		cd "./$i" || exit
		grep "777" "./PKGBUILD" >> ~/output.txt
		echo "--------- $i ---------" >> ~/output.txt
		cd ..
	done
}

find_pkg_on_github() {
	paru -Qmi | grep URL > repos.txt
	sed -i 's/URL             : //g' repos.txt
	paru -Qmi | grep URL | grep "github.com" > repos_github.txt
	sed -i 's/URL             : //g' repos_github.txt
}

find_deps() {
	# TODO: get bash-array-compatible list of a given pkg's deps
	# TODO: list them from last to first and install them in that order
	LIST=""
	for i in $LIST; do
		touch ./deps-tree/"$i".txt
		# echo -e "\e[32m[INFO]\e[0m: The package $i has the following dependencies:" > ./deps-tree/"$i".txt
		pactree "$i" > ./deps-tree/"$i".txt
		echo -e "\e[32m[INFO]\e[0m: Parsed deps for package $i"
	done
}


##########
## Init ##
##########

# if [[ ! -d "$AUR_ROOT" ]]; then
#   mkdir -v "$AUR_ROOT"
# fi

# if [[ ! -d "$AUR_ROOT"/.chroot/ ]]; then
# 	mkdir -v "$AUR_ROOT"/.chroot
# 	export CHROOT="$AUR_ROOT"/.chroot
# 	mkarchroot "$CHROOT"/root base-devel
# fi

# if [[ ! -d "$AUR_ROOT"/repository ]]; then
# 	mkdir -v "$AUR_ROOT"/repository
# fi

# Parsing flags and arguments
testt() {
	echo "$1"
}
while [[ $# -gt 0 ]]; do
	case $1 in
		# Help
		-h) help ;;
		-t) testt "$2" && shift 2 ;;
	  # Install
	  -i) install "$2" && shift 2 ;;
	  -r) remove "$2" && shift 2 ;;
	  # Update
	  -U) update && shift ;;
	  # Build
	  -b) build "$2" && shift 2 ;;
	  -B) build_all && shift ;;
	  # Default
	  *) echo -e "\e[31m[ERROR]\e[0m This option doesn't exist" && shift ;;
	esac
done
