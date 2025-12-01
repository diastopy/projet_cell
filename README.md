# 5G Core Slicing for Adaptive Service Quality Based on Latency and Throughput Requirements

## Contact

For help and information for this project refer to this email : taha-mohsen.zaidi@lip6.fr

## Overview

The objective of this project is to design and implement a 5G network architecture that connects two distinct User Equipments (UEs) using UERANSIM instances, with each UE mapped to a different network slice to demonstrate adaptive service quality based on throughput and latency requirements.

UPF1 (High Throughput Slice):
This slice is optimized for high throughput, allowing UE1 to achieve maximum data transfer rates while maintaining standard latency.

UPF2 (Low Latency Slice):
This slice is optimized for low latency and limited throughput, ensuring that UE2 can perform latency-sensitive applications efficiently.

This architecture demonstrates 5G Core slicing in practice, where each UE is independently linked to a UPF configured for its specific service requirements, enabling differentiated network performance for multiple applications.

## Getting Started

Clone this repository in your VM 29 (ssh cell@132.227.122.29) to access the files that we have already prepared for you:
```
ssh cell@132.227.122.29
https://gitlab.noc.onelab.eu/projects-2025-2026/5g-core-slicing.git
```
Go into the directory and execute the following command to initialize kubernetes cluster and depedencies. !!!WAIT UNITL THE SCRIPT IS DONE!!:
```
bash init.sh
```
After this script finishes continue by installing helm with the following command:
```
bash get_helm.sh
```



The first step is to deploy the 5G Core Network.



Go inside the the folder that you have just cloned and study the files and more specifically the folder oai-5g-core and oai-ueransim.yaml.

- In this project you will have to deploy the 5G Core funtions **in this specific order** : mysql(Database), NRF, UDR, UDM, AUSF, AMF, SMF, UPF.


```
cd 5g-amf-scaling/oai-5g-core
```
In order to deploy each function you have to execute the following command for each core network function:

```
helm install {network_function_name} {path_of_network_function}
```
For example if you want to deploy the sql database  and then the NRF, UDR you execute:

```
helm install mysql mysql/
helm install nrf oai-nrf/
helm install udr oai-udr/
...
```
It is very important that every after helm command you execute: kubectl get pods in order to see that the respective network function is running, before going to the next one.

In order to uninstall something with helm you execute the following command:
```
helm uninstall {function_name}  ## e.g. helm uninstall udr
```


Afer you deployed all the network functions mentioned above you will be able to connect the UE to the 5G network by executing:

```
kubectl apply -f oai-ueransim.yaml
```

In order to uninstall something with kubectl you execute the following command:
```
kubectl delete -f oai-ueransim.yaml 
```


In order to see if the UE has actually subscribed and received an ip you will have to enter the UE container:

```
kubectl get pods # In order to find the name of the ue_container_name (should look something like this: ueransim-746f446df9-t4sgh)
kubectl exec -ti {ue_container_name} -- bash
```

If everything went well you should be inside the UE container and if you execute ifconfig you should see the following interface:
```
uesimtun0: flags=369<UP,POINTOPOINT,NOTRAILERS,RUNNING,PROMISC>  mtu 1400
        inet 12.1.1.2  netmask 255.255.255.255  destination 12.1.1.2
        inet6 fe80::73e2:e6e6:c3a:3d17  prefixlen 64  scopeid 0x20<link>
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 500  (UNSPEC)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 688 (688.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

If not, something went wrong. If yes, execute the following command to make sure you have connectivity to the internet through your 5G network:
```
ping -I uesimtun0 8.8.8.8
```


If the ping command works, it means that you have successfully deployed a 5G network and connected a UE to it.


## Project goal

### A)
As previously mentioned you will have to extend this architecture to connect two different  UEs (i.e. UERANSIMs) in the network. The first UE if you did it right is already created and is connected to the first UPF. You then have to deploy a second UPF and also a second UERANSIM and connect them together. All in all the first UERANSIM1 will be connceted to UPF1 and the second UERANSIM2 will be connected to UPF2.

- Hint1: The files you will need to check are the ones of the oai-ueransim1.yaml,oai-ueransim2.yaml,smf/config-file,upf2/config-file
- Hint2: The slicing uses 3 key values: SST, SD, and DNN(or APN). The first UE1 has already matched these values with the SMF and the UPF1. In order to achieve the goal of this project you will have to modify files to match the 2nd UE2 to the second UPF2 (eventually and the SMF) by matching those 3 key parameters.

To test if your project is working:
1) ping from UE1 -> UPF1 and test if you have connectivity
2) ping from UE2 -> UPF2 and test if you have connectivity


### B)

In this part, both UEs will share a UPF depending on the application requirements:

- High Throughput Applications:

Here you will have to connect both UE1 and UE2 connect to UPF1 (high throughput).

Test by running a simple iperf command from th UERANSIMS to UPF1(separate iperfs commands).

- Low Latency Applications:

Here you will have to connect both UE1 and UE2 connect to UPF2 (low latency).

Test by running a PING command from the UERANSIMS to UPF2(separate ping commands).


Hint: Do not change the conf files of the UPFs. Try to match the conf files of the UERANSIMs to the respective ones of the UPFs in order to accomplish the project objectives.

