```
$ pip install ansible-builder
```

```
$ ansible-builder build \
    --container-runtime docker \
    --verbosity 3 \
    --context . \
    --tag=ansible-runner-gcloud:latest
```


```
$ docker run -e ZONE=$ZONE -e PROJECT=$PROJECT -e HOSTNAME=$HOSTNAME -ti --rm --entrypoint /bin/bash docker.io/dennydgl1/ansible-runner-gcloud:11.0 
# gcloud auth login
# cd /home/runner/
# ./scripts/gcp-ssh-wrapper.sh \
    --tunnel-through-iap \
    --zone=$ZONE \
    --no-user-output-enabled \
    --quiet \
    --strict-host-key-checking=no \
    --project=$PROJECT \
    -o StrictHostKeyChecking=no \
    -o KbdInteractiveAuthentication=no \
    -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey \
    -o PasswordAuthentication=no \
    -o 'User="ansible"' \
    -o ConnectTimeout=10 \
    $HOSTNAME '/bin/sh -c '"'"'whoami'"'"''
```


```
# ansible all -i $HOSTNAME, -m ping
````


```
# ansible-playbook -i $HOSTNAME, test.yaml 
```