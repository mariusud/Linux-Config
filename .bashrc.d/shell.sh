# Options
shopt -s cdspell;
shopt -s checkwinsize;
shopt -s autocd;

# History
shopt -s histappend;
shopt -s histreedit;

HISTSIZE=5000;
HISTFILESIZE=10000;
HISTCONTROL="ignoreboth";
HISTTIMEFORMAT="%F %T ";


if [ -d "$HOME/.bashrc.d/scripts" ]; then
    export PATH="$PATH:$HOME/.bashrc.d/scripts";
fi
