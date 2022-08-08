source  /etc/profile

. $HOME/.asdf/asdf.sh

if [ -f ~/.py3/bin/activate ]; then
export VIRTUAL_ENV_DISABLE_PROMPT=yes
source ~/.py3/bin/activate
fi

alias df=duf
alias gl=glances
alias ls=exa
alias vi=nvim
alias vim=nvim
export EDITOR=nvim
export TERM=xterm-256color

export PATH="$HOME/.bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
