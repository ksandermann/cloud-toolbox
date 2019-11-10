######################################################## SSH KEYS ######################################################
eval $(ssh-agent -s)

for key in $(ls /root/.ssh/ | grep -v -E  ".pub|known_hosts|config|.iml" )
do
	ssh-add "/root/.ssh/$key"
done

######################################################## ALIASES #######################################################

#GENERIC
alias getpubip='curl https://ipinfo.io/ip'
alias ksn='kubectl config set-context $(kubectl config current-context) --namespace '

######################################################## MOUNTED CAs ###################################################
update-ca-certificates

echo "$( cd "$(dirname "$0")" ; pwd -P )/.autoexec.sh loaded successfully!"
