#!/usr/bin/env bash

function cip() {
    if [[ "$1" == "?" -o -z "$1" ]]; then
        __print_cip_usage
    else
        docker inspect --format '{{.NetworkSettings.IPAddress}}' $1
    fi
}

function k8s_tidy() {
    if [[ "$1" == "?" ]]; then
        __print_k8stidy_usage
    else
        docker ps -a | grep -i exited | grep k8s | awk '{print $1}' | xargs docker rm
    fi
}

function __print_cip_usage() {
    echo -e "${GREEN}Usage:"
	echo -e "${CYAN}  cip <<container name>>: ${GREEN} shows the IP of the named container.${NC}"
}

function __print_k8stidy_usage() {
    echo -e "${GREEN}Usage:"
    echo -e "${CYAN}  k8s_tidy: ${GREEN} removes all exited kubernetes containers.${NC}"
}