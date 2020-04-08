# Path variables
if [ -e $HOME/bin ]; then
    export PATH=$HOME/bin:$PATH
fi

#Go things
export PATH=$PATH:$HOME/.go/bin

export GOPATH=$HOME/.go/
export GOROOT=/usr/local/go/

export EDITOR="vim"

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git virtualenvwrapper python github tmux)
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
source $ZSH/oh-my-zsh.sh

if [[ $(command -v direnv) ]]; then
    eval "$(direnv hook $SHELL)"
fi

if [ -e $HOME/.bash_aliases ];then
    source $HOME/.bash_aliases
fi

if [ $(uname) != "Darwin" ];then
    SERVER=$(hostname)
    PROMPT="${SERVER} ${PROMPT}"
else
    SERVER='local'
fi

if command -v most > /dev/null 2>&1; then
    export PAGER="most"
fi
