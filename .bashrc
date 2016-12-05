# .bashrc

#
# Author   : Shriram V
# Email    : shri314@yahoo.com
# Comments : bashrc
#

# Source global definitions
if [ -f /etc/bashrc ]
then
   . /etc/bashrc
fi

shopt -s cdspell

ulimit -c unlimited

if [ "$DISPLAY" == "" ]
then
   export DISPLAY=localhost:0.0
fi

if [ "${XAUTHORITY}" ]
then
   PS1THRESHOLD=4
   export BACKGROUND=light
else
   PS1THRESHOLD=1
fi

if [ "$SHLVL" -gt "$PS1THRESHOLD"  ]
then
   PS1POSTFIX="["$(expr $SHLVL - $PS1THRESHOLD)"]"
else
   PS1POSTFIX=""
fi

if [ "$RUNONCE" = "" ]
then
   #This is run only once!
   export LANG=en_US
   export RUNONCE=1
   export FIX_PATH=".:$HOME/.usr/local/bin:$HOME/.local/bin:/sbin:/usr/sbin:$PATH"
   export FIX_LD_LIBRARY_PATH=".:$HOME/.usr/local/lib:$HOME/.local/lib:$LD_LIBRARY_PATH"
   export FIX_MANPATH="$HOME/.local/man:$(manpath)"

   if [ "$OS" = "Windows_NT" ]
   then
      export FIX_PATH=".:/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:/sbin:/usr/sbin:/cygdrive/c/Program Files/Internet Explorer:$PATH"
   else
      export TEMP=/tmp/
   fi
fi

# System Variable Initialization
export FIX_PATH_1=:~/.bin:~/.Scripts/bin:~/.Scripts/mkutils:~/.Scripts/bzutils:~/.Scripts:$FIX_PATH:/usr/local/sbin:/usr/sbin
export PATH="$FIX_PATH_1"
export LD_LIBRARY_PATH=$FIX_LD_LIBRARY_PATH
export CDPATH=:..:$MYCDPATH
export MANPATH=$FIX_MANPATH

export SEARCH_PATH=",,.,..,./include,../include,./src,../src,~/.local/include,/usr/local/include,/usr/include/g++-3,/usr/include"
export HOSTFILESIZE=300000
export HISTSIZE=30000
export HOSTNAME="$(hostname)"
export UQHOSTNAME=$(hostname | sed -e 's/[.].*//')
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:';
export EDITOR='vim -fX'
export PS1='\n\[\e[32m\]\u@\h \[\e[33m\]$PWD\[\e[0m\] [\[\e[35m\]\D{%I:%M:%S %p}\[\e[0m\]] \[\e[33m\]\jj\[\e[1;36m\]$( $(declare -F __git_ps1 || echo "echo -n") )\[\e[0m\]\n${PS1POSTFIX}\[\e[1;36m\]${PS1POSTFIX2}\[\e[0m\]\$ '
export PS1SEARCH="$ "
export GIT_SSH="$HOME/.Scripts/_git_ssh"

alias ls='ls -h --color=tty'
alias ll='ls -h -l --color=tty'
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias grep='grep --color'
alias egrep='egrep --color'
alias less='less -R'
alias indent='indent -bli0 -cli0 -i3'
alias nm='nm --print-file-name --demangle'
alias make='_make'
alias gdb='gdb --tui'
alias gcc='gcc -fmessage-length=0'
alias g++='g++ -fmessage-length=0'
alias ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o CheckHostIP=no -o ServerAliveInterval=100'
alias scp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o CheckHostIP=no -o ServerAliveInterval=100'
alias vi='vim -fX'
alias vim='vim -fX'
alias bperl='perltidy -i=3 -nt -fnl -anl -bl -l=250 -bbs -bbc -bbb -mbl=2'
alias astyle='_astyle'
alias man='man -a -S2:3:1:8:5:4:6:7:9'
alias top='top -d 1'
alias pstree='pstree -Gah'

_LoadENV()
{
   #Usage: - Add _LoadENV to PROMPT_COMMAND inside your .bashrc.custom
   #
   #PROMPT_COMMAND="_LoadENV <proj1.dir.basename> <proj1.rel-env-script-path>; $PROMPT_COMMAND";
   #PROMPT_COMMAND="_LoadENV <proj2.dir.basename> <proj2.rel-env-script-path>; $PROMPT_COMMAND"; 

   local MODULE="$1"; shift
   local ENVFILE="$1"; shift
   local TYPE="$1"; shift

   if [ "$LOADED_MODULE" ] && [ "$LOADED_MODULE" != "$MODULE" ]
   then
      return
   fi

   local MODULE_DIR="$(echo "$PWD/" | sed -n -e 's@\(/[^._-]*[._-]\?\<'"$MODULE"'\>[._-]\?[^/]*\)/.*@\1@ip')"

   if [ "$MODULE_DIR" ]
   then
      if [ "$LOADED_MODULE" != "$MODULE" ]
      then
         if [ "$LOADED_MODULE_DIR" == "" ] && [ -f "$MODULE_DIR/${ENVFILE}" ]
         then
            LOADED_MODULE="$LOADED_MODULE"
            LOADED_MODULE_DIR="$LOADED_MODULE_DIR"
            PS1POSTFIX2="$PS1POSTFIX2"

            set | sed \
                     -e '/^_=/d' \
                     -e '/^UID=/d' \
                     -e '/^PWD=/d' \
                     -e '/^PPID=/d' \
                     -e '/^EUID=/d' \
                     -e '/^OLDPWD=/d' \
                     -e '/^FUNCNAME=/d' \
            > /tmp/.$$.$MODULE.env

            env_list()
            {
               alias -p   | sed -n -e '/^alias/s/alias \([^=]*\).*/\1/p'
               declare -F | sed -n -e '/^declare/s/declare .. \([^=]*\).*/\1/p'
               declare -x | sed -n -e '/^declare/s/declare .. \([^=]*\).*/\1/p'
            }

            env_list | sort > /tmp/.$$.$MODULE.env.L

            echo "bash: SOURCING ENV from $MODULE_DIR/${ENVFILE}"
            source "$MODULE_DIR/${ENVFILE}"
            hash -r

            LOADED_MODULE="$MODULE"
            LOADED_MODULE_DIR="$MODULE_DIR"
            PS1POSTFIX2="($LOADED_MODULE)"
         fi
      fi
   else
      if [ "$LOADED_MODULE" ]
      then
         local MODULE=$LOADED_MODULE

         echo "bash: RESTORING ENV before loading $LOADED_MODULE"

         for i in $(\diff <(env_list | sort) /tmp/.$$.$MODULE.env.L | sed -ne '/^< /s/..//p'); do unalias "$i" 2>&-; unset "$i" 2>&-; done
         source /tmp/.$$.$MODULE.env 2>/dev/null
         ls /tmp/.*.env* | grep -f <(pgrep 'ba[s]h') -v | xargs rm -f
         \rm -f /tmp/.$$.$MODULE.env{,.L}
      fi
   fi
}

chexp()
{
   echo -n sudo chmod $(stat "$1" | sed -n -e '/^Access:/s@Access: *(\(....\).*$@\1@p') "\"$1\" ; " #(
   echo    sudo chown $(stat "$1" | sed -n -e '/^Access:/s@.*Uid: *([^/]*/ *\([^)]*\)).*Gid: *([^/]*/ *\([^)]*\))@\1.\2@p') "\"$1\" ; "
}

Swap12()
{
   exec 3>&1
   exec 1>&2
   exec 2>&3
   exec 3>&-
}

# http://code-worrier.com/blog/autocomplete-git/
if [ -f ~/.git-completion.bash ]
then
  . ~/.git-completion.bash
fi

# http://code-worrier.com/blog/git-branch-in-bash-prompt/
if [ -f ~/.git-prompt.sh ]
then
  export GIT_PS1_SHOWUPSTREAM=verbose
  export GIT_PS1_SHOWCOLORHINTS=true
  export GIT_PS1_SHOWDIRTYSTATE=true
  #export GIT_PS1_SHOWSTASHSTATE=true
  #export GIT_PS1_DESCRIBE_STYLE=describe
  #export GIT_PS1_SHOWUNTRACKEDFILES=true
  #export GIT_PS1_STATESEPARATOR=" "

  . ~/.git-prompt.sh
fi

if [ -f ~/.handle_ssh ]
then
   . ~/.handle_ssh
fi

if [ -f ~/.handle_screen ]
then
   . ~/.handle_screen
fi

if [ -f ~/.bashrc.custom ]
then
   . ~/.bashrc.custom
fi
