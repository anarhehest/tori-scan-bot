#!/bin/sh

IMAGE="tori-scan-bot"
CONTAINER="tori-scan"

source .env*

exists() {
    local type=$1
    local name=$2
    local command="ls"
    local keys=""
    local format=""

    case $type in
        "image")
            keys="--format"
            format="{{.Repository}}"
            ;;
        "container")
            keys="-a --format"
            format="{{.Image}}"
            ;;
    esac

    return `docker $type $command $keys $format | grep -q $name`
}

if ! exists image ${IMAGE} ; then
    docker build -t ${IMAGE} .
fi

if ! exists container ${IMAGE} ; then
    docker run -d --name ${CONTAINER} -e TOKEN=${TOKEN} ${IMAGE}
fi

docker logs -f ${CONTAINER}
