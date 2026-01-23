export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)"/rootCA.pem
export GOTOOLCHAIN=auto
export TF_DEFAULT_ROLE="engineer"
export AWS_PROFILE="devtools-engineer"
export PATH=~/work/sierra/bin:$PATH

export SIERRA_ROOT="$HOME/work/sierra"
source $SIERRA_ROOT/.shell/shellenv

alias dsql='docker exec -it dynamodb sqlite3 /home/dynamodblocal/data/shared-local-instance.db 2>/dev/null'
