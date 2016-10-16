function c() {
    if [[ "$1" == "--help" ]]; then
		___print_c_usage
	else
		case "$1" in
			ip) ___c_ip $2 ;;
			*) ___print_c_usage ;;
		esac
	fi
}

function ___c_ip() {
    if [ "$1" == "?" ] || [ -z "$1" ]; then
        ___print_c_usage
    else
        docker inspect --format '{{.NetworkSettings.IPAddress}}' $1
    fi
}

function ___print_c_usage() {
    echo -e "${GREEN}Usage:"
	echo -e "${CYAN}  c ip <container name>: ${GREEN} shows the IP of the named container.${NC}"
}