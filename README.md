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