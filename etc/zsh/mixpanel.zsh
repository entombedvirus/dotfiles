###################################################################
# ADDED FOR MIXPANEL.
[ -r ~/env/bin/activate ] && source ~/env/bin/activate # starts the virtualenv when you log in
# Various Mixpanel services use MP_ENV_TYPE to set their configuration.
# Product engineers generally set it to "dev" here. Systems engineers generally leave it unset.
# export MP_ENV_TYPE=dev

export VAULT_TOKEN=58d07566-6d4a-9a73-bb25-54476fa0278e
