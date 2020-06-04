#@IgnoreInspection BashAddShebang
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(ansible aws git helm kops kubectl oc terraform)

source $ZSH/oh-my-zsh.sh

######################################################## SOURCE ########################################################
sleep 1
if [ -f "/root/.autoexec.sh" ]; then
    source /root/.autoexec.sh
fi
