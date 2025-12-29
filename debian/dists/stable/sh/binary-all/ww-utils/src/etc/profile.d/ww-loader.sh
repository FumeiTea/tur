#!/bin/bash

get_rootfs_prefix(){
    [[ "${PREFIX:-}" == *"/com.termux/"* && -d "$PREFIX" ]] && echo "$PREFIX"
}

loader-sh(){
  local _ROOT=$(get_rootfs_prefix)
  source $_ROOT/opt/sh/$1
}


# ==========================================
# loader-sh 的自动补全配置
# ==========================================
_loader_sh_autocomplete() {
  # 获取当前光标所在的单词
  local cur="${COMP_WORDS[COMP_CWORD]}"

  (( "$COMP_CWORD" > 1 )) && return

  # 动态获取脚本存放目录 (逻辑与 loader-sh 保持一致)
  local _search_root="/opt/sh"
  # 判断 Termux 环境
  if [[ "${PREFIX:-}" == *"/com.termux/"* ]]; then
      _search_root="$PREFIX/opt/sh"
  fi

  # 如果目录不存在，直接返回
  [[ -d "$_search_root" ]] || return

  # 获取文件列表并处理
  local script_list=$(ls "$_search_root" 2>/dev/null)

  # 生成补全建议
  # compgen -W: 根据提供的单词列表和当前输入 ($cur) 进行匹配
  COMPREPLY=( $(compgen -W "$script_list" -- "$cur") )
}

complete -F _loader_sh_autocomplete loader-sh


# vim: set filetype=sh:
