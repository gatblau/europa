function cip() {
    if [ "$1" == "?" ] || [ -z "$1" ]; then
        ___print_cip_usage
    else
        docker inspect --format '{{.NetworkSettings.IPAddress}}' $1
    fi
}

function ___print_cip_usage() {
    echo -e "${GREEN}Usage:"
	echo -e "${CYAN}  cip <container name>: ${GREEN} shows the IP of the named container.${NC}"
}