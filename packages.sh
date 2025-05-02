#!/bin/bash

# This script installs packages using dnf and some flatpaks

# Exit on error, undefined variables, and propagate pipeline errors
set -euo pipefail

# Check if script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root (use sudo)."
  exit 1
fi

PACKAGES=(
    #Packages
    "flatpak"
    "htop"
    "curl"
    "wget"
    "fastfetch"
    #Hyprland deps
    "kitty"
    "pipewire"
    "wireplumber"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk"
    "qt5-qtwayland"
    "qt6-qtwayland"
    "fira-code-fonts"
    "fontawesome-6-free-fonts"
    "mozilla-fira-sans-fonts"
    "gtk4"
    #Hyprland packages
    "hyprland"
    "waybar"
    "hyprpaper"
    "hyprlock"
    "mate-polkit"
    "gdm"
    "nautilus"
    "wlogout"
    "fuzzel"
    "copyq"
)

FLATPAKS=(
    "org.mozilla.firefox"
    "com.spotify.Client"
    "dev.deedles.Trayscale"
    "org.zotero.Zotero"
)

# Update the system
echo "=== Updating the system ==="
echo "Removing Firefox package..."
dnf -y remove firefox || echo "Firefox not installed or couldn't be removed"

echo "Cleaning DNF cache..."
dnf clean all

echo "Upgrading packages..."
dnf -y upgrade

echo "Removing unnecessary packages..."
dnf -y autoremove

echo "=== System updated successfully ==="

# Install packages using dnf
echo "=== Installing DNF packages ==="
for PACKAGE in "${PACKAGES[@]}"; do
    echo "Installing $PACKAGE..."
    dnf -y install "$PACKAGE" || echo "Failed to install $PACKAGE, continuing anyway..."
done
echo "=== DNF packages installation completed ==="

# Make sure flatpak is installed before continuing
if ! command -v flatpak &>/dev/null; then
    echo "Flatpak not found after installation attempt. Cannot continue with flatpak installations."
    exit 1
fi

# Add the flathub repo
echo "=== Adding Flathub repository ==="
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install flatpaks
echo "=== Installing Flatpak applications ==="
for FLATPAK in "${FLATPAKS[@]}"; do
    echo "Installing $FLATPAK..."
    flatpak install -y flathub "$FLATPAK" || echo "Failed to install $FLATPAK, continuing anyway..."
done
echo "=== Flatpak installations completed ==="

echo "All installations completed!"