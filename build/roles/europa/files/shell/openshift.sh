function os() {
    if [[ "$1" == "--help" ]]; then
		___print_os_usage
	else
		case "$1" in
			on) ___os_on ;;
			off) ___os_off ;;
			restart) ___os_restart ;;
			tidy) ___os_tidy ;;
			status) ___os_status ;;
			*) ___print_os_usage ;;
		esac
	fi
}

function ___os_on() {
    running=$(systemctl status openshift | grep -c running)
    os_home="/usr/local/openshift/default"
    if [[ "$running" == "1" ]]; then
        echo -e "${GREEN}OpenShift is already running!. Nothing to do.${NC}"
    else
        echo -e "${GREEN}Deploying OpenShift services, please wait...${NC}"
        sudo systemctl start openshift
        path="$PWD"
        cd "$os_home"
        while [ ! -f "$os_home/openshift.local.config/master/admin.kubeconfig" ]
        do
          sleep 1
        done
        sudo sh os-setup-login.sh
        sudo sh os-create-registry.sh
        sudo sh os-create-router.sh
        sudo sh os-create-router.sh
        sudo sh os-add-templates.sh
        cd $path
    fi
}

function ___os_off() {
    os_home=/usr/local/openshift/default
    running=$(systemctl status openshift | grep -c running)
    if [[ "$running" == "0" ]]; then
      echo -e "${GREEN}OpenShift is not running!. Nothing to do.${NC}"
    else
      sudo sh $os_home/os-cleanup.sh
    fi
}

function ___os_restart() {
    ___os_off
    ___os_on
}

function ___os_tidy() {
    docker ps -a | grep -i exited | grep k8s | awk '{print $1}' | xargs docker rm
}

function ___os_status() {
    running=$(systemctl status openshift | grep -c running)
    if [[ "$running" == "0" ]]; then
      echo -e "${GREEN}OpenShift is ${CYAN}NOT RUNNING${GREEN}...${NC}"
    else
      echo -e "${GREEN}OpenShift is ${CYAN}RUNNING${GREEN}...${NC}"
    fi
}

function ___print_os_usage() {
    echo -e "${GREEN}Usage:"
	echo -e "${CYAN}  os on: ${GREEN} starts OpenShift."
	echo -e "${CYAN}  os off: ${GREEN} stops OpenShift."
	echo -e "${CYAN}  os restart: ${GREEN} stops, cleans up and starts OpenShift. ${CYAN}All existing containers will be removed!${NC}"
	echo -e "${CYAN}  os status: ${GREEN} prints OpenShift running status.${NC}"
	echo -e "${CYAN}  os tidy: ${GREEN} removes any 'Exited' Kubernetes containers.${NC}"
}