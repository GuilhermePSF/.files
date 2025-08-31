if [[ -o interactive ]]; then
    pokemon-colorscripts -n swampert | fastfetch --disable-linewrap --logo -
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ========== Oh My Zsh ==========
export ZSH="$HOME/.oh-my-zsh"

# You can switch themes easily; comment/uncomment to change
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="candy"

# Use oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Enable auto-update and completion cache
zstyle ':omz:update' mode auto
zstyle ':completion:' use-cache on

ENABLE_CORRECTION="true"
CORRECT_IGNORE_FILE=tests

# ========== Plugins ==========
plugins=(git asdf zsh-autosuggestions colored-man-pages command-not-found fzf-tab z autoswitch_virtualenv zsh-syntax-highlighting)

# ========== External Configs ==========
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"
[[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"

# ========== Environment ==========
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export EDITOR=/usr/bin/nvim
export SUDO_EDITOR=nvim
export BROWSER=/usr/bin/firefox-developer-edition

# ========== History ==========
export HISTFILESIZE=100000000000
export SAVEHIST=5000000
export HISTSIZE=5000000
HIST_STAMPS="%d-%m-%Y"

# ========== PATH ==========
export PATH=~/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/share:$PATH
export PATH=$HOME/dotfiles/scripts:$PATH

# asdf
. "$HOME/.asdf/asdf.sh"
export ASDF_DIRENV_IGNORE_MISSING_PLUGINS=1
ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
fpath=(${ASDF_DIR}/completions $fpath)

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# go
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export GOPATH=$HOME/.go
export PATH="$PATH:/usr/bin/go:$PATH"

# elixir
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 4096000"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# flyctl
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# vcpkg
export VCPKG_ROOT="$HOME/Clones/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"

# ghcup (Haskell)
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# ========== fzf ==========
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ========== Direnv ==========
eval "$(direnv hook zsh)"

# ========== Clipcat ==========
if type clipcat-menu >/dev/null 2>&1; then
    alias clipedit='clipcat-menu --finder=builtin edit'
    alias clipdel='clipcat-menu --finder=builtin remove'

    bindkey -s '^\' "^Q clipcat-menu --finder=builtin insert ^J"
    bindkey -s '^]' "^Q clipcat-menu --finder=builtin remove ^J"
fi

# ========== Custom Aliases/Functions ==========
ce() {
  cd "$@" && code . && exit
}

eval "$(zoxide init zsh)"

# ========== Powerlevel10k fallback ==========
source ~/powerlevel10k/powerlevel10k.zsh-theme 2>/dev/null || true
