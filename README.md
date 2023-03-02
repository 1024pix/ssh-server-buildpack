# ssh-server-buildpack

## Build 

```sh
export BUILD_DIR=$(mktemp -d)

docker run --pull always \                                            
 --rm --interactive --tty \
 -e STACK=scalingo-20 \
 -v $(pwd):/buildpack  -v $BUILD_DIR:/build/ -u 10000:10000 \
 scalingo/scalingo-20:latest bash

/buildpack/bin/compile /build /tmp/cache /tmp/env
```


## Usage 
Start ssh in foreground on the procfile : 

```
tcp: start-ssh-server.sh
```