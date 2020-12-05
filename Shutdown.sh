#!/bin/bash
# Script criado para fazer a remoção das máqunias virtuais criadas
# Modo de execução: sh Shutdown.sh
# A única máquina virtual que não será desligada é a centos8-template

shutdown () 
{
for i in `virsh list --all | awk '{print $2}'| grep -v Name`

	do
	if [[ "$i" != "centos8-template" ]]; then
		virsh shutdown $i
	fi
done
}
shutdown