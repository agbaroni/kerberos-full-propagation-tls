
```

cd tls

buildah build -t tls .

podman run --name tls --rm --volume $PWD/artifacts:/tmp/artifacts tls

```