#! /bin/bash

#检查是否存在~/.zhsrc 文件
function check_oh_my_zsh() {
    # read file

    if [ -d ~/.oh-my-zsh ] then
        echo 'zshrc配置文件存在'
    else
        echo 'zshrc配置文件不存在,开始安装oh-my-zsh'
         install_oh_my_zsh
    fi
}

#安装oh-my-zsh
function install_oh_my_zsh() {
    echo "******* installing oh-my-zsh ********"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}


function install_homebrew() {

    if [ ! `which brew`] then 
        echo 'trying to install homebrew...'
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        
    else
        echo 'You have already homebrew installed'
    fi
        
}



check_oh_my_zsh
