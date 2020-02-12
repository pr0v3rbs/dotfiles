# download
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

git clone https://github.com/bluz71/vim-nightfly-guicolors \
        ~/.vim/bundle/vim-nightgly

git clone --depth=1 https://github.com/vim-syntastic/syntastic.git \
        ~/.vim/bundle/syntastic

git clone https://github.com/vim-airline/vim-airline \
        ~/.vim/bundle/vim-airline

# setup
cp .vim/bundle/vim-nightfly/autoload/lightline/colorscheme/nightfly.vim \
        .vim/bundle/lightline.vim/autoload/lightline/colorscheme/

sed -i "s/Search guibg=bg/Search guibg=DarkCyan/g" \
        .vim/bundle/vim-nightfly/colors/nightfly.vim
