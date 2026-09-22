#!/data/data/com.termux/files/usr/bin/bash
set -e

APP_DIR="$HOME/.yoma-termux-theme"
BACKUP_DIR="$APP_DIR/backup"

if [ -f "$BACKUP_DIR/.bashrc" ]; then
    cp "$BACKUP_DIR/.bashrc" "$HOME/.bashrc"
else
    sed -i '/# >>> YOMA TERMUX THEME >>>/,/# <<< YOMA TERMUX THEME <<</d' "$HOME/.bashrc" 2>/dev/null || true
fi

if [ -f "$BACKUP_DIR/.zshrc" ]; then
    cp "$BACKUP_DIR/.zshrc" "$HOME/.zshrc"
fi

# Remove files created by this tool only when they exist.
rm -f "$HOME/.termux/colors.properties" "$HOME/.termux/termux.properties"
rm -rf "$APP_DIR"

echo "✓ YOMA Termux Theme removed."
echo "Restart Termux to finish applying the restored shell configuration."
