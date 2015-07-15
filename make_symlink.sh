#!/bin/bash - 
#===============================================================================
#
#          FILE: test.sh
# 
#         USAGE: ./test.sh 
# 
#   DESCRIPTION: Create symblinks from the home directory to any desired in ~/dotfiles
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 07/15/15 12:27
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
dir=~/dotfiles
olddir=~/dotfiles_old
files="bashrc vimrc vim zshrc oh-my-zsh"    #list of files/folders to symlink in homedir

#create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~..."
mkdir -p $olddir
echo "done"

@change to the dotfiles directory
echo -n "Changing to the $dir directory..."
cd $dir
echo "done"

#move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfils_old
    echo "Creating symlink to $file in home directory"
    ln -s $dir/$file ~/.$file
done


install_zsh () {
#Test to see if zshell is installed. If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    #Clone my oh-my-zsh repository from Github only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git
    fi
    #Set the default shell to zsh if it isn't currently set to zsh
    if [[ !(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    #If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, tray an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo yum install zsh
        install_zsh
    fi
    if [[ -f /etc/debian_version ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh
