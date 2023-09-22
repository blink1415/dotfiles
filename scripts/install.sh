#!/bin/bash

if [ ! -d "~/.config/dotfiles" ] 
then
    echo "The repository must be cloned to ~/.config/dotfiles" 
    exit 1
fi

cd ~/.config/dotfiles

# Dependencies
echo "Cargo is required for the nvim version manager. Installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Homebrew is required for the shell and multiplexer. Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install nvim version manager
cargo install --git https://github.com/MordechaiHadad/bob.git
bob use latest

export PATH="$PATH:/Users/nikolai/.local/share/bob/nvim-bin"

ln -s ~/.config/dotfiles/configs/neovim ~/.config/nvim

# Shell and terminal multiplexer
brew install zsh -y
brew install tmux -y

echo "source ~/.config/dotfiles/configs/zsh/.zshrc" > ~/.zshrc
echo "source ~/.config/dotfiles/configs/tmux/.tmux.conf" > ~/.tmux.conf
