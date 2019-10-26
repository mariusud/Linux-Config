# Options
shopt -s cdspell;
shopt -s checkwinsize;
shopt -s autocd;

# History
shopt -s histappend;
shopt -s histreedit;

HISTSIZE=5000;
HISTFILESIZE=10000
HISTIGNORE="&:ls:la:ll:l:s:sl:cd:c:d:fg:clear:exit:exiit:m:q:x:gl:gs";
HISTCONTROL="ignoreboth";
HISTTIMEFORMAT="%F %T ";


if [ -d "$HOME/.bashrc.d/scripts" ]; then
    export PATH="$PATH:$HOME/.bashrc.d/scripts";
fi
