#!/usr/bin/env bash

crabman_str="crabman"
bin_dir="/usr/local/bin"
soft_link_file="${bin_dir}/${crabman_str}"
crabman_work_dir="${HOME}/.crabman"
crabman_bin_file="${crabman_work_dir}/${crabman_str}"

# 请求 bin 目录的写入权限
if [[ ! -w ${bin_dir} ]]; then
    echo "为了使用 crabman，请输入密码 ："
    sudo chown $(whoami) ${bin_dir}
fi

# 创建工作目录
if [[ ! -e ${crabman_work_dir} ]]; then
    mkdir ${crabman_work_dir}
fi

echo "开始安装crabman..."
# 从 GitHub 上下载脚本
curl --retry 2 -o ${crabman_bin_file} https://raw.githubusercontent.com/CrabMen/AliasAndSnippet/master/main.sh
# 本地开发时直接将文件复制过去
# cp ./main.sh ${crabman_bin_file}

if [[ $? -eq 0 ]]; then
    # 给 crabman 添加执行权限
    chmod 755 ${crabman_bin_file}
    # 创建一个到 /usr/local/bin/crabman 的软链
    ln -sf ${crabman_bin_file} ${soft_link_file}
    echo "成功安装 crabman！"
    ${crabman_bin_file} -n
else
    echo "安装crabman失败，请稍后重试。"
    exit 1
fi
