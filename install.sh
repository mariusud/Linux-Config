#!/bin/sh

BASHRC=".bashrc";
BASHRC_D=".bashrc.d";
GITCONFIG="gitconfig";
HOME_BASHRC="$HOME/$BASHRC";
HOME_BASHRC_D="$HOME/$BASHRC_D";

usage () {
  echo "Options:";
  echo " ./install.sh -u: Undo install";
}

copy_files () {
  echo "Copying files from $BASHRC_D into $HOME_BASHRC_D.";
  cp -rv "$BASHRC_D" "$HOME";
  cp -rv "$GITCONFIG" "$HOME/.gitconfig";
}

delete_files (){
  if [ -d "$HOME_BASHRC_D" ]; then
    echo "Deleting files from $HOME_BASHRC_D.";
    rm -vrf "$HOME_BASHRC_D";
  fi
}

save_current_bachrc () {
  if [ -f "$HOME_BASHRC" ]; then
    echo "Saving previous $BASHRC.";
    cp -v "$HOME_BASHRC" "$HOME_BASHRC.save_$(date +"%Y%m%d%H%M%S")";
  else
    echo "No $BASHRC found in $HOME. Creating new one.";
    cp -v "$BASHRC" "$HOME_BASHRC";
  fi
}

update_current_bashrc () {
  echo "Updating current $BASHRC.";
  { echo "" ; echo "# Custom part." ; echo ". $HOME_BASHRC_D/init.sh"; } >> "$HOME/$BASHRC";
}

restore_previous_bashrc () {
  LAST=$(find "$HOME" -maxdepth 1 -name $BASHRC.save* -print0  | xargs -0 ls -1 -t | head -1);
  if [ -f "$LAST" ]; then
    echo "Most recent save is: $LAST.";
    cp -vf "$LAST" "$HOME_BASHRC";
    echo "Current $HOME_BASHRC replaced by $LAST.";
  else
    echo "There is no previous .bashrc.";
  fi
}

install_packages() {
  wget https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb;
    sudo apt install gdebi tldr glances;
    sudo gdebi bat_0.11.0_amd64.deb;
    rm bat_0.11.0_amd64.deb; 
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

setup_git() {
  if [[ $EUID -eq 0 ]]; then
   echo "This script must not be run as root" 
   exit 1
  fi
 
  echo "Enter email address: "
  read MAIL
  echo "Enter user name: "
  read NAME

  git config --global user.name $NAME
  git config --global user.email $MAIL

  ssh-keygen -t rsa -b 4096 -C $MAIL
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  echo "SSH key:"
  echo 
  cat ~/.ssh/id_rsa.pub

}

run () {
  case "$1" in
    *)
      install_packages;
      copy_files;
      save_current_bachrc;
      update_current_bashrc;
      setup_git;
      usage;
      ;;
    -u)
      delete_files;
      restore_previous_bashrc;
      ;;
  esac
}


run "$*";

echo "Refreshing terminal";
exec bash;