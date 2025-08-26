#!/bin/bash

# MyDotfiles 一键安装脚本
# 适用于 Ubuntu/Debian 和 CentOS/RHEL 系统

set -e

echo "=== MyDotfiles 配置安装脚本 ==="
echo "正在检测系统..."

# 检测操作系统
if [ -f /etc/debian_version ]; then
    OS="debian"
    echo "检测到 Debian/Ubuntu 系统"
elif [ -f /etc/redhat-release ]; then
    OS="rhel"
    echo "检测到 RHEL/CentOS 系统"
else
    echo "不支持的操作系统，脚本退出"
    exit 1
fi

# 安装基础依赖
echo "正在安装基础依赖..."
if [ "$OS" = "debian" ]; then
    sudo apt update
    sudo apt install -y curl wget git zsh vim build-essential
elif [ "$OS" = "rhel" ]; then
    sudo yum update -y
    sudo yum groupinstall -y "Development Tools"
    sudo yum install -y curl wget git zsh vim
fi

# 检查 ZSH 是否已安装
if ! command -v zsh &> /dev/null; then
    echo "ZSH 安装失败，请手动安装"
    exit 1
fi

echo "ZSH 安装成功"

# 设置 ZSH 为默认 shell
echo "设置 ZSH 为默认 shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo "已设置 ZSH 为默认 shell，请重新登录后继续"
fi

# 安装 Oh My Zsh
echo "正在安装 Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh 安装完成"
else
    echo "Oh My Zsh 已存在，跳过安装"
fi

# 安装必需的插件
echo "正在安装 ZSH 插件..."

# zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "zsh-autosuggestions 安装完成"
fi

# zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "zsh-syntax-highlighting 安装完成"
fi

# 备份现有配置文件
echo "正在备份现有配置文件..."
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    echo "已备份 .zshrc"
fi

if [ -f "$HOME/.condarc" ]; then
    cp "$HOME/.condarc" "$HOME/.condarc.backup.$(date +%Y%m%d_%H%M%S)"
    echo "已备份 .condarc"
fi

# 克隆配置文件
echo "正在下载配置文件..."
if [ -d "/tmp/mydotfiles" ]; then
    rm -rf /tmp/mydotfiles
fi

git clone https://github.com/Parallelopiped/MyDotfiles.git /tmp/mydotfiles

# 复制配置文件
echo "正在应用配置文件..."
cp /tmp/mydotfiles/.zshrc "$HOME/"
cp /tmp/mydotfiles/.condarc "$HOME/"
cp -r /tmp/mydotfiles/.oh-my-zsh/themes "$HOME/.oh-my-zsh/"

# 清理临时文件
rm -rf /tmp/mydotfiles

echo "=== 安装完成 ==="
echo ""
echo "⚠️  重要提示："
echo "1. 请编辑 ~/.zshrc 文件，将其中的用户路径从 'zlt' 修改为您的用户名"
echo "2. 如果不需要 Conda，请注释掉相关配置"
echo "3. 如果不需要 CUDA，请注释掉 CUDA 环境变量"
echo "4. 如果不需要代理功能，请删除或修改 ppp/noppp 函数"
echo ""
echo "配置文件位置："
echo "- ZSH 配置: ~/.zshrc"
echo "- Conda 配置: ~/.condarc"
echo "- 自定义主题: ~/.oh-my-zsh/themes/passion.zsh-theme"
echo ""
echo "运行以下命令重新加载配置："
echo "  source ~/.zshrc"
echo ""
echo "或者重新启动终端以应用所有更改。"