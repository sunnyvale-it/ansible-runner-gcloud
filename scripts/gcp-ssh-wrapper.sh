#!/bin/bash
# This is a wrapper script allowing to use GCP's IAP SSH option to connect
# to our servers.
#set -x
# Ansible passes a large number of SSH parameters along with the hostname as the
# second to last argument and the command as the last. We will pop the last two
# arguments off of the list and then pass all of the other SSH flags through
# without modification:
host="${@: -2: 1}"
cmd="${@: -1: 1}"
project=$(echo "$3" | cut -d "=" -f 2)

# Unfortunately ansible has hardcoded ssh options, so we need to filter these out
# It's an ugly hack, but for now we'll only accept the options starting with '--'
declare -a opts
for ssh_arg in "${@: 1: $# -3}" ; do
        if [[ "${ssh_arg}" == --* ]] ; then
                opts+="${ssh_arg} "
        fi
done

export CLOUDSDK_PYTHON_SITEPACKAGES=1

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="${GCE_CREDENTIALS_FILE_PATH}"

echo "ansible:$(/usr/bin/ssh-add -L)" > /tmp/google_compute_engine.pub

gcloud auth activate-service-account --key-file=$CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE --quiet 

gcloud compute project-info --project ${project} add-metadata --metadata-from-file=ssh-keys=/tmp/google_compute_engine.pub

exec /usr/bin/ssh -o ControlMaster=auto -o ControlPersist=60s -o LogLevel=ERROR -t -C -A -o ProxyUseFdpass=no -o HostKeyAlias=host1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="/home/runner/google-cloud-sdk/platform/bundledpythonunix/bin/python3 /home/runner/google-cloud-sdk/lib/gcloud.py compute start-iap-tunnel ${host} %p --listen-on-stdin --no-user-output-enabled --quiet $opts" ansible@"${host}" -- "${cmd}"

exit 0