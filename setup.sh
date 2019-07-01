#!/usr/bin/env bash

# finder tweaks

echo "Setting column view as default"
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

echo "Show file extensions"
defaults write -g AppleShowAllExtensions -bool true

echo "Show file extenstions"
defaults write com.apple.finder AppleShowAllFiles true

echo "Show ~/Library"
chflags nohidden ~/Library

echo "New finder windows open in home dir"
defaults read com.apple.finder NewWindowTargetPath -string "file:///Users/cunderw"

echo "Hide mounted volumes from desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo "Show preview pane"
defaults write com.apple.finder ShowPreviewPane -bool true
defaults write com.apple.finder PreviewPaneWidth -int 172

echo "Show connected servers in finder"
defaults delete com.apple.sidebarlists networkbrowser
defaults write com.apple.sidebarlists networkbrowser -array-add '<dict><key>CustomListItems</key><array/><key>CustomListProperties</key><dict><key>com.apple.NetworkBrowser.connectedEnabled</key><true/><key>com.apple.NetworkBrowser.bonjourEnabled</key><false/><key>com.apple.NetworkBrowser.backToMyMacEnabled</key><true/></dict><key>Controller</key><string>CustomListItems</string></dict>'

echo "Expand save panel by default"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Keep folders At Top When Sorting By Name."
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "Disable naturual scroll"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
echo "You may have to logout and log back in for this change to take effect."

echo "Allow Applications to be installed from anywhere"
sudo spctl --master-disable

echo "Disable The 'Are You Sure You Want To Open This Application? Dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Save screenshots as PNGs"
defaults write com.apple.screencapture type -string "png"

echo "Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36

echo "Automaticall hide and show dock"
defaults write com.apple.dock autohide -bool true

echo "Top left screen corner → Mission Control"
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0

echo "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "Restarting finder and dock to apply changes"
killall Finder
rm ~/Library/Application\ Support/Dock/*.db
killall Dock

echo "Xcode setup"
xcode-select --install

echo "Installing homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

declare -a taps=(
    'buo/cask-upgrade'
    'caskroom/cask'
    'caskroom/versions'
    'homebrew/bundle'
    'homebrew/core'
)

for tap in "${taps[@]}"; do
    echo "Tapping $tap"
    brew tap "$tap"
done

brew upgrade && brew update

echo "Installing Cask"
brew install cask

declare -a cask_apps=(
  ‘1password’
  ‘bartender’
  ‘visual-studio-code’
  ‘gitkraken’
  ‘iterm2’
  ‘postman’
  ‘slack’
)

for app in "${cask_apps[@]}"; do
    echo "Installing $app"
    brew cask install "$app"
done

echo "Installing ZSH"
brew install zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting

echo "Installing Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Copying dot files"
cp ./zsh/zshrc ~/.zshrc
cp ./vim/vimrc ~/.vimrc
cp ./nano/nanorc ~/.nanorc

echo "Sourcing zshrc"
source ~/.zshrc