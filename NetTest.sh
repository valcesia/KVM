#!/bin/bash
# Script criado para fazer load teste nas máquinas virtuais
# IP do Servidor com iperf3: 192.168.50.100
# Cada máquina virtual vai fazer a transmissão e recepcão dos mesmos dados por 10 vezes
# Modo de execução: cada VM clonada já está com este script configurado via crontab -e
# Configuração feita nas máquinas clonadas:
#		crontab -e
#		@reboot /root/NetTest.sh

transfer_udp ()
{
iperf3 -c 192.168.50.100 -u -t 5
}

transfer_tcp ()
{
iperf3 -c 192.168.0.50 -t 5
}

reverse_transfer_udp ()
{
iperf3 -c 192.168.50.100 -R -u -t 5
}

reverse_transfer_tcp ()
{
iperf3 -c 192.168.0.50 -R -t 5
}

for ((i=1; i<=10;i++))
do
	transfer_udp
	sleep 5
	transfer_tdp
	sleep 5
	reverse_transfer_udp
	sleep 5
	reverse_transfer_tcp
	sleep 5
done