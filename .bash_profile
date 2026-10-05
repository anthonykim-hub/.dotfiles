case $- in
    *i*) ;;
      *) return;;
esac

export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTIGNORE="&:c:cd:gd:cta:alias:myup:gst:history:bg:fg:ls:l:ll:lla:la:exit:vim:nvim:pwd:clear:[ \t]*"
export LC_COLLATE='C.UTF-8'
export LESSHISTFILE=-
export IGNOREEOF=2
export TMP=~/tmp
export TEMP=~/tmp

shopt -s histappend
shopt -s checkwinsize
stty -ixon

if [ -L ~/.local/bin/keychain ]; then
    KEYCHAIN_KEYS=(
        ~/.ssh/id_ed25519
    )
    eval "$(keychain add --eval "${KEYCHAIN_KEYS[@]}")"
fi

test -f "$HOME/.bashrc" && . "$HOME/.bashrc"
test -f "$HOME/.local/bin/env" && . "$HOME/.local/bin/env"
test -f "$HOME/.cargo/env" && . "$HOME/.cargo/env"
