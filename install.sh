#!/bin/sh

BASHRC=".bashrc";
BASHRC_D=".bashrc.d";
HOME_BASHRC="$HOME/$BASHRC";
HOME_BASHRC_D="$HOME/$BASHRC_D";

usage () {
  echo "Usage: $(basename "$0") [OPTIONS]";
  echo "Options:";
  echo "  -n: New install.";
  echo "  -c: Rollback to previous install.";
  echo "  -u: Update files in $HOME_BASHRC_D.";
}

copy_files () {
  echo "Copying files from $BASHRC_D into $HOME_BASHRC_D.";
  cp -rv "$BASHRC_D" "$HOME";
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


run () {
  case "$1" in
    -n)
      copy_files;
      save_current_bachrc;
      update_current_bashrc;
      ;;
    -c)
      delete_files;
      restore_previous_bashrc;
      ;;
    -u)
      copy_files;
      ;;
    *)
      usage;
      ;;
  esac
}

run "$*";

echo "Refreshing terminal";
exec bash;