```
$ pip install ansible-builder
```

```
$ ansible-builder build \
    --container-runtime docker \
    --verbosity 3 \
    --tag=ansible-runner-gcloud:latest
```