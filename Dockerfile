SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

ENV TZ=Asia/Shanghai
ENV CARGO_HOME /opt/rust
ENV RUSTUP_HOME /opt/rust
#ENV RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup
#ENV RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
#apt-get clean &&\
#apt-get autoclean &&\
#COPY os/root/.cargo /root/.cargo

# 官方的neovim没编译python，所以用neovim-ppa/unstable

RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list &&\
apt-get update &&\
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime &&\
echo $TZ > /etc/timezone &&\
apt-get install -y zlib1g-dev tzdata python3 sudo curl wget python3-pip tmux openssh-client openssh-server zsh language-pack-zh-hans rsync mlocate git g++ python3-dev gist less util-linux apt-utils htop tree cron libpq-dev postgresql-client bsdmainutils libssl-dev libreadline-dev libbz2-dev libsqlite3-dev libffi-dev liblzma-dev direnv iputils-ping dstat software-properties-common zstd pixz jq git-extras aptitude clang-format p7zip-full cmake &&\
locale-gen zh_CN.UTF-8 &&\
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
passwd -d root &&\
chsh -s /bin/zsh root &&\
pip3 install glances black pylint supervisor python-language-server &&\
add-apt-repository -y ppa:neovim-ppa/unstable &&\
apt-get update &&\
apt-get install -y neovim &&\
update-alternatives --install /usr/bin/python python /usr/bin/python3 1 &&\
update-alternatives --set python /usr/bin/python3 &&\
update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 1 &&\
update-alternatives --set vi /usr/bin/nvim &&\
update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 1 &&\
update-alternatives --set vim /usr/bin/nvim &&\
ln -s /usr/bin/gist-paste /usr/bin/gist &&\
rm -rf /etc/ssh/ssh_host_* &&\
cd /usr/local && wget https://raw.githubusercontent.com/junegunn/fzf/master/install -O fzf.install.sh && bash ./fzf.install.sh && rm ./fzf.install.sh && cd ~ &&\
curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path &&\
cd $CARGO_HOME &&\
ln -s ~/.cargo/config . &&\
source $CARGO_HOME/env &&\
cargo install ripgrep atuin cargo-cache exa sd fd-find tokei diskus --root /usr/local &&\
cargo-cache --remove-dir git-repos,registry-sources &&\
cargo-cache -e &&\
echo 'PATH=/opt/rust/bin:$PATH' >> /etc/profile.d/path.sh &&\
rustup default nightly


ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

SHELL ["/bin/zsh", "-c"]


# 不 passwd -d 这样没法ssh秘钥登录，每次都要输入密码

RUN \
git clone https://github.com/asdf-vm/asdf.git ~/.asdf &&\
cd ~/.asdf &&\
git checkout "$(git describe --abbrev=0 --tags)" &&\
. ~/.asdf/asdf.sh &&\
asdf plugin-add lua https://github.com/Stratus3D/asdf-lua.git &&\
asdf install lua latest &&\
asdf global lua latest &&\
asdf plugin add python &&\
asdf install python latest &&\
asdf global python latest &&\
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple &&\
pip3 install ipython xonsh virtualenv pynvim &&\
asdf plugin add nodejs &&\
asdf install nodejs latest &&\
asdf global nodejs latest &&\
npm install -g pnpm rome@next @antfu/ni prettier @prettier/plugin-pug stylus-supremacy yarn && asdf reshim &&\
asdf reshim &&\
yarn config set registry https://registry.npm.taobao.org &&\
yarn config set prefix ~/.yarn &&\
yarn global add neovim npm-check-updates coffeescript node-pre-gyp diff-so-fancy &&\
asdf reshim &&\
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git &&\
asdf install golang latest &&\
asdf global golang latest &&\
asdf reshim &&\
go install github.com/muesli/duf@master &&\
go install github.com/louisun/heyspace

COPY os/root /root

RUN sh -c "$(curl -fsSL https://git.io/zinit-install)"

RUN \
mkdir -p /root/.zinit &&\
cat /root/.zinit.zsh|rg "program|load|source|light"|zsh

COPY os/usr/share/nvim /usr/share/nvim
COPY os/etc/vim /etc/vim

RUN \
curl -fLo /etc/vim/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&\
vi -E -s -u /etc/vim/sysinit.vim +PlugInstall +qa &&\
vi +'CocInstall -sync coc-json coc-yaml coc-css coc-python coc-vetur coc-tabnine coc-svelte' +qa

WORKDIR /
COPY os .
COPY boot .

#RUN mv /root /.sync/

RUN rm -rf /tmp

FROM ubuntu
RUN rm -rf /root
COPY --from=build / /

CMD ["/etc/rc.local"]
