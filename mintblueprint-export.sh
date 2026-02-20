#!/bin/bash

# MintBlueprint
# System environment export tool
# Version: 1.0.0
# License: MIT

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$PROJECT_DIR/output"
REPORT="$OUTPUT_DIR/system-report.txt"
INSTALLER="$OUTPUT_DIR/mintblueprint-deploy.sh"

mkdir -p "$OUTPUT_DIR"

echo "MintBlueprint v1.0.0"
echo "Exporting system blueprint..."
echo ""

### Dependency Check
command -v apt >/dev/null 2>&1 || { echo "APT not found. Exiting."; exit 1; }

### Data Collection
APT_MANUAL=$(apt-mark showmanual)
FLATPAKS=$(flatpak list --app --columns=application 2>/dev/null || true)
SNAPS=$(snap list 2>/dev/null | awk 'NR>1 {print $1}' || true)

GTK_THEME=$(gsettings get org.cinnamon.desktop.interface gtk-theme 2>/dev/null || echo "''")
ICON_THEME=$(gsettings get org.cinnamon.desktop.interface icon-theme 2>/dev/null || echo "''")
CURSOR_THEME=$(gsettings get org.cinnamon.desktop.interface cursor-theme 2>/dev/null || echo "''")
CINNAMON_THEME=$(gsettings get org.cinnamon.theme name 2>/dev/null || echo "''")

### Save Report
{
echo "=== MintBlueprint System Report ==="
echo ""
echo "=== APT Manual Packages ==="
echo "$APT_MANUAL"
echo ""
echo "=== Flatpak Applications ==="
echo "$FLATPAKS"
echo ""
echo "=== Snap Packages ==="
echo "$SNAPS"
echo ""
echo "=== Interface Themes ==="
echo "GTK: $GTK_THEME"
echo "Icons: $ICON_THEME"
echo "Cursor: $CURSOR_THEME"
echo "Cinnamon: $CINNAMON_THEME"
} > "$REPORT"

echo "System report saved to:"
echo "$REPORT"
echo ""

### Interactive Selection
echo "Select components to include in deployment:"
echo "1) APT packages"
echo "2) Flatpaks"
echo "3) Snaps"
echo "4) Interface themes"
echo "5) Everything"
echo ""

read -p "Enter numbers separated by spaces: " CHOICE

### Generate Installer
cat <<EOF > "$INSTALLER"
#!/bin/bash
# MintBlueprint Deployment Script
# Generated automatically

set -e

echo "Updating system..."
sudo apt update

EOF

for OPTION in $CHOICE; do
    case $OPTION in
        1)
            echo "sudo apt install -y $APT_MANUAL" >> "$INSTALLER"
        ;;
        2)
            for pkg in $FLATPAKS; do
                echo "flatpak install -y flathub $pkg" >> "$INSTALLER"
            done
        ;;
        3)
            for pkg in $SNAPS; do
                echo "sudo snap install $pkg" >> "$INSTALLER"
            done
        ;;
        4)
            echo "gsettings set org.cinnamon.desktop.interface gtk-theme $GTK_THEME" >> "$INSTALLER"
            echo "gsettings set org.cinnamon.desktop.interface icon-theme $ICON_THEME" >> "$INSTALLER"
            echo "gsettings set org.cinnamon.desktop.interface cursor-theme $CURSOR_THEME" >> "$INSTALLER"
            echo "gsettings set org.cinnamon.theme name $CINNAMON_THEME" >> "$INSTALLER"
        ;;
        5)
            echo "sudo apt install -y $APT_MANUAL" >> "$INSTALLER"
            for pkg in $FLATPAKS; do
                echo "flatpak install -y flathub $pkg" >> "$INSTALLER"
            done
            for pkg in $SNAPS; do
                echo "sudo snap install $pkg" >> "$INSTALLER"
            done
            echo "gsettings set org.cinnamon.desktop.interface gtk-theme $GTK_THEME" >> "$INSTALLER"
            echo "gsettings set org.cinnamon.desktop.interface icon-theme $ICON_THEME" >> "$INSTALLER"
            echo "gsettings set org.cinnamon.desktop.interface cursor-theme $CURSOR_THEME" >> "$INSTALLER"
            echo "gsettings set org.cinnamon.theme name $CINNAMON_THEME" >> "$INSTALLER"
        ;;
    esac
done

chmod +x "$INSTALLER"

echo ""
echo "Deployment script generated:"
echo "$INSTALLER"
