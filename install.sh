#! /bin/bash

#检查是否存在~/.zhsrc 文件
function check_oh_my_zsh() {

    file="~/.zshrc"
    # read file

    if [ -f "$file" ]
    then
        echo 'zshrc配置文件存在'
    else
        echo 'zshrc配置文件不存在******'
        # install_oh_my_zsh
        # check_oh_my_zsh
    fi
}

#安装oh-my-zsh
function install_oh_my_zsh() {
    echo "******* installing oh-my-zsh ********"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

check_oh_my_zsh
