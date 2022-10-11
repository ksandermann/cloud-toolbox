######################################################## AUTOCOMPLETION ################################################

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
if [ -f /usr/local/bin/kubectl ] ; then
  source <(kubectl completion bash)
  echo "kubectl bash completion installed!"
fi
if [ -f /usr/local/bin/helm ] ; then
  source <(helm completion bash)
  echo "helm bash completion installed!"
fi
if [ -f /usr/local/bin/oc ] ; then
  source <(oc completion bash)
  echo "oc bash completion installed!"
fi
if [ -f /usr/local/bin/terraform ] ; then
  terraform -install-autocomplete
  echo "terraform bash completion installed!"
fi

######################################################## SOURCE ########################################################
sleep 1
if [ -f "/root/.autoexec.sh" ]; then
    source /root/.autoexec.sh
fi

echo "/root/.bashrc loaded successfully!"
