# lighthouse/chromium/alpine/docker image

**Run Google's Lighthouse headless in the background**

This image allows you to quickly run [lighthouse](https://github.com/GoogleChrome/lighthouse) in a headless container and upload the result to Github gists. That's useful if you want to run it from a CI server, or in the background of your workstation.

## Installation

Github URL: <https://github.com/invia-de/lighthouse-chromium-alpine-docker>

```shell
    git clone git@github.com:invia-de/lighthouse-chromium-alpine-docker.git
    docker build -t lighthouse lighthouse-chromium-alpine-docker
```

## Github Credentials

You need to create a .git-credentials file to make sure gists is working. The file needs to look like this:

```
https://username:token@github.com
```

## Usage

Processes within the container cannot easily access the host's file system. You can either print to STDOUT and redirect to a file, or mount a local folder in the container, as shown here:

### Quickstart

```shell
docker run --mount type=bind,source=$(pwd)/output,destination=/home/lighthouse/output -it --privileged lighthouse https://google.com
```

## Links

Canonical URL: <https://matthi.coffee/2017/lighthouse-chromium-headless-docker>
