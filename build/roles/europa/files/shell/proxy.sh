#!/usr/bin/env bash
# define output colours
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
function proxy() {
    if [[ "$1" == "-help" ]]; then
		___print_proxy_usage
	else
		case "$1" in
			on) ___proxy_on "$2" ;;
			off) ___proxy_off ; ___load_profile ;;
			clear) ___proxy_clear ; ___load_profile ;;
			status) ___proxy_status ;;
		esac
	fi
}

function ___proxy_on() {
   # if a proxy value has not been passed in
   if [[ -z "${1// }" ]]; then
		# if the proxy variable is not defined in the profile
		if [[ "$(grep -c "http_proxy" ~/.bash_profile)" -eq 0 ]]; then
			echo -e "${RED}Please provide the name and port of the proxy to use."
			echo -e "${GREEN}For example, with the following command: ${CYAN}'proxy on http://proxy-name.com:90'${NC}"
			return
		# if the proxy variable is defined but commented out
		elif [[ "$(grep -c "#export http_proxy=" ~/.bash_profile)" -gt 0 ]]; then
			# uncomment proxy variables
			echo -e "${GREEN}Turning proxy on... ${NC}"
			sed -i -e "/export http_proxy=/s/^#//" ~/.bash_profile
			___uiOn
			___load_profile
		# if the proxy variable is defined and not commented out
		else
			echo -e "${CYAN}Proxy is already on: '${http_proxy}'${NC}"
		fi
   # if a proxy value has been passed in
   else
		# if the proxy variable is defined in the profile
		if [[ ! "$(grep -c "http_proxy" ~/.bash_profile)" -eq 0 ]]; then
			___proxy_clear
		fi
		___proxy_set "$1"
		___load_profile
   fi
}

function ___proxy_off() {
	# if the proxy variable is not defined in the profile
	if [[ "$(grep -c "http_proxy" ~/.bash_profile)" -eq 0 ]]; then
	   	echo -e "${GREEN}No proxy is currently set.${NC}"
	else
		# if the proxy variable is defined but commented out
		if [[ "$(grep -c "#export http_proxy=" ~/.bash_profile)" -gt 0 ]]; then
			echo -e "${CYAN}Proxy is already off.${NC}"
		# if the proxy variable is defined and not commented out
		else
			# comment it out
			echo -e "${GREEN}Turning proxy off... ${NC}"
			sed -i -e "/export http_proxy=/s/^#*/#/" ~/.bash_profile
			unset http_proxy
			unset https_proxy
			unset ftp_proxy
			___uiOff
		fi
	fi
}

function ___proxy_clear() {
	echo -e "${GREEN}Clearing proxy...${NC}"
	while IFS='' read -r line || [[ -n "$line" ]]; do
		if [[ ! "$line" =~ "export http_proxy=" ]]; then
				echo "$line"
		fi
	done < .bash_profile > temp_profile
	mv temp_profile .bash_profile
	unset http_proxy
	unset https_proxy
	unset ftp_proxy
	___uiClear
}

function ___proxy_status() {
	if [[ "$(grep -c "export http_proxy=" ~/.bash_profile)" -eq 0 ]] ; then
		echo -e "${GREEN}No proxy is currently set.${NC}"
	elif [[ "$(grep -c "#export http_proxy=" ~/.bash_profile)" -eq 1 ]] ; then
		echo -e "${GREEN}The proxy is currently off.${NC}"
	else
		echo -e "${GREEN}The proxy is currently set to: '${http_proxy}'${NC}"
	fi
}

function ___proxy_set() {
    echo -e "${GREEN}Setting the proxy to '$1'${NC}"
	unset http_proxy
    unset https_proxy
    unset ftp_proxy
	echo "export http_proxy=$1; export https_proxy=\${http_proxy}; export ftp_proxy=\${http_proxy};" >> ~/.bash_profile
	___uiOn "$1"
}

function ___load_profile() {
    echo -e "${GREEN}Reloading profile...${NC}"
	source ~/.bash_profile
	if [[ ! -z "${http_proxy// }" ]]; then
		echo -e "${GREEN}Proxy set to: '${CYAN}$http_proxy${GREEN}'.${NC}"
	else
		echo -e "${GREEN}No proxy is currently set.${NC}"
	fi
}

function ___uiOn() {
	if [[ ! -z "${1// }" ]]; then
		parts=($(echo $1 | tr ":" "\n"))
		gsettings set org.gnome.system.proxy.socks host "${parts[0]}:${parts[1]}"
		gsettings set org.gnome.system.proxy.socks port "${parts[2]}"
	fi
	gsettings set org.gnome.system.proxy mode 'manual'
}

function ___uiOff() {
	gsettings set org.gnome.system.proxy mode 'none'
}

function ___uiClear() {
	gsettings set org.gnome.system.proxy.socks host ''
	gsettings set org.gnome.system.proxy.socks port 8080
	gsettings set org.gnome.system.proxy mode 'none'
}

function ___print_proxy_usage() {
	echo -e "${GREEN}Usage:"
	echo -e "${CYAN}  proxy on: ${GREEN} turns on the previously defined proxy."
	echo -e "${CYAN}  proxy on <proxy-name:proxy-port>: ${GREEN} turns on the specified proxy."
	echo -e "${CYAN}  proxy off: ${GREEN} turns off the previously defined proxy."
	echo -e "${CYAN}  proxy status: ${GREEN} prints the proxy status."
	echo -e "${CYAN}  proxy clear: ${GREEN} clears all proxy settings.${NC}"
}