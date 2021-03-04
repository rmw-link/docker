#!/usr/bin/env bash
set -e

git_clone (){
if [ ! -d "$2" ]; then
git clone $1 $2 --depth=1
fi
}

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR

export DEBIAN_FRONTEND=noninteractive
export TERM=xterm-256color
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8

export TZ=Asia/Shanghai
export CARGO_HOME=/opt/rust
export RUSTUP_HOME=/opt/rust
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static

#  apt-get update
#  apt-get install -y software-properties-common
#  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DBB0BE9366964F134855E2255F96FCF8231B6DD
#  编辑 /etc/apt/sources.list
#  加入 deb http://ppa.launchpad.net/neovim-ppa/stable/ubuntu bionic main
#  add-apt-repository -y ppa:neovim-ppa/stable
#  apt-get update

sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
apt-get update
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
apt-get remove -y vim &&
apt-get install -y zlib1g-dev tzdata python3 sudo curl wget python3-pip tmux openssh-client openssh-server zsh rsync mlocate git g++ python3-dev gist less util-linux apt-utils lua5.3 ctags htop tree cron python-dev libpq-dev postgresql-client bsdmainutils libssl-dev libreadline-dev libbz2-dev libsqlite3-dev libffi-dev liblzma-dev direnv iputils-ping dstat software-properties-common neovim golang zstd pixz jq aptitude git-extras
locale-gen zh_CN.UTF-8
rsync -av $_DIR/os/root/.cargo/ /root/.cargo
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
passwd -d root
chsh -s /bin/zsh root
rm -rf /usr/bin/pip
ln -s /usr/bin/pip3 /usr/bin/pip
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple
pip install yapf flake8 supervisor python-language-server glances
rm -rf /usr/bin/gist
ln -s /usr/bin/gist-paste /usr/bin/gist

if ! hash fzf 2>/dev/null ; then
aptitude update
aptitude install -y fzf
#cd /usr/local && wget https://raw.githubusercontent.com/junegunn/fzf/master/install -O fzf.install.sh && bash ./fzf.install.sh && rm ./fzf.install.sh && cd ~
fi

curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
cd $CARGO_HOME
rm -rf config
ln -s ~/.cargo/config .
source $CARGO_HOME/env
cargo install ripgrep cargo-cache exa sd fd-find tokei diskus --root /usr/local
cargo-cache --remove-dir git-repos,registry-sources
grep -qxF 'PATH=/opt/rust/bin' /etc/profile.d/path.sh || echo 'PATH=/opt/rust/bin:$PATH' >> /etc/profile.d/path.sh

# 不 passwd -d 这样没法ssh秘钥登录，每次都要输入密码

git_clone https://github.com/asdf-vm/asdf.git ~/.asdf


cd ~/.asdf
#git checkout "$(git describe --abbrev=0 --tags)"
. ~/.asdf/asdf.sh
pip install ipython xonsh virtualenv
asdf plugin add nodejs || true
~/.asdf/plugins/nodejs/bin/import-release-team-keyring
nodejs_version=$(asdf list all nodejs|tail -1)
asdf install nodejs $nodejs_version
asdf global nodejs $nodejs_version
asdf plugin add yarn || true
yarn_version=$(asdf list all yarn|tail -1)
asdf install yarn $yarn_version
asdf global yarn $yarn_version
asdf reshim
yarn config set registry https://registry.npm.taobao.org
yarn config set prefix ~/.yarn
npm config set registry https://registry.npm.taobao.org
npm install  --unsafe-perm=true --allow-root --scripts-prepend-node-path -g coffeescript neovim npm-check-updates node-pre-gyp
asdf reshim


rsync -av $_DIR/os/root /

mkdir -p ~/.zplugin
git_clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin

git_clone https://gitee.com/romkatv/gitstatus.git ~/.gitstatus

cat /root/.zplugin.zsh|rg "program|load|source|light"|zsh
zsh ~/.zplugin/plugins/romkatv---powerlevel10k/gitstatus/install

rsync -av $_DIR/os/ /

git_clone https://github.com/Shougo/dein.vim /etc/vim/repos/github.com/Shougo/dein.vim
vim +"call dein#install()" +qall
vim +'call dein#update()' +qall
vim +'CocInstall -sync coc-json coc-yaml coc-css coc-python coc-vetur' +qa

apt-get autoremove -y
apt-get clean -y
apt-get autoclean -y
