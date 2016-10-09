#!/bin/bash

DOCKER_IMAGE=mistersimon

DOCKER_RUN="docker run --volume=$(pwd)/jekyll:/src/ -p 4000:4000 ${DOCKER_IMAGE}"
HTML_PROOFER_CMD="htmlproofer ./_site --only-4xx --disable-external --empty-alt-ignore"

COPY=(assets img _posts)
COPY_LENGTH=${#COPY[@]}

function help {
    echo "Options"
    echo "build - Build docker image"
    echo "serve - Run jekyll in docker"
    echo "c9 - Run jekyll on c9 platform"
    echo "proof - Run proofer"
}

function copy {
    for(( i=0; i<${COPY_LENGTH}; i = i + 1));
    do
    cp -r -u ${COPY[$i]} ./jekyll
    done
}

function c9 {
	if [ "$1" == "install" ] ; then
		(cd jekyll && bundle install)
	elif [ "$1" = "serve" ] ; then
		(cd jekyll && bundle exec jekyll serve --host $IP --port $PORT --baseurl '')
	elif [ "$1" = "check" ] ; then
        (cd jekyll && bundle exec  ${HTML_PROOFER_CMD})
	fi
}
function build {
    docker build -t ${DOCKER_IMAGE} .
}

function serve {
    copy
    ${DOCKER_RUN}
}

function check {
    ${DOCKER_RUN} ${HTML_PROOFER_CMD}
}

if [ "$#" -eq 0 ] ; then
    help
elif [ "$1" = "build" ] || [ "$1" = "help" ] || [ "$1" = "-h" ] ; then
    build
elif [ "$1" = "serve" ] ; then
    serve
elif [ "$1" = "check" ] ; then
    check
elif [ "$1" = "c9" ] ; then
    c9 $2
fi
