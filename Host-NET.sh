#!/bin/bash
# Script criado para fazer leitura da utilização real de NET do KVM
# Modo de execução: sh Host-NET.sh
# Baseado no script criado por https://unix.stackexchange.com/questions/20965/how-should-i-determine-the-current-network-utilization

# Nome dos dispositivos de rede
dev1=enp2s0
dev2=enp5s5

# Valida se existe o nome do dispositivo de rede informado
grep -q "^$dev1:" /proc/net/dev || exec echo "$dev1: no such device"
grep -q "^$dev2:" /proc/net/dev || exec echo "$dev2: no such device"

# Valida
read rx1 <"/sys/class/net/$dev1/statistics/rx_bytes"
read rx2 <"/sys/class/net/$dev2/statistics/rx_bytes"

read tx1 <"/sys/class/net/$dev1/statistics/tx_bytes"
read tx2 <"/sys/class/net/$dev2/statistics/tx_bytes"

while sleep 1; do
	# Captura a data / hora
	now=$(date)

	# Analisando dados estatísticos de rx_bytes e tx_bytes
    read newrx1 <"/sys/class/net/$dev1/statistics/rx_bytes"
    read newrx2 <"/sys/class/net/$dev2/statistics/rx_bytes"

    read newtx1 <"/sys/class/net/$dev1/statistics/tx_bytes"
    read newtx2 <"/sys/class/net/$dev2/statistics/tx_bytes"

    # Convertendo Bytes em kBytes: Bytes / 1000
    echo "$now, $dev1, rx (kB/s): $(((newrx1-rx1) / 1000)), tx (kB/s): $(((newtx1-tx1) / 1000)), $dev2,  {rx (kB/s): $(((newrx2-rx2) / 1000)), tx (kB/s): $(((newtx2-tx2) / 1000))"

	# Guardando os valores nas variáveis para usar no cálculo dentro do while
    rx1=$newrx1
    rx2=$newrx2
    
    tx1=$newtx1
    tx2=$newtx2

done >> kvm-net.csv