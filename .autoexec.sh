######################################################## SSH KEYS ######################################################
eval $(ssh-agent -s)

for key in $(ls /root/.ssh/ | grep -v -E  ".pub|known_hosts|config|.iml" )
do
	ssh-add "/root/.ssh/$key"
done

######################################################## ALIASES #######################################################

#GENERIC
alias getpubip='curl https://ipinfo.io/ip'

#KUBECTL
alias ksn='kubectl config set-context $(kubectl config current-context) --namespace '
alias kgc='kubectl config get-contexts'
alias ksc='kubectl config use-context '

######################################################## MOUNTED CAs ###################################################
update-ca-certificates

######################################################## UNSET CONTAINER ENV ###########################################
unset TILLER_NAMESPACE

######################################################## DONE ##########################################################
echo "$( cd "$(dirname "$0")" ; pwd -P )/.autoexec.sh loaded successfully!"

