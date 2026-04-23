#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dev/suckless-btw/dotfiles"

# Lista de enlaces: [NOMBRE_EN_DOTFILES]="RUTA_DESTINO_EN_HOME"
declare -A LINKS=(
  [zshrc]="$HOME/.zshrc"
  [zprofile]="$HOME/.zprofile"
  [bashrc]="$HOME/.bashrc"
  [bash_profile]="$HOME/.bash_profile"
  [xinitrc]="$HOME/.xinitrc"
  [rofi_config]="$HOME/.config/rofi/config.rasi"
  [nvim]="$HOME/.config/nvim"
)

backup_and_link() {
  local src="$1"
  local dst="$2"

  if [ ! -e "$src" ]; then
    echo "[⚠️]  No se encontró el archivo original en: $src"
    return
  fi

  # Crear el directorio padre si no existe (ej. .config/rofi)
  mkdir -p "$(dirname "$dst")"

  # Manejar si el destino ya existe
  if [ -L "$dst" ]; then
    rm "$dst" # Si es un link viejo, lo quitamos
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak" # Si es un archivo real, backup de seguridad
    echo "📦 Backup creado: $dst.bak"
  fi

  ln -s "$src" "$dst"
  echo "[✅] Enlazado: $src -> $dst"
}

# 1. Instalación de paquetes necesarios
echo "Instalando dependencias de sistema..."
sudo pacman -S --needed --noconfirm base-devel nvim zsh bash-completion

# 2. Crear los enlaces simbólicos
echo "Creando symlinks..."
for file in "${!LINKS[@]}"; do
  backup_and_link "$DOTFILES_DIR/$file" "${LINKS[$file]}"
done

# 3. Finalización (QUITÉ EL RM -RF)
echo ""
echo "[🚀] Instalación completada con éxito."
echo "Tus archivos originales están en: $DOTFILES_DIR"
echo "Recuerda entrar en las carpetas de dwm, st y slstatus para hacer 'sudo make clean install'."
