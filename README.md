# MyDotfiles 配置文件说明文档

本仓库包含了一套完整的 Linux 系统配置文件（dotfiles），主要用于配置 ZSH shell 环境、Conda 包管理器以及相关开发工具。

## 📋 仓库结构

```
.
├── .zshrc                                    # ZSH shell 主配置文件
├── .condarc                                  # Conda 包管理器配置文件
└── .oh-my-zsh/
    └── themes/
        └── passion.zsh-theme                 # 自定义 ZSH 主题
```

## 🔧 配置文件详细分析

### 1. `.zshrc` - ZSH Shell 配置

这是主要的 shell 配置文件，包含以下功能模块：

#### Oh My Zsh 框架配置
- **安装路径**: `$HOME/.oh-my-zsh`
- **主题**: 使用自定义的 "passion" 主题
- **等待提示**: 启用了命令补全时的等待动画 (`COMPLETION_WAITING_DOTS="true"`)

#### 插件配置
```bash
plugins=(
    git                    # Git 命令增强和别名
    extract               # 统一解压命令
    zsh-autosuggestions   # 命令自动建议
    zsh-syntax-highlighting # 语法高亮
)
```

#### Conda 环境集成
- 自动初始化 Miniconda3 环境 (`/home/zlt/miniconda3`)
- 支持 conda 环境管理和包安装

#### CUDA 开发环境
```bash
export PATH=$PATH:/usr/local/cuda/bin/
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
```

#### 自定义函数
- **`ppp()`**: 启用 HTTP 代理 (192.168.217.99:7893)
- **`noppp()`**: 禁用 HTTP 代理
- **`comfyui()`**: 启动 ComfyUI (AI 图像生成工具)

#### 别名配置
- **`gg`**: 快速测试网络连接 (`curl www.google.com`)
- **`config`**: Git bare repository 管理 dotfiles

### 2. `.condarc` - Conda 配置

配置了 Conda 包管理器的中国镜像源以加速下载：

```yaml
channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  - defaults
show_channel_urls: true
solver: libmamba        # 使用更快的依赖解析器
```

### 3. `passion.zsh-theme` - 自定义主题

提供了一个功能丰富的 ZSH 主题，包含：
- 实时时间显示
- 当前目录路径
- Git 状态指示
- 命令执行时间统计
- 跨平台支持（Linux/macOS）

## 🚀 全新 Linux 系统配置步骤

### 前置依赖安装

#### 1. 更新系统并安装基础工具
```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git zsh vim build-essential

# CentOS/RHEL/Rocky Linux
sudo yum update -y
sudo yum groupinstall -y "Development Tools"
sudo yum install -y curl wget git zsh vim
```

#### 2. 安装 ZSH 并设置为默认 Shell
```bash
# 安装 ZSH（如果未安装）
sudo apt install zsh  # Ubuntu/Debian
# 或
sudo yum install zsh   # CentOS/RHEL

# 设置 ZSH 为默认 shell
chsh -s $(which zsh)
# 注销并重新登录使更改生效
```

#### 3. 安装 Oh My Zsh 框架
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### 4. 安装必需的 ZSH 插件
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting  
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

#### 5. 安装 Miniconda/Anaconda（可选）
```bash
# 下载 Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh

# 按照提示完成安装，选择安装到 /home/用户名/miniconda3
```

#### 6. 安装 CUDA（如需要 GPU 计算）
```bash
# 下载并安装 CUDA Toolkit（以 CUDA 11.8 为例）
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
sudo sh cuda_11.8.0_520.61.05_linux.run
```

### 配置部署步骤

#### 方法一：一键安装脚本（最简单）
```bash
# 下载并运行安装脚本
curl -fsSL https://raw.githubusercontent.com/Parallelopiped/MyDotfiles/master/install.sh | bash

# 或者下载后执行
wget https://raw.githubusercontent.com/Parallelopiped/MyDotfiles/master/install.sh
chmod +x install.sh
./install.sh
```

#### 方法二：使用 Git Clone（推荐）
```bash
# 1. 克隆本仓库
git clone https://github.com/Parallelopiped/MyDotfiles.git ~/dotfiles-temp

# 2. 备份现有配置文件（如果存在）
cp ~/.zshrc ~/.zshrc.backup 2>/dev/null || true
cp ~/.condarc ~/.condarc.backup 2>/dev/null || true

# 3. 复制配置文件到用户目录
cp ~/dotfiles-temp/.zshrc ~/
cp ~/dotfiles-temp/.condarc ~/
cp -r ~/dotfiles-temp/.oh-my-zsh/themes ~/.oh-my-zsh/

# 4. 清理临时文件
rm -rf ~/dotfiles-temp
```

#### 方法三：使用 Git Bare Repository（高级用户）
```bash
# 1. 初始化 bare repository
git clone --bare https://github.com/Parallelopiped/MyDotfiles.git $HOME/.cfg

# 2. 创建配置别名
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# 3. 禁用未跟踪文件显示
config config --local status.showUntrackedFiles no

# 4. 检出配置文件
config checkout

# 如果有冲突，备份现有文件后重试
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} {}.backup
config checkout
```

### 个人化配置修改

#### 1. 修改用户路径
编辑 `~/.zshrc`，将以下路径修改为你的用户名：
```bash
# 原配置（需要修改）
__conda_setup="$('/home/zlt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# 修改为
__conda_setup="$('/home/你的用户名/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"

# 其他路径也需要相应修改
. "/home/你的用户名/miniconda3/etc/profile.d/conda.sh"
export PATH="/home/你的用户名/miniconda3/bin:$PATH"
alias config='/usr/bin/git --git-dir=/home/你的用户名/.cfg/ --work-tree=/home/你的用户名'
```

#### 2. 代理设置（可选）
如果不需要代理功能，可以注释掉或修改代理地址：
```bash
# 修改代理地址为你的代理服务器
ppp () {
    export http_proxy=http://你的代理地址:端口
    export https_proxy=$http_proxy
    echo "HTTP Proxy on"
}
```

#### 3. ComfyUI 配置（可选）
如果不使用 ComfyUI，可以删除或修改该函数：
```bash
comfyui () {
    conda activate sd
    python /home/你的用户名/project/ComfyUI/main.py --listen 你的IP地址 --cuda-device 1
}
```

### 应用配置
```bash
# 重新加载配置文件
source ~/.zshrc

# 或重启终端
```

## 📖 使用说明

### 基本命令
```bash
# 测试网络连接
gg

# 启用/禁用代理
ppp      # 启用代理
noppp    # 禁用代理

# 管理 dotfiles（如果使用 bare repository 方法）
config status
config add .zshrc
config commit -m "更新配置"
config push
```

### Conda 环境管理
```bash
# 创建新环境
conda create -n 环境名 python=3.9

# 激活环境
conda activate 环境名

# 安装包（使用配置的中国镜像源）
conda install numpy pandas
```

### 主题特性
- 显示当前时间
- 显示当前目录路径
- Git 仓库状态指示
- 命令执行时间统计
- 命令执行状态指示（成功/失败）

## 🔍 故障排除

### 常见问题

1. **主题显示异常**
   ```bash
   # 检查主题文件是否存在
   ls -la ~/.oh-my-zsh/themes/passion.zsh-theme
   
   # 重新设置主题
   echo 'ZSH_THEME="passion"' >> ~/.zshrc
   source ~/.zshrc
   ```

2. **插件加载失败**
   ```bash
   # 检查插件是否正确安装
   ls -la ~/.oh-my-zsh/custom/plugins/
   
   # 重新安装缺失的插件
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   ```

3. **Conda 初始化失败**
   ```bash
   # 重新初始化 conda
   ~/miniconda3/bin/conda init zsh
   source ~/.zshrc
   ```

4. **CUDA 环境变量无效**
   ```bash
   # 检查 CUDA 安装
   nvcc --version
   nvidia-smi
   
   # 确认路径是否正确
   ls -la /usr/local/cuda/bin/nvcc
   ```

## 📝 自定义和扩展

### 添加新的别名
在 `~/.zshrc` 文件末尾添加：
```bash
# 自定义别名
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
```

### 添加新的环境变量
```bash
# 添加到 ~/.zshrc
export MY_CUSTOM_VAR="value"
export PATH="$PATH:/your/custom/path"
```

### 修改主题
你可以编辑 `~/.oh-my-zsh/themes/passion.zsh-theme` 来自定义主题外观，或选择使用其他主题：
```bash
# 在 ~/.zshrc 中修改
ZSH_THEME="robbyrussell"  # 或其他主题名
```

## 📄 许可证

本项目遵循 MIT 许可证。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这些配置文件。

---

## 📄 English Summary

This repository contains a comprehensive set of Linux dotfiles for configuring ZSH shell environment with Oh My Zsh framework, Conda package manager, and development tools.

### Quick Setup
1. Install prerequisites: `zsh`, `git`, `curl`, `wget`
2. Install Oh My Zsh: `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
3. Install required plugins (zsh-autosuggestions, zsh-syntax-highlighting)
4. Clone and apply configurations from this repository
5. Customize paths and settings for your system

### Key Features
- **ZSH Configuration**: Custom passion theme, useful plugins, aliases
- **Conda Integration**: Chinese mirror sources for faster downloads  
- **CUDA Environment**: Pre-configured CUDA paths and variables
- **Proxy Management**: Functions for easy proxy on/off switching
- **Git Integration**: Enhanced git commands and dotfiles management

*For detailed instructions, see the Chinese documentation above.*

---

*Last Updated: 2024*