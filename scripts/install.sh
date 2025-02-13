# -----------------------------------------------------
# Repos Folder
# -----------------------------------------------------
repos_folder="$HOME/.repos"
# -----------------------------------------------------
# Emacs Config Folder
# -----------------------------------------------------
emacs_folder="$HOME/.emacs.d"

# Install emacs
# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/

EOF
echo "Installation of Emacs: "


# Install required packages
_installPackages() {
    toInstall=()
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi
        toInstall+=("${pkg}")
    done
    if [[ "${toInstall[@]}" == "" ]]; then
        # echo "All pacman packages are already installed.";
        return
    fi
    printf "Package not installed:\n%s\n" "${toInstall[@]}"
    sudo pacman --noconfirm -S "${toInstall[@]}"
}

# Check if package is installed
_isInstalled() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0 #'0' means 'true' in Bash
        return #true
    fi
    echo 1 #'1' means 'false' in Bash
    return #false
}

# Check if command exists
_checkCommandExists() {
    package="$1"
    if ! command -v $package >/dev/null; then
        return 1
    else
        return 0
    fi
}

# Install required packages
_installPackages() {
    toInstall=()
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi
        toInstall+=("${pkg}")
    done
    if [[ "${toInstall[@]}" == "" ]]; then
        # echo "All pacman packages are already installed.";
        return
    fi
    printf "Package not installed:\n%s\n" "${toInstall[@]}"
    sudo pacman --noconfirm -S "${toInstall[@]}"
}

# install yay if needed
_installYay() {
    _installPackages "base-devel"
    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay.git $download_folder/yay
    cd $download_folder/yay
    makepkg -si
    cd $temp_path
    echo ":: yay has been installed successfully."
}

# Required packages for the installer
packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
    "git"
    "gcc"
    "jansson"
    "gnutls"
    "tree-sitter"
    "libgccjit"
    "make"
    "cmake"
)

# Synchronizing package databases
sudo pacman -Sy
echo

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackages "${packages[@]}"

# Install yay if needed
if _checkCommandExists "yay"; then
    echo ":: yay is already installed"
else
    echo ":: The installer requires yay. yay will be installed now"
    _installYay
fi
echo

# Create repos folder if not exists
if [ ! -d $repos_folder ]; then
    mkdir -p $repos_folder
    echo ":: $repos_folder folder created"
fi

cd $repos_folder

# Clone emacs
git clone -b master git://git.sv.gnu.org/emacs.git

# Into folder emacs
cd emacs

# Check emacs version
git checkout emacs-29

./autogen.sh

# Configure Emacs
./configure --prefix=/usr/local --with-cairo --with-harfbuzz --with-libsystemd --with-modules --with-tree-sitter --with-x-toolkit=gtk3 --with-native-compilation=aot CFLAGS='-O2 -march=native -fomit-frame-pointer'


echo "Emacs Installation"
echo -e "${NONE}"
while true; do
    read -p "DO YOU WANT TO USE MULTIPLE THREADS? (Yy/Nn): " yn
    case $yn in
        [Yy]*)
            echo ":: Simple Installation"
            make bootstrap
            ;;
        [Nn]*)
            echo ":: Installation with 4 threads"
            make -j4 bootstrap
            ;;
        *)
            echo ":: Please answer yes or no."
            ;;
    esac
done
sudo make install

cd ..

# Create emacs.d folder
if [ ! -d $emacs_folder ]; then
    mkdir -p $emacs_folder
    echo ":: $emacs_folder folder created"
fi

cp emacs-config/src/*.el $emacs_folder/

echo ":: Emacs installation complete."
