# Steps to reproduce

## Prerequsites
1. Make sure you have Docker installed locally
2. Clone this repository and `cd` to its folder

## TEST 1: local build
1. Run build command
`docker build --no-cache --progress plain . `

Expected result: 
- image is build succesfully
- 'npx prisma generate' command does not produce any "prisma:fetch-engine:download file ..." records in log

## TEST 2: build using Docker-in-Docker
1. Run DIND container with current directory mounted into it at /prisma-demo
`docker run --privileged -d -v $(pwd):/prisma-demo --name dind docker:26.1.4-dind`

2. Enter into DIND container
`docker exec -it dind /bin/sh`

3. Change directory to /prisma-demo
`cd /prisma-demo`

4. Run build command as in TEST 1
`docker build --no-cache --progress plain . `

Expected result: the same as in TEST 1

## TEST 3: build using Gitlab CI pipeline

Push this repository in GitLab and see the CI pipeline log

Expected result:
- image build failed
- 'npx prisma generate' command produces the logs similar to the following:
```
#12 [7/8] RUN DEBUG="*" npx prisma generate
#12 2.333 prisma:cli:bin Failed to initialize the command state: Error: ENOENT: no such file or directory, open '/root/.config/prisma-nodejs/commands.json' +1013ms
#12 2.336 prisma:config:loadConfigFromFile No config file found in the current working directory /foo +404ms
#12 2.342 prisma:engines binaries to download libquery-engine, schema-engine +1015ms
#12 2.352 prisma:get-platform Found distro info:
#12 2.352 {
#12 2.352   "targetDistro": "musl",
#12 2.352   "familyDistro": "alpine",
#12 2.352   "originalDistro": "alpine"
#12 2.352 } +10ms
#12 2.353 prisma:get-platform Don't know any platform-specific paths for "alpine" on x64 (x86_64) +1ms
#12 2.353 prisma:get-platform Falling back to "ldconfig" and other generic paths +0ms
#12 2.373 prisma:get-platform Found libssl.so file using "ldconfig" or other generic paths: libssl.so.3 +20ms
#12 2.373 prisma:get-platform The parsed libssl version is: 3.0.x +0ms
#12 2.376 prisma:fetch-engine:download file /foo/node_modules/@prisma/engines/libquery_engine-linux-musl-openssl-3.0.x.so.node does not exist and must be downloaded +3ms
#12 2.377 prisma:fetch-engine:download file /foo/node_modules/@prisma/engines/schema-engine-linux-musl-openssl-3.0.x does not exist and must be downloaded +1ms
#12 2.379 prisma:fetch-engine:download https://binaries.prisma.sh/all_commits/2060c79ba17c6bb9f5823312b6f6b7f4a845738e/linux-musl-openssl-3.0.x/libquery_engine.so.node.gz will be downloaded to /foo/node_modules/@prisma/engines/libquery_engine-linux-musl-openssl-3.0.x.so.node +2ms
#12 2.380 prisma:fetch-engine:download https://binaries.prisma.sh/all_commits/2060c79ba17c6bb9f5823312b6f6b7f4a845738e/linux-musl-openssl-3.0.x/schema-engine.gz will be downloaded to /foo/node_modules/@prisma/engines/schema-engine-linux-musl-openssl-3.0.x +1ms
#12 2.381 prisma:fetch-engine:download Downloading https://binaries.prisma.sh/all_commits/2060c79ba17c6bb9f5823312b6f6b7f4a845738e/linux-musl-openssl-3.0.x/libquery_engine.so.node.gz to /foo/node_modules/@prisma/engines/libquery_engine-linux-musl-openssl-3.0.x.so.node ... +1ms
#12 2.499 prisma:fetch-engine:download Downloading https://binaries.prisma.sh/all_commits/2060c79ba17c6bb9f5823312b6f6b7f4a845738e/linux-musl-openssl-3.0.x/schema-engine.gz to /foo/node_modules/@prisma/engines/schema-engine-linux-musl-openssl-3.0.x ... +118ms
```