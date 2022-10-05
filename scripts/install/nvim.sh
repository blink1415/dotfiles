/* Set up neovim */
git clone git@github.com:AstroNvim/AstroNvim.git ~/.config/dotfiles/configs/neovim/astro
mkdir ~/.config/dotfiles/configs/neovim/astro/lua/user
ln -s ~/.config/dotfiles/configs/neovim/astro ~/.config/dotfiles/configs/neovim/astro
ln -s ~/.config/dotfiles/configs/neovim/init.lua ~/.config/dotfiles/configs/neovim/astro/lua/user/init.lua


ln -s ~/.config/dotfiles/

cp ~/.config/dotfiles/reference_files/.* ~
