#!/bin/bash

set -eux

# Build script for Travis-CI.

SCRIPTDIR=$(cd $(dirname "$0") && pwd)
ROOTDIR="$SCRIPTDIR/../.."
WHISKDIR="$ROOTDIR/../openwhisk"

export OPENWHISK_HOME=$WHISKDIR

IMAGE_PREFIX=$1
RUNTIME_VERSION=$2
IMAGE_TAG=$3

if [ ${RUNTIME_VERSION} == "8" ]; then
  RUNTIME="nodejs8"
elif [ ${RUNTIME_VERSION} == "10" ]; then
  RUNTIME="nodejs10"
fi

if [[ ! -z ${DOCKER_USER} ]] && [[ ! -z ${DOCKER_PASSWORD} ]]; then
docker login -u "${DOCKER_USER}" -p "${DOCKER_PASSWORD}"
fi

if [[ ! -z ${RUNTIME} ]]; then
TERM=dumb ./gradlew \
${RUNTIME}:distDocker \
-PdockerRegistry=docker.io \
-PdockerImagePrefix=${IMAGE_PREFIX} \
-PdockerImageTag=${IMAGE_TAG}
fi
