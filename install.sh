#!/bin/bash
set -e

#Declaracion de variables
DOTFILES_DIR="$HOME/dev/suckless-btw/dotfiles"

declare -A LINKS=(
  [bashrc]="$HOME/.bashrc"
  [bash_profile]="$HOME/.bash_profile"
  [xinitrc]="$HOME/.xinitrc"
  [rofi_config]="$HOME/.config/rofi/config.rasi"
)

#funcion de backup para enlaces simbolicos seguros
backup() {
  src="$1"
  dst="$2"

  [ -e "$dst" ] && mv "$dst" "$dst.bak"
  ln -s "$src" "$dst"
}

echo "Creacion de enlaces simbolicos..."


for file in "${!LINKS[@]}"; do
  echo "Creando enlace simbolico para .$file..."
  backup "$DOTFILES_DIR/$file" "${LINKS[$file]}"
done

echo "instalacion de nvim y NvChad..."

sudo pacman -S --noconfirm nvim
git clone https://github.com/NvChad/starter ~/.config/nvim

echo "Para completar la instalacion de NvChad abrir nvim"

#volver al home
cd ~/
rm -rf ~/suckless-btw
echo "Intalacion completada!!!"
echo "De compilar dwm, st, slstatus para continuar..."
