sudo apt install zsh;
sudo apt install tmux;
cp ./reference_files/ $HOME/;


# nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

# Optional: exposing nvim globally.
mv squashfs-root /
ln -s /squashfs-root/AppRun /usr/bin/nvim
nvim


git clone https://github.com/AstroNvim/AstroNvim.git ./nvim-astro
ln -s ./nvim-astro ~/.config/nvim
