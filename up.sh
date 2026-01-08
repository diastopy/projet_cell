#!/bin/bash

set -e 
#cleanup function
clean_resources() {
	kubectl delete -f oai-ueransim2.yaml
        helm uninstall upf2 
	kubectl delete -f oai-ueransim.yaml
        helm uninstall upf
        helm uninstall smf
        helm uninstall amf
        helm uninstall ausf
        helm uninstall udm
        helm uninstall udr
        helm uninstall nrf
        helm uninstall mysql
}

#launching funtion

launch_resources() {
        helm install mysql oai-5g-core/mysql/
        sleep 60
        helm install nrf oai-5g-core/oai-nrf/
        sleep 5
        helm install udr oai-5g-core/oai-udr/
        sleep 5
        helm install udm oai-5g-core/oai-udm/
        sleep 5
        helm install ausf oai-5g-core/oai-ausf/
        sleep 5
        helm install amf oai-5g-core/oai-amf/
        sleep 5
        helm install smf oai-5g-core/oai-smf/
        sleep 5
        helm install upf oai-5g-core/oai-upf/

        sleep 10
        kubectl apply -f oai-ueransim.yaml
        sleep 5

        helm install upf2 oai-5g-core/oai-upf2/

        sleep 10
        kubectl apply -f oai-ueransim2.yaml
        sleep 5


}

show_help() {
	echo "usage :"
	echo "./up.sh --launch pour lancer les pods"
	echo "./up.sh --clear pour tout arrêter"
}


# Parse args
CLEAN=false
LAUNCH=false

POSITIONAL_ARGS=()

if [[ $# -eq 0 ]]; then
	echo "Il n'y a pas d'argument"
	show_help
	exit 0
fi

while [[ $# -gt 0 ]]; do
	case "$1" in
		--clear)
      		clean_resources
      		shift
      		;;
    		--launch)
      		launch_resources
      		exit 0
		;;
		*)
		echo "Argument inconnu : $1"
		show_help
		exit 0
		;;

	esac
done
