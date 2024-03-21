export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
source "$HOME"/.local/bin/colors.sh
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
ZSH_HIGHLIGHT_STYLES[comment]="none"
export EDITOR="vim"
setopt NO_AUTO_CD
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
