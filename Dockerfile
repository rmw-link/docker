SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive 
ENV TERM xterm-256color
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

ENV TZ=Asia/Shanghai
ENV CARGO_HOME /opt/rust
ENV RUSTUP_HOME /opt/rust
#ENV RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup
#ENV RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
#apt-get clean &&\
#apt-get autoclean &&\
COPY os/root/.cargo /root/.cargo

RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list &&\
apt-get update &&\
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime &&\
echo $TZ > /etc/timezone &&\
apt-get install -y zlib1g-dev tzdata python3 sudo curl wget python3-pip tmux openssh-client openssh-server zsh language-pack-zh-hans rsync mlocate git g++ python3-dev gist less util-linux apt-utils lua5.3 ctags htop tree cron python-dev libpq-dev postgresql-client bsdmainutils libssl-dev libreadline-dev libbz2-dev libsqlite3-dev libffi-dev liblzma-dev direnv iputils-ping dstat software-properties-common neovim golang zstd pixz jq git-extras aptitude clang-format &&\
locale-gen zh_CN.UTF-8 &&\
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
passwd -d root &&\
chsh -s /bin/zsh root &&\
ln -s /usr/bin/pip3 /usr/bin/pip &&\
pip install glances yapf pylint supervisor python-language-server &&\
ln -s /usr/bin/gist-paste /usr/bin/gist &&\
rm -rf /etc/ssh/ssh_host_* &&\
cd /usr/local && wget https://raw.githubusercontent.com/junegunn/fzf/master/install -O fzf.install.sh && bash ./fzf.install.sh && rm ./fzf.install.sh && cd ~ &&\
curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path &&\
cd $CARGO_HOME &&\
ln -s ~/.cargo/config . &&\
source $CARGO_HOME/env &&\
cargo install ripgrep cargo-cache exa sd fd-find tokei diskus --root /usr/local &&\
cargo-cache --remove-dir git-repos,registry-sources &&\
echo 'PATH=/opt/rust/bin:$PATH' >> /etc/profile.d/path.sh


SHELL ["/bin/zsh", "-c"]


# 不 passwd -d 这样没法ssh秘钥登录，每次都要输入密码 

RUN \
git clone https://github.com/asdf-vm/asdf.git ~/.asdf &&\
cd ~/.asdf &&\
git checkout "$(git describe --abbrev=0 --tags)" &&\
. ~/.asdf/asdf.sh &&\
asdf plugin add python &&\
python_version=$(asdf list all python|rg "^[\d\.]+$"|tail -1) &&\
asdf install python $python_version &&\
asdf global python $python_version &&\
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple &&\
pip install ipython xonsh virtualenv pynvim &&\
asdf plugin add nodejs &&\
~/.asdf/plugins/nodejs/bin/import-release-team-keyring &&\
nodejs_version=$(asdf list all nodejs|tail -1)&&\
asdf install nodejs $nodejs_version &&\
asdf global nodejs $nodejs_version &&\
asdf plugin add yarn &&\
yarn_version=$(asdf list all yarn|tail -1) &&\
asdf install yarn $yarn_version &&\
asdf global yarn $yarn_version &&\
asdf reshim &&\
yarn config set registry https://registry.npm.taobao.org &&\
yarn config set prefix ~/.yarn &&\
yarn global add neovim npm-check-updates coffeescript node-pre-gyp &&\
asdf reshim &&\
update-alternatives --install /usr/bin/python python /usr/bin/python3 1 


COPY os/root /root

RUN \
mkdir -p ~/.zplugin &&\
git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin --depth=1 &&\
git clone --depth=1 https://github.com/romkatv/gitstatus.git ~/.gitstatus &&\ 
cat /root/.zplugin.zsh|rg "program|load|source|light"|zsh &&\
source ~/.zplugin/plugins/romkatv---powerlevel10k/gitstatus/install 

COPY os/usr/share/nvim /usr/share/nvim
COPY os/etc/vim /etc/vim

RUN \
git clone https://github.com/Shougo/dein.vim --depth=1 /etc/vim/repos/github.com/Shougo/dein.vim &&\
vim +"call dein#install()" +qall &&\
vim +'call dein#update()' +qall &&\ 
vim +'CocInstall -sync coc-json coc-yaml coc-css coc-python coc-vetur coc-tabnine' +qa

WORKDIR /
COPY os .
COPY boot .

RUN mv /root /.sync/ && updatedb


CMD ["/etc/rc.local"]

