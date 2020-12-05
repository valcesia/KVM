#!/bin/bash
# Script criado para fazer load teste nas máquinas virtuais
# Cada máquina virtual vai fazer a execução do script usando loads sequenciais
# Modo de execução: cada VM clonada já está com este script configurado via crontab -e
# Configuração feita nas máquinas clonadas:
# crontab -e
# @reboot /root/Stress.sh
stress-ng --sequential 0 -t 5m