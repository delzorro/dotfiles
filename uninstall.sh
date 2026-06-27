#!/usr/bin/env bash
# uninstall.sh — dotfiles reset
# Maakt install.sh ongedaan: verwijdert toegevoegde regels en symlinks, herstelt backups indien aanwezig.

set -uo pipefail

_b='\033[1m'; _green='\033[0;32m'; _yellow='\033[1;33m'; _blue='\033[0;34m'; _r='\033[0m'
log()  { echo -e "\n${_blue}${_b}▸ $*${_r}"; }
ok()   { echo -e "  ${_green}✓${_r}  $*"; }
skip() { echo -e "  ${_yellow}–${_r}  $*"; }

remove_line() {
    local file="$1" line="$2"
    [[ -f "$file" ]] || { skip "bestaat niet   $(basename "$file")"; return; }
    grep -qF "$line" "$file" || { skip "al afwezig    $(basename "$file")"; return; }
    local tmp; tmp=$(mktemp)
    grep -vF "$line" "$file" > "$tmp"
    mv "$tmp" "$file"
    ok "verwijderd   $(basename "$file")"
}

remove_symlink() {
    local dst="$1"
    if [[ -L "$dst" ]]; then
        rm "$dst"
        ok "symlink weg   $(basename "$dst")"
    else
        skip "geen symlink  $(basename "$dst")"
    fi
    local latest_backup
    latest_backup=$(ls -t "${dst}.bak."* 2>/dev/null | head -1)
    if [[ -n "$latest_backup" ]]; then
        mv "$latest_backup" "$dst"
        ok "backup terug  $(basename "$dst") ← $(basename "$latest_backup")"
    fi
}

echo -e "\n${_blue}${_b}dotfiles reset${_r}"
echo "══════════════"

log "1. Shell"
remove_line "$HOME/.bash_profile" "[ -f ~/.files/shell/bash_profile.default ] && source ~/.files/shell/bash_profile.default"
remove_line "$HOME/.bashrc"       "[ -f ~/.files/shell/bashrc.default ]       && source ~/.files/shell/bashrc.default"
remove_line "$HOME/.zshrc"        "[ -f ~/.files/shell/zshrc.default ]        && source ~/.files/shell/zshrc.default"
remove_line "$HOME/.zshenv"       "[ -f ~/.files/shell/zshenv.default ]       && source ~/.files/shell/zshenv.default"

log "2. Vim"
remove_symlink "$HOME/.vimrc"

log "3. Tmux"
remove_line "$HOME/.tmux.conf" "source-file -q ~/.files/tmux/conf.default"

log "4. Ghostty"
remove_line "$HOME/.config/ghostty/config" "config-file = ~/.files/ghostty/config.default"

log "5. SSH"
remove_line "$HOME/.ssh/config" "Include ~/.files/ssh/config*"

log "6. Claude Code"
remove_symlink "$HOME/.claude/CLAUDE.md"

echo -e "\n${_green}${_b}Reset klaar.${_r}"
echo "  Open een nieuw venster en run: bash ~/.files/install.sh"
echo ""
