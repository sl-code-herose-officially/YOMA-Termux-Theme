#!/data/data/com.termux/files/usr/bin/bash
set -e

APP_DIR="$HOME/.yoma-termux-theme"
THEME_DIR="$APP_DIR/themes"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
TERMUX_DIR="$HOME/.termux"

mkdir -p "$TERMUX_DIR"

apply_prompt() {
    local prompt="$1"
    local target="$BASHRC"

    touch "$target"

    # Remove only our own managed block.
    sed -i '/# >>> YOMA TERMUX THEME >>>/,/# <<< YOMA TERMUX THEME <<</d' "$target"

    {
        echo
        echo "# >>> YOMA TERMUX THEME >>>"
        echo "$prompt"
        echo "# <<< YOMA TERMUX THEME <<<"
    } >> "$target"
}

apply_theme() {
    local name="$1"
    local file="$THEME_DIR/$name.conf"

    if [ ! -f "$file" ]; then
        echo "Theme not found: $name"
        return 1
    fi

    # shellcheck disable=SC1090
    source "$file"

    printf '%s\n' "${YOMA_BANNER:-}"
    echo "Applying: ${YOMA_NAME:-$name}"

    if [ -n "${YOMA_PROMPT:-}" ]; then
        apply_prompt "$YOMA_PROMPT"
    fi

    if [ -n "${YOMA_COLORS:-}" ]; then
        printf '%s\n' "$YOMA_COLORS" > "$TERMUX_DIR/colors.properties"
    fi

    if [ -n "${YOMA_TERMUX_PROPERTIES:-}" ]; then
        printf '%s\n' "$YOMA_TERMUX_PROPERTIES" > "$TERMUX_DIR/termux.properties"
    fi

    echo
    echo "✓ Theme applied."
    echo "Restart Termux or run: source ~/.bashrc"
}

while true; do
    clear
    echo "╔══════════════════════════════════════╗"
    echo "║          YOMA TERMUX THEME           ║"
    echo "╠══════════════════════════════════════╣"
    echo "║  [1] YOMA Cyber                      ║"
    echo "║  [2] Cyberpunk                       ║"
    echo "║  [3] Matrix                          ║"
    echo "║  [4] Minimal                         ║"
    echo "║  [5] Reset / Restore                 ║"
    echo "║  [6] Uninstall                       ║"
    echo "║  [0] Exit                            ║"
    echo "╚══════════════════════════════════════╝"
    echo
    read -r -p "Choose: " choice

    case "$choice" in
        1) apply_theme "yoma.conf"; read -r -p "Press Enter..." ;;
        2) apply_theme "cyberpunk.conf"; read -r -p "Press Enter..." ;;
        3) apply_theme "matrix.conf"; read -r -p "Press Enter..." ;;
        4) apply_theme "minimal.conf"; read -r -p "Press Enter..." ;;
        5)
            if [ -f "$APP_DIR/backup/.bashrc" ]; then
                cp "$APP_DIR/backup/.bashrc" "$BASHRC"
            else
                sed -i '/# >>> YOMA TERMUX THEME >>>/,/# <<< YOMA TERMUX THEME <<</d' "$BASHRC" 2>/dev/null || true
            fi
            rm -f "$TERMUX_DIR/colors.properties" "$TERMUX_DIR/termux.properties"
            echo "✓ Theme reset."
            read -r -p "Press Enter..."
            ;;
        6)
            bash "$APP_DIR/uninstall.sh"
            exit 0
            ;;
        0) exit 0 ;;
        *) echo "Invalid option."; sleep 1 ;;
    esac
done
