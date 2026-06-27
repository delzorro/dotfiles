# My dotfiles (.files)

Dotfiles voor macOS met Ghostty, tmux, vim, zsh en FZF.

## Prerequisites

Installeer via Homebrew:

```bash
brew install vim tmux fzf bat universal-ctags
brew install --cask ghostty
```

Optioneel — Nerd Font voor iconen in NERDTree en lightline:
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

Optioneel — NVM voor Node.js versiebeheer (lazy-loaded bij eerste gebruik):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
```

## Installation

De `.files`-directory staat in je homedir (`~/.files`).

### 1. Shell (zsh / bash)

Shell-configs zijn machine-specifieke bestanden (niet gesymlinkt) die de gedeelde `.default`-versie
uit `.files` inladen. Maak ze eenmalig aan:

```bash
echo '[ -f ~/.files/shell/bash_profile.default ] && source ~/.files/shell/bash_profile.default' >> ~/.bash_profile
echo '[ -f ~/.files/shell/bashrc.default ]       && source ~/.files/shell/bashrc.default'       >> ~/.bashrc
echo '[ -f ~/.files/shell/zshrc.default ]        && source ~/.files/shell/zshrc.default'        >> ~/.zshrc
echo '[ -f ~/.files/shell/zshenv.default ]       && source ~/.files/shell/zshenv.default'       >> ~/.zshenv
```

Machine-specifieke toevoegingen (zoals Rancher Desktop, Cloud SDK, project-specifieke PATH-entries)
horen direct in de betreffende `~/.*` bestanden, niet in `.files`.

### 2. Vim

```bash
ln -s ~/.files/vim/vimrc.all.configuration ~/.vimrc
```

vim-plug installeren:
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Open daarna vim en run `:PlugInstall` om alle plugins te installeren.
`bat` en `universal-ctags` zijn vereist voor respectievelijk FZF-previews in vim en tagbar.

`~/.ideavimrc` is machine-specifiek. Maak het eenmalig aan:
```bash
printf 'if filereadable(expand("~/.files/vim/ideavimrc.default"))\n  source ~/.files/vim/ideavimrc.default\nendif\n' >> ~/.ideavimrc
```

### 3. Tmux

`~/.tmux.conf` is machine-specifiek. Maak het eenmalig aan:
```bash
echo 'source-file -q ~/.files/tmux/conf.default' >> ~/.tmux.conf
```

### 4. Ghostty

`~/.config/ghostty/config` is machine-specifiek. Maak het eenmalig aan:
```bash
mkdir -p ~/.config/ghostty
echo 'config-file = ~/.files/ghostty/config.default' >> ~/.config/ghostty/config
```

True color is geconfigureerd via Ghostty → tmux → vim: vim-colorschemes tonen hiermee
hex-kleuren (`guifg=#RRGGBB`) correct in plaats van terugvallen op de 256-kleuren benadering.
Buiten Ghostty (bijv. SSH zonder tmux) schakelt vim automatisch terug naar 256-kleuren via een
`$COLORTERM`-guard in `vimrc.default.configuration`.

### 5. FZF

```bash
# Wordt automatisch geladen via .zshrc / .bashrc
# Geen extra stap nodig na brew install fzf
```

Keybindings en opties staan in `fzf/configuration.default`. Actieve bindings:
- `Ctrl-R` — geschiedenis zoeken met preview
- `Ctrl-T` — bestandszoeker met bat-preview
- `Alt-C` — directory-navigatie
- In vim: `<leader>f` — bestandszoeker met bat-preview en `ctrl-n/p` door de lijst

### 6. SSH

Voeg toe aan `~/.ssh/config` (aanmaken indien nodig):
```
Include ~/.files/ssh/config*
```

Dit laadt `~/.files/ssh/config.default`, dat `TERM=xterm-256color` meegeeft voor SSH-sessies
op Linux-servers waar `xterm-ghostty` niet beschikbaar is.

## Gebruik

- **claude-plan** — start een gesplitst tmux-venster: `plan.md` in vim rechts, claude links:
  ```bash
  claude-plan
  ```
- **Tagbar** (`<leader>r`) — toont symbolen/functies van het huidige bestand; vereist `universal-ctags`.
- **Prefix tmux** — `Ctrl-\`; pane-navigatie met `Alt-hjkl`.
