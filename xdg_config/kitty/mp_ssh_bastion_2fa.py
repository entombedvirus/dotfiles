import subprocess
import os
import json

one_password_cli = '/usr/local/bin/op'

sub_domain = 'my'
full_domain = '%s.1password.com' % sub_domain
session_env_var = 'OP_SESSION_%s' % sub_domain

secret_name = 'Mixpanel SSH Bastion'

def main(args):
    # this is the main entry point of the kitten, it will be executed in
    # the overlay window when the kitten is launched
    token = os.environ.get(session_env_var)
    if token is None:
        token = _one_password(None, 'signin', full_domain, '--raw')

    otp = _one_password(token, 'get', 'totp', secret_name)
    answer = {
        'token': token,
        'otp': otp,
    }
    # whatever this function returns will be available in the
    # handle_result() function
    return json.dumps(answer)

def handle_result(args, payload, target_window_id, boss):
    answer = json.loads(payload)

    # save the token in memory of the main process so that we don't have to ask
    # for it again.
    #
    # TODO: handle token expiration?
    token = answer.get('token')
    if token is not None:
        from kitty.child import set_default_env
        set_default_env({session_env_var: token})

    # get the kitty window into which to paste otp
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        w.paste(answer.get('otp'))


def _one_password(token, *args):
    env = os.environ.copy()
    if token:
        env[session_env_var] = token

    proc = subprocess.run(
        [one_password_cli] + list(args),
        env=env,
        text=True,
        capture_output=True,
        check=False,
        )
    return (proc.stdout + proc.stderr).strip()

