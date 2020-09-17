#!/usr/bin/env bash

crabman_work_dir="${HOME}/.crabman"
crabman_snippets_dir="${crabman_work_dir}/CMCodeSnippets"

#xcode路径
xcode_dir="${HOME}/Library/Developer/Xcode"

# xcode code snippets 路径
xcode_snippets_dir="${xcode_dir}/UserData/CodeSnippets"

echo_with_date() {
    echo "[$(date '+%H:%M:%S')]" $1
}

git_clone_snippets_rep() {
    if [ -d $crabman_snippets_dir ]; then
        echo_with_date "本地CMCodeSnippets仓库已存在"
    else
        cd ${crabman_work_dir}
        git clone https://github.com/CrabMen/CMCodeSnippets.git CMCodeSnippets
        if [[ $? -eq 0 ]]; then
            check_snippets_dir
        else
            echo_with_date "远程并没有snippets仓库"
        fi
    fi
}

prepare_snippets_sync() {

    if [ -d $crabman_snippets_dir ] && [ -d $xcode_snippets_dir ]; then
        echo_with_date "code snippets 环境已准备好,等待执行操作"
    else
        #检查xcode的snippets路径
        check_dir $xcode_snippets_dir
        git_clone_snippets_rep
        if [[ $? -eq 0 ]]; then
            prepare_snippets_sync
        fi
    fi
}

download_snippets() {
    prepare_snippets_sync
    cd $crabman_snippets_dir
    git pull
    if [[ $? -eq 0 ]]; then
        cp -fvrap $crabman_snippets_dir/* $xcode_snippets_dir/
        echo_with_date "code snippets 下载成功"
    else
        echo_with_date "网络异常,请稍后重试"
    fi

    # if [ -d $crabman_snippets_dir ] && [ -d $xcode_snippets_dir ]; then
    #     cd $crabman_snippets_dir
    #     git pull
    #     if [[ $? -eq 0 ]]; then
    #         cp -fvrap $crabman_snippets_dir/* $xcode_snippets_dir/
    #         echo_with_date "code snippets 下载成功"
    #     else
    #         echo_with_date "网络异常,请稍后重试"
    #     fi
    # else
    #     #检查xcode的snippets路径
    #     check_dir $xcode_snippets_dir
    #     git_clone_snippets_rep

    #     if [[ $? -eq 0 ]]; then
    #         download_snippets
    #     fi
    # fi
}

upload_snippets() {
    echo "准备上传...."
    prepare_snippets_sync
    cd $crabman_snippets_dir
    git pull
    wait
    echo "原路径:${xcode_snippets_dir}"
    echo "目标:${crabman_snippets_dir}"
    cp -rap $xcode_snippets_dir/ $crabman_snippets_dir/
    wait
    if [[ $? -eq 0 ]]; then
        git add .
        git commit -m "snippets upload"
        git push
        if [[ $? -eq 0 ]]; then
            echo_with_date "code snippets 上传成功"
        else
            echo_with_date "网络状况不好,请稍后再试..."
        fi
    else
        echo_with_date "网络状况不好,请稍后再试..."
    fi

}

check_dir() {
    if [ ! $# -eq 1 ]; then
        echo "check_dir param error!"
        exit 1
    fi

    dir_name=$1

    if [ -d $dir_name ]; then
        echo_with_date "${dir_name}路径已存在..."
    else
        echo_with_date "${dir_name}路径不存在..."
        mkdir $dir_name
    fi
}

isCommandExits() {
    if [ ! $# -eq 1 ]; then
        echo " param error!"
        exit 1
    fi
    cmd_name=$1
    if [ type $cmd_name ] >/dev/null 2>&1; then
        return 0
        echo_with_date "${cmd_name} was not installed"

    else
        return 1
        echo_with_date "${cmd_name} was installed"

    fi

}

cpp() {
    if [ ! $# -eq 1 ]; then
        echo "param error"
        exit 1
    fi

    ret=$(isCommandExits xcode-select)

    echo "结果是${ret}"

    if [ ${ret} == 0 ]; then
        echo_with_date 'xcode was not installed, please install xcode firstly!!!'
        exit 1
    fi

    if [!$(which xcrun)]; then
        echo_with_date 'xcode commnd line tools was not installed'
        echo_with_date 'trying to install xcode command line tools...'
        xcode-select --install
        wait
        echo_with_date 'xcode command line tools has been installed'
        cpp
    else

        file_path=$1
        temp=${file_path##*/}
        file_name=${temp%.*}
        echo_with_date "目标文件${temp}"

        xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o mainarm64.cpp

        if [[ $? -eq 0 ]]; then
            echo_with_date 'successed generated cpp file '
        else
            echo_with_date "peform error"
            echo_with_date "trying to recovering..."
            sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/
        fi

    fi

}

install_xcode() {
    if [ -d ${xcode_dir} ]; then
        echo_with_date 'You have already Xcode installed'
    else
        echo_with_date 'trying to install xcode'
    fi
}

install_oh_my_zsh() {

    if [ -d ~/.oh-my-zsh ]; then
        echo_with_date 'You have already Oh My Zsh installed'
    else
        echo_with_date 'trying to install oh-my-zsh...'
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
}

install_cocoapods() {
    if [ ! $(which pod)]; then
        echo_with_date 'trying to install cocoapods...'
        sudo gem install cocoapods
    else
        echo_with_date 'You have already cocoapods installed'
    fi
}

install_homebrew() {

    if [ ! $(which brew)]; then
        echo_with_date 'trying to install homebrew...'
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo_with_date 'You have already homebrew installed'
    fi
}

install_react_native() {
    brew install watchman
    # use nvm to manage node
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

    nvm install node

    npm install -g yarn react-native-cli
}

pre_develop_environment() {

    install_oh_my_zsh
    install_cocoapods
    install_homebrew
    install_react_native

}

crabman_version=1.0.0
echo_with_date "当前 crabman 的版本为 v${crabman_version}"
# upload_snippets
# download_snippets
# cpp main.m

# isCommandExits xcode-select
