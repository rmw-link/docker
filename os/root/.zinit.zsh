source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

run(){
[[ ! -f $1 ]] || source $1
}

run ~/.p10k.zsh
#run $ZINIT_HOME/../plugins/tj---git-extras/etc/git-extras-completion.zsh

if [[ -r "~/.cache/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "~/.cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi


zinit ice depth=1
zinit light romkatv/powerlevel10k

#zinit ice wait lucid
#export ATUIN_NOBIND="true"
#zinit load ellie/atuin

#zle -N _atuinr_widget _atuinr
#
#_atuinr() {
#    atuin history list --cmd-only | fzf
#}
#bindkey '^r' _atuinr_widget
#bindkey '^[[A' _atuinr_widget


zinit ice wait lucid
zinit light skywind3000/z.lua

export FZ_HISTORY_CD_CMD=_zlua
zinit ice wait lucid
zinit light changyuheng/fz

zinit ice wait lucid
zinit light changyuheng/zsh-interactive-cd

zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#aaaaaa,bg=black"
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
zinit ice wait lucid
zinit light zdharma-continuum/history-search-multi-word

#zinit ice wait'1' lucid
#zinit load romkatv/gitstatus

bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

eval "$(direnv hook $SHELL)"
