######################################################## SSH KEYS ######################################################

eval $(ssh-agent -s)

for key in $(ls /root/.ssh/ | grep -v -E  ".pub|known_hosts|config|.iml" )
do
	ssh-add "/root/.ssh/$key"
done

######################################################## ALIASES #######################################################

#GENERIC
alias getpubip ="curl https://ipinfo.io/ip"


#KUBECTL CLI

##generic
alias ksn='kubectl config set-context $(kubectl config current-context) --namespace '
alias klo='kubectl logs -f'

##get single
alias kgpo='kubectl get pods'
alias kgno='kubectl get nodes'
alias kging='kubectl get ingress'
alias kgsvc='kubectl get service'
alias kgpvc='kubectl get pvc'
alias kgdep='kubectl get deployment'
alias kgsc='kubectl get storageclass'
alias kgpv='kubectl get pv'
alias kgss='kubectl get statefulset'
alias kgr='kubectl get role'
alias kgsa='kubectl get serviceAccounts'
alias kgrb='kubectl get rolebindings'
alias kgcr='kubectl get clusterroles'
alias kgcrb='kubectl get clusterrolebindings'
alias kgsec='kubectl get secret'
alias kgcm='kubectl get configmap'

##get all
alias kgpoall='kubectl get pods --all-namespaces'
alias kgingall='kubectl get ingress --all-namespaces'
alias kgsvcall='kubectl get service --all-namespaces'
alias kgpvcall='kubectl get pvc --all-namespaces'
alias kgscall='kubectl get storageclass --all-namespaces'
alias kgpvall='kubectl get pv --all-namespaces'
alias kgdepall='kubectl get deployment --all-namespaces'
alias kgssall='kubectl get statefulset --all-namespaces'
alias kgrall='kubectl get role --all-namespaces'
alias kgsaall='kubectl get serviceAccounts --all-namespaces'
alias kgrball='kubectl get rolebindings --all-namespaces'
alias kgsecall='kubectl get secret --all-namespaces'
alias kgsecall='kubectl get secret --all-namespaces'
alias kgcmall='kubectl get configmap --all-namespaces'

##describe single
alias kdpo='kubectl describe pods'
alias kdno='kubectl describe nodes'
alias kding='kubectl describe ingress'
alias kdpv='kubectl describe pvc'
alias kdcr='kubectl describe clusterrole'
alias kdcrb='kubectl describe clusterrolebinding'
alias kdsvc='kubectl describe service'
alias kdpvc='kubectl describe pvc'
alias kdsc='kubectl describe storageclass'
alias kdpv='kubectl describe pv'
alias kddep='kubectl describe deployment'
alias kdss='kubectl describe statefulset'
alias kdr='kubectl describe role'
alias kdsa='kubectl describe serviceAccounts'
alias kdrb='kubectl describe rolebindings'
alias kdsec='kubectl describe secret'
alias kdcm='kubectl describe configmap'


#OPENSHIFT CLI

##generic
alias ocsn='oc project '
alias oclo='oc logs -f'

##get single
alias ocgpo='oc get pods'
alias ocgno='oc get nodes'
alias ocging='oc get ingress'
alias ocgsvc='oc get service'
alias ocgpvc='oc get pvc'
alias ocgdep='oc get deployment'
alias ocgsc='oc get storageclass'
alias ocgpv='oc get pv'
alias ocgss='oc get statefulset'
alias ocgr='oc get role'
alias ocgsa='oc get serviceAccounts'
alias ocgrb='oc get rolebindings'
alias ocgcr='oc get clusterroles'
alias ocgcrb='oc get clusterrolebindings'
alias ocgsec='oc get secret'
alias ocgcm='oc get configmap'

##get all
alias ocgpoall='oc get pods --all-namespaces'
alias ocgingall='oc get ingress --all-namespaces'
alias ocgsvcall='oc get service --all-namespaces'
alias ocgpvcall='oc get pvc --all-namespaces'
alias ocgscall='oc get storageclass --all-namespaces'
alias ocgpvall='oc get pv --all-namespaces'
alias ocgdepall='oc get deployment --all-namespaces'
alias ocgssall='oc get statefulset --all-namespaces'
alias ocgrall='oc get role --all-namespaces'
alias ocgsaall='oc get serviceAccounts --all-namespaces'
alias ocgrball='oc get rolebindings --all-namespaces'
alias ocgsecall='oc get secret --all-namespaces'
alias ocgsecall='oc get secret --all-namespaces'
alias ocgcmall='oc get configmap --all-namespaces'

##describe single
alias ocdpo='oc describe pods'
alias ocdno='oc describe nodes'
alias ocding='oc describe ingress'
alias ocdpv='oc describe pvc'
alias ocdcr='oc describe clusterrole'
alias ocdcrb='oc describe clusterrolebinding'
alias ocdsvc='oc describe service'
alias ocdpvc='oc describe pvc'
alias ocdsc='oc describe storageclass'
alias ocdpv='oc describe pv'
alias ocddep='oc describe deployment'
alias ocdss='oc describe statefulset'
alias ocdr='oc describe role'
alias ocdsa='oc describe serviceAccounts'
alias ocdrb='oc describe rolebindings'
alias ocdsec='oc describe secret'
alias ocdcm='oc describe configmap'

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

sleep 1
echo "/root/.bashrc loaded succesfully!"