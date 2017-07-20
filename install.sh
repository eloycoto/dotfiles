#!/bin/bash

DATE=$(date +%Y%m%d)
DIR=$(pwd)
ZSHRC=1

git submodule init
git submodule update


#Vims conf
if [ -d ~/.vim ]
then
    mv ~/.vim ~/.vim-$DATE
fi

if [ -f ~/.vimrc ]
then
    mv ~/.vimrc ~/.vimrc-$DATE
fi

if [ -f ~/.ctags ]
then
    mv ~/.ctags ~/.ctags-$DATE
fi

cp -v ctags ~/.ctags

if [ -f ~/.dev_requirements.txt ]
then
    mv ~/.dev_requirements.txt ~/.dev_requirements.txt-$DATE
fi
cp -v dev_requirements.txt ~/.dev_requirements.txt

#Move tmux config to home folder
cp -v tmux.conf ~/.tmux.conf
cp -v psqlrc ~/.psqlrc
cp -rfv psqlrc_alias ~/.psqlrc_alias
cp -Rfv bin ~/bin


rm -rfv $HOME/.vim
cp -Rv $DIR/vim/ $HOME/.vim/

rm  $HOME/.vimrc
ln -s  $HOME/.vim/vimrc $HOME/.vimrc


cd /tmp/
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
if [ $ZSHRC  ];
then
    chsh -s /bin/zsh
    echo "Installing zsh on the machine"
fi

cd $DIR

cp -Rv zshrc $HOME/.zshrc
cp -Rv bash_aliases $HOME/.bash_aliases
cp -Rv ssh/* $HOME/.ssh/

if [ -d ~/.gitconfig ]
then
    mv ~/.gitconfig ~/.gitconfig-$DATE
fi
cp -v gitconfig ~/.gitconfig

sudo pip install virtualenvwrapper

if [ $(uname) =  "Darwin" ]; then
    cp launch/* ~/Library/LaunchAgents/
    ls -1 launch/* | while read line;
    do
        lib=$(echo $line | awk -F '/' '{print $2}')
        echo "launchctl load ~/Library/LaunchAgents/$lib"
    done
fi
