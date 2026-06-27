#!/usr/bin/env bash
# install.sh — dotfiles setup
# Zet de dotfiles-omgeving op. Bestaande bestanden worden gebackupt als .bak.<datum>.

set -uo pipefail

DOTFILES="$HOME/.files"
DATE=$(date +%Y-%m-%d)
BACKED_UP_FILES=""

# ── helpers ──────────────────────────────────────────────────────────────────

_b='\033[1m'; _green='\033[0;32m'; _yellow='\033[1;33m'; _blue='\033[0;34m'; _r='\033[0m'
log()  { echo -e "\n${_blue}${_b}▸ $*${_r}"; }
ok()   { echo -e "  ${_green}✓${_r}  $*"; }
skip() { echo -e "  ${_yellow}–${_r}  $*"; }
info() { echo -e "    $*"; }

backup() {
    local file="$1"
    [[ -f "$file" && ! -L "$file" ]] || return 0
    [[ "$BACKED_UP_FILES" == *"|$file|"* ]] && return 0
    cp "$file" "${file}.bak.${DATE}"
    BACKED_UP_FILES="${BACKED_UP_FILES}|$file|"
    ok "backup  → $(basename "$file").bak.${DATE}"
}

# Voeg regel toe aan het einde van een bestand, met lege regel als scheiding.
append_once() {
    local file="$1" line="$2"
    if grep -qF "$line" "$file" 2>/dev/null; then
        skip "al aanwezig  $(basename "$file")"
        return
    fi
    backup "$file"
    touch "$file"
    [[ -s "$file" ]] && printf '\n' >> "$file"
    printf '%s\n' "$line" >> "$file"
    ok "toegevoegd → $(basename "$file")"
}

# Voeg regel toe aan het begin van een bestand (bijv. SSH Include).
prepend_once() {
    local file="$1" line="$2"
    if grep -qF "$line" "$file" 2>/dev/null; then
        skip "al aanwezig  $(basename "$file")"
        return
    fi
    backup "$file"
    touch "$file"
    local tmp
    tmp=$(mktemp)
    if [[ -s "$file" ]]; then
        { printf '%s\n\n' "$line"; cat "$file"; } > "$tmp"
    else
        printf '%s\n' "$line" > "$tmp"
    fi
    mv "$tmp" "$file"
    ok "toegevoegd (begin) → $(basename "$file")"
}

# Maak een symlink aan, met backup van een eventueel bestaand regulier bestand.
symlink() {
    local src="$1" dst="$2"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        skip "symlink bestaat al  $(basename "$dst")"
        return
    fi
    backup "$dst"
    # Verwijder bestaand bestand of foute symlink zodat ln -s niet faalt
    [[ -e "$dst" || -L "$dst" ]] && rm "$dst"
    ln -s "$src" "$dst"
    ok "symlink    $(basename "$dst") → $src"
}

require() {
    command -v "$1" &>/dev/null || { info "Vereist: $1 niet gevonden — sla stap over."; return 1; }
}

# ── installatie ───────────────────────────────────────────────────────────────

echo -e "\n${_blue}${_b}dotfiles installatie${_r}"
echo "════════════════════"
echo "  dotfiles-pad : $DOTFILES"
echo "  backup-suffix: .bak.${DATE}"

# 1. Shell
log "1. Shell"
append_once "$HOME/.bash_profile" "[ -f ~/.files/shell/bash_profile.default ] && source ~/.files/shell/bash_profile.default"
append_once "$HOME/.bashrc"       "[ -f ~/.files/shell/bashrc.default ]       && source ~/.files/shell/bashrc.default"
append_once "$HOME/.zshrc"        "[ -f ~/.files/shell/zshrc.default ]        && source ~/.files/shell/zshrc.default"
append_once "$HOME/.zshenv"       "[ -f ~/.files/shell/zshenv.default ]       && source ~/.files/shell/zshenv.default"

# 2. Vim
log "2. Vim"
symlink "$DOTFILES/vim/vimrc.all.configuration" "$HOME/.vimrc"
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
    if require curl; then
        curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
            && ok "vim-plug geïnstalleerd"
        info "→ open vim en run :PlugInstall om plugins te installeren"
    fi
else
    skip "vim-plug bestaat al"
fi

# 3. Tmux
log "3. Tmux"
append_once "$HOME/.tmux.conf" "source-file -q ~/.files/tmux/conf.default"

# 4. Ghostty
log "4. Ghostty"
if command -v ghostty &>/dev/null || [[ -d "/Applications/Ghostty.app" ]]; then
    mkdir -p "$HOME/.config/ghostty"
    append_once "$HOME/.config/ghostty/config" "config-file = ~/.files/ghostty/config.default"
else
    skip "Ghostty niet gevonden — sla configuratie over"
    info "→ installeer Ghostty en herrun dit script, of voeg handmatig toe aan ~/.config/ghostty/config"
fi

# 5. SSH
# Include bovenaan: SSH verwerkt top-down (eerste match wint), shared config als basis,
# machine-specifieke overrides eronder.
log "5. SSH"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
prepend_once "$HOME/.ssh/config" "Include ~/.files/ssh/config*"

# 6. Claude Code
log "6. Claude Code"
if command -v claude &>/dev/null; then
    mkdir -p "$HOME/.claude"
    symlink "$DOTFILES/claude/CLAUDE.personal.md" "$HOME/.claude/CLAUDE.md"
else
    skip "claude niet gevonden — sla CLAUDE.md symlink over"
    info "→ installeer Claude Code en herrun dit script"
fi

# ── klaar ─────────────────────────────────────────────────────────────────────

echo -e "\n${_green}${_b}Klaar.${_r}"
echo "  Herstart je shell of run:  source ~/.zshrc"
echo ""
