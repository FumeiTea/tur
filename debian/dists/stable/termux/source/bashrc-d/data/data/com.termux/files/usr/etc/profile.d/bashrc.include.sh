BASHRC_D=$PREFIX/etc/bashrc.d

L_bashrc=(
  ${BASHRC_D}/bashrc.alias
  ${BASHRC_D}/bashrc.env
  ${BASHRC_D}/bashrc.job
  ${BASHRC_D}/bashrc.tmp
  ${BASHRC_D}/bashrc.bind
)

for bashrc in ${L_bashrc[@]} ;do
  [ -r $bashrc ] && . $bashrc && declare -f succ &> /dev/null && succ -- include $bashrc:$0
done

pgrep sshd &>/dev/null && succ -- sshd $(whoami)

