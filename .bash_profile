case $- in
    *i*) ;;
      *) return;;
esac

if [ -x ~/.local/bin/starship ]; then
    eval "$(starship init bash)"
else
    export PS1='\n\[\033[01;34m\]\w\[\033[00m\]\n\n\$ '
fi

HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:erasedups:ignorespace
HISTIGNORE="&:cd:gd:cta:alias:myup:gst:history:bg:fg:ls:l:ll:lla:la:exit:vim:nvim:pwd:clear:[ \t]*"
export LC_COLLATE='C.UTF-8'
export LESSHISTFILE=-

shopt -s histappend
shopt -s checkwinsize
stty -ixon

if [ -x /usr/bin/keychain ]; then
    eval $(/usr/bin/keychain --eval --agents ssh id_ed25519)
fi

test -f "$HOME/.bashrc" && . "$HOME/.bashrc"
test -f "$HOME/.local/bin/env" && . "$HOME/.local/bin/env"
test -f "$HOME/.cargo/env" && . "$HOME/.cargo/env"
