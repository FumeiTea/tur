#!/bin/bash

root="./"

__SH_wlog=0

########


WLOG_RedArrow="\033[31m-->\033[0m"
WLOG_GreenArrow="\033[32m-->\033[0m"
WLOG_YellowArrow="\033[33m-->\033[0m"

wlog(){
    color=''
    content=${@:2}
    echo_content=$content

    [[ $1 =~ ^red ]] && color=31
    [[ $1 =~ ^green ]] && color=32
    [[ $1 =~ ^yellow ]] && color=33
    color_index=( $(echo $1 |awk -F ':' '{$1=""; print $0}') )

    if [[ x$color != x ]] ;
    then if [[ x$color_index != x ]]
	then shift;


	echo_content=$(echo $@ |awk -F ' -- ' -v color=$color -v c=$color_index 'BEGIN{
	    split(c,colorIndArr,":");
	} {
	    for(i=1;i<=NF;i++){
            if(i in colorIndArr){print "\033["color"m"$i"\033[0m "}
            else{print $i" "}
        }
    }')


	else echo_content="\033[${color}m$content\033[0m";
	fi;
    fi;
    echo -e ${echo_content}
}

wlog_type(){
    typeset -f "$1" 1>/dev/null 2>&1 && return 0 || return 1
}

succ(){
    [[ $# == 0 ]] && return 0
    [[ "$1" == '--' ]] && {
        wlog green:1 [ $2 ] -- ${@:3}
    } || wlog green:1 [ success ] -- $@
}

err(){
    [[ $# == 0 ]] && return 1
    [[ "$1" == '--' ]] && {
        wlog red:1 [ $2 ] -- ${@:3}
    } || wlog red:1 [ error ] -- $@
}

signal(){
    [[ $# == 0 ]] && wlog yellow:1 [ signal ] && return 0
    [[ "$1" == '--' ]] && {
        wlog yellow:1 [ $2 ] -- ${@:3}
    } || wlog yellow:1 [ success ] -- $@
}
warning(){
  :
}

wlog_parsing(){
    local i source source target=\"${!#}\"
    for((i=1;i<${#@};i++))
    do
        if [[ "${!i}" =~ [*~] ]]; then
            source=$source' '"${!i}"
        else
            [[ "${!i}" =~ ^-{1,2}[a-z]*$ ]] &&
            local paras=$paras' '${!i} ||
            source=$source' '\""${!i}"\"
        fi
    done
    echo $paras "$source" $target
}


wlog_cp(){
    local all=($(wlog_parsing "$@"))
    eval cp "${all[@]}" && {
        all[-1]=" --> ${all[-1]}"
        succ -- cp ${all[@]}
    }
}

wlog_mv(){
    local all=($(wlog_parsing "$@"))
    eval mv "${all[@]}" && {
        all[-1]=" --> ${all[-1]}"
        succ -- mv ${all[@]}
    }
}

wlog_ln(){
local _arrs= _arrs_ln= _arr= _Create_NotExist= _err=
_arrs=$@
_arrs_ln=${_arrs#* -- }
_arrs=($(getopt -o h -l help,ec -- ${_arrs%%"-- *"} ))
for _arr in ${_arrs[@]}; do
    case $_arr in
        -h | --help ) ;;
        --ec )
            _Create_NotExist=0
            ;;
        -- ) ;;
        * )
            ;;
    esac
done

while read -t1 -a line; do
    [[ -n ${line[0]} && -n ${line[1]} ]] || continue
    [[ $_Create_NotExist == 0 ]] && { 
        [[ -e ${line[0]} ]] || wlog_mkdir ${line[0]}
    }
    [[ "$(realpath ${line[0]} )" == "$(readlink ${line[1]})" ]] && continue
    _err=$(ln $_arrs_ln ${line[0]} ${line[1]} 2>&1) && succ -- ln $_arrs_ln ${line[0]} ${line[1]} || err -- ln $_arrs_ln ${line[0]} ${line[1]} " $WLOG_RedArrow " $_err
done
}

#wlog_ln(){
#    local paras i source target
#    _arrs="$( echo "$@" |awk -F '--' '{print $2}' )"
#    _arrs_ln="$( echo "$@" |awk -F ' -- ' '{print $1}' )"
#    return
#    [[ $1 =~ ^-[a-zA-Z]*$ ]] && paras=$1 && shift
#    for((i=1;i<=$#;i++))
#    do
#        [[ $((i%2)) == 1 ]] && source=$(realpath ${!i})
#        if [[ $((i%2)) == 0 ]]; then 
#        [[ ! -e $source ]] && {
#            err -- ln file $source does not exist
#            #i+=1
#            #echo aaaa
#            continue
#        }
#            target=${!i}
#            target_dir=$(dirname $target)
#	    if [[ ${target: -1} == '@' ]]; then
#		    echo ln $paras $source $target_dir/.ln.tmp && mv $target_dir/.ln.tmp ${target:0:${#target}-1}
#		    ln $paras $source $target_dir/.ln.tmp && mv $target_dir/.ln.tmp ${target:0:${#target}-1}
#            continue
#	    fi
#            if [[ -f $target ]]; then
#                [[ $(readlink $target) == $source ]] ||err -- ln $source is exited '-->' $(readlink $target)
#                continue
#            fi
#            [[ ! -d $target_dir ]] && mkdir -p $target_dir && succ -- mkdir $target_dir
#            eval ln $paras $source $target && succ -- ln $source '-->' $target
#        fi
#    done
#}

wlog_create(){
    local _tmp _paras

    [[ $1 =~ ^-[a-zA-Z]*$ ]] && _paras=$1 && shift
    for _tmp in $@; do
        [[ -e $_tmp ]] && continue
        [[ ${_tmp: -1} == / ]] && {
            mkdir $_paras $_tmp && succ -- mkdir $_paras $_tmp
        } || {
            touch $_paras $_tmp && succ -- touch $_paras $_tmp
        }
    done
}

#?wlog_mkdir:help
<<@
    
@
#?wlog_mkdir:help
wlog_mkdir(){
    local _arrs=$@ _err=
    _err=$(mkdir ${_arrs%%--*} 2>&1) && succ -- mkdir $_paras "$@" || err -- mkdir ${_arrs%%--*} " $WLOG_RedArrow " $_err
}


if [[ $0 == "$BASH_SOURCE" ]]; then
    #echo $BASH_SOURCE $0
    get-help -h --uncomment
else
    succ -- include $BASH_SOURCE:$0
fi

#?:help
#@    [succ|err|signal] [--|prompt] content
#@    wlog_[cp|mv|ln|type|create]
#?:help
