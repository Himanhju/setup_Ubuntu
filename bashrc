# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# Code I Added
clear
alias python="python3"
alias steam="steam&"
alias qemu="qemu-system-x86_64"
LDFLAGS=" -lglfw -lSDL2 -lSDL2_ttf -lGL -lm -lc "
cosm() {
  #.asm compiler
  # cosm -c *.asm *.c
  if [[ "$1" == "" ]]; then
    echo "Usage: cosm \"filename\"";
    echo "";
    echo "Usage: cosm -c \"asm filename\" \"c filename\"";
  fi
  if [[ "$1" == "-c" ]]; then
    mv ${2%.*}.asm ${2%.*}.s &&\
    nasm -f elf64 -o asm.o ${2%.*}.s &&\
    gcc -w -c ${3%.*}.c -o c.o &&\
    ld -w -o ${3%.*} c.o asm.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 $LDFLAGS &&\
    rm c.o &&\
    rm asm.o;
    mv ${2%.*}.s ${2%.*}.asm;
    return 0;
  fi
  nasm -f elf64 "$1" -o output.o &&\
  ld -m elf_x86_64 -o ${1%.*} -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -w output.o $LDFLAGS &&\
  rm output.o &&\
  return 0 ||\
  return 1;
}
chdir() {
    mkdir "$1" && cd "$1";
}
run(){
    if [[ "$1" == *.py ]] then
        python3 "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.js ]] then
        node "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.c ]] then
        gcc "$1" -o output && ./output && rm output && return 0 || return 1;
    fi
    if [[ "$1" == *.cpp || "$1" == *.c++ ]] then
        g++ "$1" -o output && ./output && rm output && return 0 || return 1;
    fi
    if [[ "$1" == *.jav ]] then
        javac "$1" -o output.class && class output.class && rm output.class && return 0 || return 1;
    fi
    if [[ "$1" == *.go ]] then
        go build "$1" -o output && ./output && rm output && return 0 || return 1;
    fi
    if [[ "$1" == *.rs ]] then
        rustc "$1" -o output && ./output && rm output && return 0 || return 1;
    fi
    if [[ "$1" == *.rb ]] then
        ruby "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.asm ]] then
      if [[ "$2" == "-c" ]]; then
        mv ${3%.*}.asm ${3%.*}.s &&\
        nasm -f elf64 -o asm.o ${4%.*}.s &&\
        gcc -w -c ${4%.*}.c -o c.o $LDFALGS &&\
        gcc -w c.o asm.o -o ${4%.*} $LDFALGS &&\
        rm c.o &&\
        rm asm.o;
        mv ${2%.*}.s ${2%.*}.asm;
        return 0;
      fi
      nasm -f elf64 "$1" -o output.o && ld -w -m elf_x86_64 -o outt -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 output.o $LDFALGS && rm output.o && ./outt && rm outt && return 0 || return 1;
    fi
    if [[ "$1" == *.php ]] then
        php "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.sh ]] then
        chmod +x "$1" && ./"$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.class ]] then
        java "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.html ]] then
        xdg-open "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.css ]] then
        xdg-open "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.mp4 ]] then
        xdg-open "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.mp3 ]] then
        xdg-open "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.deb ]] then
        xdg-open "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.exe ]] then
        wine "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.bat ]] then
        xdg-open "$1" && return 0 || return 1;
    fi
    if [[ "$1" == *.cmd ]] then
        xdg-open "$1" && return 0 || return 1;
    fi
    # add more file types here






    if [[ "$1" = "" ]] || [[ "$1" = " " ]] then
        echo "Usage: run [Options] [file]" &&\
        echo "" &&\
        echo "-h,   --help              Display this help message" &&\
        return 1;
    fi
    if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]] then
        echo "Usage: run [Options] [file]" &&\
        echo "" &&\
        echo "-h,   --help              Display this help message" &&\
        return 0;
    fi
    if [[ -x "$1" ]] then
        ./"$1" && return 0;
    fi
    echo "The ${1##*.} file type is not supported for run";
    return 1;
}
cmpl(){
    if [[ "$1" == *.py ]] then
        echo "python doesn't need to be compiled, use \"python3/run 'filename'.py\" to run it" && return 1;
    fi
    if [[ "$1" == *.js ]] then
        echo "JavaScript doesn't need to be compiled, use \"node/run 'filename'.js\" to run it" && return 1;
    fi
    if [[ "$1" == *.c ]] then
        gcc "$1" -o ${1%.*};
        echo "use \"./${1%.*}\" to run it";
        return 0;
    fi
    if [[ "$1" == *.cpp || "$1" == *.c++ ]] then
        g++ "$1" -o ${1%.*};
        echo "use \"./${1%.*}\" to run it";
        return 0;
    fi
    if [[ "$1" == *.jav ]] then
        javac "$1" -o ${1%.*}.class;
        echo "use \"java ${1%.*}.class\" to run it";
        return 0;
    fi
    if [[ "$1" == *.go ]] then
        go build "$1" -o ${1%.*};
        echo "use \"./${1%.*}\" to run it";
        return 0;
    fi
    if [[ "$1" == *.rs ]] then
        rustc "$1" -o ${1%.*};
        echo "use \"./${1%.*}\" to run it";
        return 0;
    fi
    if [[ "$1" == *.rb ]] then
        echo "Ruby doesn't need to be compiled, use \"ruby/run 'filename'.rb\" to run it" && return 0 || return 1;
    fi
    if [[ "$1" == *.asm ]] then
        cosm ${1};        
        echo "use \"./${1%.*}\" to run it"
        return 0;
    fi
    if [[ "$1" == *.php ]] then
        echo "PHP doesn't need to be compiled, use \"php/run 'filename'.php\" to run it" && return 0 || return 1;
    fi
    if [[ "$1" == *.sh ]] then
        chmod +x "$1" && return 0 || return 1;
        echo "use \"./$1\" to run it"
        return 0;
    fi
    # add more file types here






    if [[ "$1" = "" ]] || [[ "$1" = " " ]] then
        echo "Usage: cmpl [Options] [file]" &&\
        echo "" &&\
        echo "-h,   --help              Display this help message" &&\
        return 1;
    fi
    if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]] then
        echo "Usage: cmpl [Options] [file]" &&\
        echo "" &&\
        echo "-h,   --help              Display this help message" &&\
        return 0;
    fi
    echo "Error: The ${1##*.} file type is not supported for cmpl";
    return 1;
}
mov(){
    cp "$1" "$2" &&\
    rm "$1" &&\
    return 0 ||\
    return 1;:
}
. "$HOME/.cargo/env"
