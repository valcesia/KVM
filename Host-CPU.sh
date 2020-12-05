#!/bin/bash
# Script criado para fazer leitura da utilização real de CPU do KVM
# Modo de execução: sh Host-CPU.sh
# Baseado no script criado por https://www.idnt.net/en-GB/kb/941772

while :; do
  now=$(date)
  # Obtem a primeita linha do comando /proc/stat
  cpu_now=($(head -n1 /proc/stat))
  # Obtem todas as columas menos a primeira, pois trata-se da string "CPU"
  cpu_sum="${cpu_now[@]:1}"
  # Trocar os espaços pelo sinal de soma (+)
  cpu_sum=$((${cpu_sum// /+}))
  # Obtem o valor delta entre as duas leituras
  cpu_delta=$((cpu_sum - cpu_last_sum))
  # Obtem o valor de idle Delta
  cpu_idle=$((cpu_now[4]- cpu_last[4]))
  # Calcula o tempo de execução
  cpu_used=$((cpu_delta - cpu_idle))
  # Calcula a porcentagem
  cpu_usage=$((100 * cpu_used / cpu_delta))

  # Mantem o valor a leitra de CPU para o atributo cpu_last_sum
  cpu_last=("${cpu_now[@]}")
  cpu_last_sum=$cpu_sum

  # Imprime o valor de CPU e data/hora do sistema para controle
  echo "$now","$cpu_usage"

  # Aguarde um (1) segundo para a próxima leitura
  # Valor para ficar igual à frequência obtida pelo KVMTOP
  sleep 1

  #Armazena o valor no arquivo kvm-cpu.csv
done >> kvm-cpu.csv