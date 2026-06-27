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

```bash
ln -s ~/.files/bashrc          ~/.bashrc
ln -s ~/.files/bash_profile    ~/.bash_profile
ln -s ~/.files/zshrc           ~/.zshrc
ln -s ~/.files/zshenv          ~/.zshenv
```

### 2. Vim

```bash
ln -s ~/.files/vimrc           ~/.vimrc
ln -s ~/.files/ideavimrc       ~/.ideavimrc
```

vim-plug installeren:
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Open daarna vim en run `:PlugInstall` om alle plugins te installeren.
`bat` en `universal-ctags` zijn vereist voor respectievelijk FZF-previews in vim en tagbar.

### 3. Tmux

```bash
ln -s ~/.files/tmux.conf       ~/.tmux.conf
```

### 4. Ghostty

```bash
mkdir -p ~/.config/ghostty
ln -s ~/.files/ghostty.config  ~/.config/ghostty/config
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

Keybindings en opties staan in `fzf.default.configuration`. Actieve bindings:
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
