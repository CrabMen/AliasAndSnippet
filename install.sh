#! /bin/bash

function install_oh_my_zsh() {

    if [ -d ~/.oh-my-zsh ] then
        echo 'You have already Oh My Zsh installed'
    else
        echo 'trying to install oh-my-zsh...'
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
}


function install_cocoapods() {
    if [ ! `which pod`] then 
        echo 'trying to install cocoapods...'
            sudo gem install cocoapods
    else
        echo 'You have already cocoapods installed'
    fi

}


function install_homebrew() {

    if [ ! `which brew`] then 
        echo 'trying to install homebrew...'
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
    else
        echo 'You have already homebrew installed'
    fi
        
}

function install_react_native() {
    brew install watchman
    # use nvm to manage node 
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

    nvm install node 

    npm install -g yarn react-native-cli
}


function pre_develop_environment() {

install_oh_my_zsh
install_cocoapods
install_homebrew
install_react_native


}