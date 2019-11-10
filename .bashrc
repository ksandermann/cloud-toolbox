######################################################## AUTOCOMPLETION ################################################

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
source <(kubectl completion bash)
echo "kubectl bash completion installed!"
source <(helm completion bash)
echo "helm bash completion installed!"
source <(oc completion bash)
echo "oc bash completion installed!"
terraform -install-autocomplete
echo "terraform bash completion installed!"

######################################################## SOURCE ########################################################
sleep 1
if [ -f "/root/.autoexec.sh" ]; then
    source /root/.autoexec.sh
fi

echo "/root/.bashrc loaded successfully!"
