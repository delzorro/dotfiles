# My dotfiles (.files)


Dotfiles voor macOS en Debian-gebaseerde Linux-distributies, met Ghostty, tmux, vim, zsh en FZF.

## Prerequisites

**macOS** — installeer via Homebrew:

```bash
brew install vim neovim tmux fzf bat universal-ctags
brew install --cask ghostty
```

**Debian/Ubuntu** — installeer via apt:

```bash
sudo apt install vim tmux fzf bat universal-ctags
```

Ghostty op Linux: zie [ghostty.org](https://ghostty.org) voor de officiele installatie-instructies.

> Op oudere Ubuntu-versies (< 22.04) heet het `bat`-binary `batcat`. Voeg dan toe aan `~/.bashrc` / `~/.zshrc`: `alias bat=batcat`

Optioneel — NVM voor Node.js versiebeheer (lazy-loaded bij eerste gebruik):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
```

## Installation

De `.files`-directory staat in je homedir (`~/.files`).

### Automatisch

Clone de repo en voer het installatiescript uit:

```bash
git clone <repo-url> ~/.files
cd ~/.files
bash install.sh
```

Het script configureert alle componenten, slaat stappen over die al correct zijn ingesteld,
en maakt backups van bestaande bestanden als `<bestand>.bak.<datum>`.

### Handmatig

### 1. Shell (zsh / bash)

Shell-configs zijn machine-specifieke bestanden (niet gesymlinkt) die de gedeelde `.default`-versie
uit `.files` inladen. Maak ze eenmalig aan:

```bash
echo '[ -f ~/.files/shell/bash_profile.default ] && source ~/.files/shell/bash_profile.default' >> ~/.bash_profile
echo '[ -f ~/.files/shell/bashrc.default ]       && source ~/.files/shell/bashrc.default'       >> ~/.bashrc
echo '[ -f ~/.files/shell/zshrc.default ]        && source ~/.files/shell/zshrc.default'        >> ~/.zshrc
echo '[ -f ~/.files/shell/zshenv.default ]       && source ~/.files/shell/zshenv.default'       >> ~/.zshenv
```

Machine-specifieke toevoegingen (zoals bijvoorbeeld project-specifieke PATH-entries) horen direct in de betreffende `~/.*` bestanden, niet in `.files`.

### 2. Vim + Neovim

```bash
ln -s ~/.files/vim/vimrc.all.configuration ~/.vimrc
mkdir -p ~/.config/nvim
ln -s ~/.files/vim/nvim.init.vim ~/.config/nvim/init.vim
```

vim-plug installeren voor beide:
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Open daarna vim en nvim en run `:PlugInstall` in beide. In nvim ook `:TSUpdate` voor de treesitter markdown parser (vereist door `render-markdown.nvim`).
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
# Geen extra stap nodig na installatie (brew / apt)
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

### 7. Claude Code

Koppel de gedeelde CLAUDE.md (persoonlijke instructies voor Claude) aan de door Claude Code
verwachte locatie:

```bash
ln -s ~/.files/claude/CLAUDE.personal.md ~/.claude/CLAUDE.md
```

Dit zorgt dat Claude altijd je persoonlijke gedragsregels en taalvoorkeur laadt, ongeacht
vanuit welk project je werkt.

**clue** (**C**laude **L**ocal **U**nified **E**xperience) is een wrapper die Claude Code opstart
in een gesplitst tmux-venster met een `plan.md` preview rechts. In combinatie met `CLAUDE.md`
houdt Claude de `plan.md` automatisch bij als levend plan-document. De preview gebruikt `neovim` met `render-markdown.nvim` voor in-buffer markdown-rendering met auto-refresh en scrollpositiebehoud.

Claude structureert het plan met sectie-ankertjes (`[S1]`, `[S2]`, ...) zodat je gerichte
feedback kunt geven zonder afhankelijk te zijn van regelnummers die verschuiven.

```bash
clue
```

## Gebruik

Typische workflow per werksessie:

### 1. Open Ghostty en start een tmux-sessie

```bash
tmux new-session -s dev          # nieuwe sessie
# of
tmux attach -t dev               # bestaande sessie hervatten
```

### 2. Navigeer naar je project

```bash
cd ~/projects/mijn-project
```

### 3. Start de Claude-werkomgeving

```bash
clue
```

Dit opent een gesplitst venster: Claude Code links (55%) en een live `plan.md` preview rechts
(45%). Claude werkt het plan automatisch bij op basis van de instructies in `~/.claude/CLAUDE.md`.

### Overige sneltoetsen

- **Tagbar** (`<leader>r`) — toont symbolen/functies van het huidige bestand; vereist `universal-ctags`.
- **Prefix tmux** — `Ctrl-\`; pane-navigatie met `Alt-hjkl`.
- **FZF in vim** — `<leader>f` voor bestandszoeker met preview.
