#!/bin/bash

# Update the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install required packages (using apt for Ubuntu/Debian as an example)
echo "Installing software..."
sudo apt install -y \
    alacritty \
    stow \
    i3 \
    picom \
    tmux \
    firefox \
    git \
    build-essential \
    curl \
    cmake \
    gettext \
    lua5.1 \
    liblua5.1.0-dev

# Clone the dotfiles repository (if not already cloned)
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
fi

# Stow dotfiles
cd ~/dotfiles
echo "Applying dotfiles with stow..."
stow bash
stow git

# Stow config files (correct paths for hidden .config)
echo "Linking configuration files to ~/.config..."
stow -d ~/dotfiles/config alacritty -t ~/.config
stow -d ~/dotfiles/config i3 -t ~/.config
stow -d ~/dotfiles/config picom -t ~/.config
stow -d ~/dotfiles/config nvim -t ~/.config

# Tmux configuration is directly in home directory (no .config)
echo "Linking tmux configuration to home directory..."
stow -d ~/dotfiles tmux -t $HOME

sleep 10

# Additional setup (optional)
echo "Running additional setup..."
git clone -b v0.10.1 https://github.com/neovim/neovim.git $HOME/personal/neovim
cd $HOME/personal/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

echo "Setup complete!"

