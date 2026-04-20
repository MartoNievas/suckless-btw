#!/bin/bash
set -e

#Declaracion de variables
DOTFILES_DIR="$HOME/dev/suckless-btw/dotfiles"

declare -A LINKS=(
  [bashrc]="$HOME/.bashrc"
  [bash_profile]="$HOME/.bash_profile"
  [xinitrc]="$HOME/.xinitrc"
  [rofi_config]="$HOME/.config/rofi/config.rasi"
  [nvim_config]="$HOME/.config/nvim"
)

#funcion de backup para enlaces simbolicos seguros
backup() {
  src="$1"
  dst="$2"

  if [ ! -e "$src" ]; then
    echo "⚠️  No existe el origen: $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak"
  fi

  ln -s "$src" "$dst"
}

for file in "${!LINKS[@]}"; do
  echo "Creando enlace simbolico para .$file..."
  backup "$DOTFILES_DIR/$file" "${LINKS[$file]}"
done

sudo pacman -S --noconfirm nvim

#volver al home
cd ~/
rm -rf ~/suckless-btw
echo "Intalacion completada!!!"
echo "De compilar dwm, st, slstatus para continuar..."
