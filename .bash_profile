if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

# config for keyou
alias reload="source ~/.bash_profile"
_bash_projects_=~/.bash_projects
function load {
	local name=$1
	local value=$(pwd)
	local data="$name=$value"
	printf "  load \e[1;34m${data%=*}\e[m = ${data#*=}\n"
	if [ ! -f $_bash_projects_ ];then echo '#!/bin/bash' >> $_bash_projects_; fi
	echo  ____${data%=*}=\"${data#*=}\" >> $_bash_projects_
	reload
}
function unload {
	vi $_bash_projects_
}
function ____ls {
	set -o posix
	set | grep ^____* | sed "s/____//;s/'//g" |\
	awk -F '=' '{ printf "\033[1;34m  %-10s \033[m%-40s\n", $1, $2 }'
}
function ____align {
	local fill='.............'
	printf "%s%s%s\n" "$1" "${fill:${#1}}" "$2"
}

function go { 
	reload
	if [ -z $1 ]; then 
		____ls;
	else
		eval local dir=\$____$1
		if [ ! -d "$dir" ]; then ____ls; 
		else cd "$dir";
		fi
	fi
}

____go_complete() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    #opts="win en3 breakpad"
	set -o posix
	opts=$(set | grep ^____* | sed "s/____//" | awk -F '=' '{ printf $1 " " }')
    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
        return 0
    fi
}
complete -F ____go_complete go

if [ -f $_bash_projects_ ];then . $_bash_projects_; fi

#echo cmds: \e[1;34m load , go ,unload

