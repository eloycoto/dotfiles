#!/bin/bash

DATE=$(date +%Y%m%d)
DIR=$(pwd)
ZSHRC=1


#Vims conf
if [ -d ~/.vim ]
then
    mv ~/.vim ~/.vim-$DATE
fi

if [ -f ~/.vimrc ]
then
    mv ~/.vimrc ~/.vimrc-$DATE
fi

rm -rfv $HOME/.vim
cp -Rv $DIR/vim/ $HOME/.vim/

rm  $HOME/.vimrc
rm  $HOME/.gvimrc
ln -s  $HOME/.vim/vimrc $HOME/.vimrc
ln -s  $HOME/.vim/vimrc $HOME/.gvimrc


cd /tmp/ 
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
if [ $ZSHRC == 1 ];then
    chsh -s /bin/zsh 
    echo "Installing zsh on the machine"
fi

cd $DIR
cp -Rv zshrc $HOME/.zshrc
cp -Rv bash_aliases $HOME/.bash_aliases


