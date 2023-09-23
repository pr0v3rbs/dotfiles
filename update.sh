# update
cd ~/.fzf && git pull && ./install
cd ~/.vim/bundle/vim-nightfly && git checkout colors/nightfly.vim && git pull
cd ~/.vim/bundle/syntastic && git pull
cd ~/.vim/bundle/vim-airline && git pull
cd ~/.vim/pack/airblade/start/vim-gitgutter && git pull
cd ~/.vim/pack/preservim/start/tagbar && git pull

# setup
cp ~/.vim/bundle/vim-nightfly/autoload/airline/themes/nightfly.vim \
  ~/.vim/bundle/vim-airline/autoload/airline/themes/

sed -i "s/Search guibg=bg/Search guibg=DarkCyan/g" \
  ~/.vim/bundle/vim-nightfly/colors/nightfly.vim
