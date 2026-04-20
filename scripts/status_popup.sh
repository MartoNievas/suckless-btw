#!/bin/bash
# Colores Tokyo Night para el texto
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE} Usuario:${NC}  $(whoami)"
echo -e "${CYAN}󰩟 IP Local:${NC} $(hostname -i | awk '{print $1}')"
echo -e "${MAGENTA}󰅐 Uptime:${NC}   $(uptime -p | sed 's/up //')"
echo -e "${BLUE}󰣇 Kernel:${NC}   $(uname -r)"
echo ""
echo -e "${NC}Presiona cualquier tecla para cerrar..."
read -n 1
