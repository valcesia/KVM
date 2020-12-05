#!/bin/bash
# Script criado para fazer a cópia do template criado
# Modo de execução: sh Clone_VM.sh <nome_do_template> <inicial_da_vm_criada>
# Exemplo: sh Clone_VM.sh centos8-template 1-vm-
# Na primeira execução do script, haverá uma mensagem solicitando a quantidade de máquinas virtuais a serem criadas
# Adaptação do código obtido no GitHub - https://github.com/goffinet/virt-scripts/blob/master/clone.sh

original=$1
destination=$2
name=$original

clone () 
{
virt-clone -o $original -n $destination$i -f /home/clones/$destination$i.qcow2
}

prepare () 
{
virt-sysprep -d $destination$i --operations customize --firstboot-command " sudo dbus-uuidgen > /etc/machine-id ; sudo hostnamectl set-hostname $destination$i ; touch /.autorelabel ; sudo reboot"
}

sparsify () 
{
echo "Sparse disk optimization"
virt-sparsify --check-tmpdir ignore --compress --convert qcow2 --format qcow2 /home/clones/$destination$i.qcow2 /home/clones/$destination$i.sparse
rm -rf /home/clones/$destination$i.qcow2
mv /home/clones/$destination$i.sparse /home/clones/$destination$i.qcow2
chown qemu:qemu /home/clones/$destination$i.qcow2 || chown libvirt-qemu:libvirt-qemu /home/clones/$destination$i.qcow2
}

echo "Quantas cópias de VM?"
read numero_vm

for ((i=1; i<=numero_vm; i++))
do
    clone
    prepare
    sparsify
    virsh start $destination$i
done