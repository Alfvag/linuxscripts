#! /bin/bash

# This script installs packages using dnf and some flatpaks

PACKAGES=(
    # Base packages
    "flatpak"
    "htop"
    "curl"
    "wget"
    "kitty"
    "vscode"
)

FLATPAKS=(
    "org.mozilla.firefox"
    "com.spotify.Client"
    "dev.deedles.Trayscale"
    "org.zotero.Zotero"
)

#Uninstall firefox-esr
if dnf list installed "firefox-esr" &>/dev/null; then
    echo "Uninstalling firefox-esr..."
    dnf remove -y "firefox-esr"
else
    echo "firefox-esr is not installed."
fi

# Update the system
echo "Updating the system..."
dnf clean all
dnf update -y
dnf upgrade -y
dnf autoremove -y
echo "System updated successfully."

# Function to install packages using dnf
for PACKAGE in "${PACKAGES[@]}"; do
    if ! dnf list installed "$PACKAGE" &>/dev/null; then
        echo "Installing $PACKAGE..."
        dnf install -y "$PACKAGE"
    else
        echo "$PACKAGE is already installed."
    fi
done

#Add the flathub repo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Function to install flatpaks
for FLATPAK in "${FLATPAKS[@]}"; do
    if ! flatpak list --app | grep -q "$FLATPAK"; then
        echo "Installing $FLATPAK..."
        flatpak install -y flathub "$FLATPAK"
    else
        echo "$FLATPAK is already installed."
    fi
done