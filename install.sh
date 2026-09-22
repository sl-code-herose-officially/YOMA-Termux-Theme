#!/data/data/com.termux/files/usr/bin/bash
set -e

APP_DIR="$HOME/.yoma-termux-theme"
BACKUP_DIR="$APP_DIR/backup"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$APP_DIR" "$BACKUP_DIR"

echo "╔══════════════════════════════════════╗"
echo "║        YOMA TERMUX THEME             ║"
echo "╚══════════════════════════════════════╝"
echo

# Backup existing shell config before modifying it.
for f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.termux/colors.properties" "$HOME/.termux/termux.properties"; do
    if [ -f "$f" ]; then
        base="$(basename "$f")"
        cp -n "$f" "$BACKUP_DIR/$base" 2>/dev/null || true
    fi
done

cp "$SCRIPT_DIR/theme.sh" "$APP_DIR/theme.sh"
cp "$SCRIPT_DIR/uninstall.sh" "$APP_DIR/uninstall.sh"
cp -r "$SCRIPT_DIR/themes" "$APP_DIR/themes"
chmod +x "$APP_DIR/theme.sh" "$APP_DIR/uninstall.sh"

echo "Installation complete."
echo
bash "$APP_DIR/theme.sh"
