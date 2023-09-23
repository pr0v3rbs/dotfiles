# requirements

sudo apt install tmux git curl vim

# download
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
  curl -LSso ~/.vim/autoload/pathogen.vim \
  https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

git clone https://github.com/bluz71/vim-nightfly-guicolors \
  ~/.vim/bundle/vim-nightfly

git clone --depth=1 https://github.com/vim-syntastic/syntastic.git \
  ~/.vim/bundle/syntastic

git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline

mkdir -p ~/.vim/pack/airblade/start
git clone --depth=1 https://github.com/airblade/vim-gitgutter \
  ~/.vim/pack/airblade/start/vim-gitgutter

mkdir -p ~/.vim/pack/preservim/start
git clone --depth=1 https://github.com/preservim/tagbar \
  ~/.vim/pack/preservim/start/tagbar

# setup
cp ~/.vim/bundle/vim-nightfly/autoload/airline/themes/nightfly.vim \
  ~/.vim/bundle/vim-airline/autoload/airline/themes/

sed -i "s/Search guibg=bg/Search guibg=DarkCyan/g" \
  ~/.vim/bundle/vim-nightfly/colors/nightfly.vim

vim -u NONE -c "helptags vim-gitgutter/doc" -c q
