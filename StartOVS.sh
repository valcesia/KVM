#!/bin/bash
# Script criado para fazer leitura da utilização real de CPU do KVM
# Modo de execução: sh Host-CPU.sh
# Baseado no script criado por https://www.idnt.net/en-GB/kb/941772

# Constroi uma interface usando o XML libvirtlabs.xml e inicialida a rede ovs-network

virsh net-define libvirtvlabs.xml
virsh net-autostart ovs-network
virsh net-start ovs-network

# Inicializa a utilização do Open vSwitch 

sudo /usr/share/openvswitch/scripts//ovs-ctl start

# Criação das interfaces br-enp5s5 e br-int0

sudo ovs-vsctl add-br br-enp5s5
sudo ovs-vsctl add-br br-int0

# Criação da porta enp5s5 (eth0) no Open vSwitch

sudo ovs-vsctl add-port br-enp5s5 enp5s5

# Configuração do Controlador RYU para a interface de loopback

sudo ovs-vsctl set-controller br-int0 tcp:127.0.0.1:6633
ifconfig enp5s5 0.0.0.0
ip link set br-enp5s5 up
dhclient br-enp5s5

# Criação de uma rede DHCP usando namespace

ip netns del dhcp-100
sudo ovs-vsctl del-port br-int0 vlan100
ovs-vsctl add-port br-int0 vlan100 tag=100 -- set interface vlan100 typ=internal
ip netns add dhcp-100
ip link set vlan100 netns dhcp-100
ip netns exec dhcp-100 ip addr add 192.168.80.1/24 dev vlan100
ip netns exec dhcp-100 ifconfig vlan100 promisc up

# Execução da rede DHCP com o range de rede especificado

ip netns exec dhcp-100 /usr/sbin/dnsmasq --dhcp-range=192.168.80.1,192.168.80.254,255.255.255.0 --interface=vlan100 --no-daemon