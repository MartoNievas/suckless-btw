#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/dev/suckless-btw/dotfiles"
SUCKLESS_DIR="$HOME/dev/suckless-btw"

DRY_RUN=false
FORCE=false
UNINSTALL=false

# ─── Colores ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_ok() { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# ─── Mapa de dotfiles (única fuente de verdad) ────────────────────────────────
# Formato: [nombre_archivo_en_dotfiles]="destino"
declare -A BASE_LINKS=(
  [zshrc]="$HOME/.zshrc"
  [zprofile]="$HOME/.zprofile"
  [bashrc]="$HOME/.bashrc"
  [bash_profile]="$HOME/.bash_profile"
  [xinitrc]="$HOME/.xinitrc"
  [rofi_config]="$HOME/.config/rofi/config.rasi"
  [nvim]="$HOME/.config/nvim"
)

# Links adicionales por máquina: [nombre]="destino"
declare -A THINKPAD_LINKS=(
  [xinitrc_thinkpad]="$HOME/.xinitrc" # puede diferir del default si tenés un xinitrc específico
)

declare -A DESKTOP_LINKS=()

# ─── Uso ──────────────────────────────────────────────────────────────────────
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --dry-run    Simular instalación sin hacer cambios"
  echo "  --force      Forzar recompilación de todo el software suckless"
  echo "  --uninstall  Eliminar symlinks y restaurar backups"
  echo "  -h, --help   Mostrar este mensaje"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --dry-run)
    DRY_RUN=true
    shift
    ;;
  --force)
    FORCE=true
    shift
    ;;
  --uninstall)
    UNINSTALL=true
    shift
    ;;
  -h | --help) usage ;;
  *)
    log_error "Opción desconocida: $1"
    usage
    ;;
  esac
done

# ─── Detección de máquina ─────────────────────────────────────────────────────
detect_machine() {
  # Intentar por product_name (laptops/OEM)
  if [ -f /sys/class/dmi/id/product_version ]; then
    local model
    model=$(cat /sys/class/dmi/id/product_version 2>/dev/null)
    case "$model" in
    *ThinkPad\ T480*)
      echo "thinkpad-t480"
      return
      ;;
    esac
  fi

  # Intentar por board_name (placas madre de desktop)
  if [ -f /sys/class/dmi/id/board_name ]; then
    local board
    board=$(cat /sys/class/dmi/id/board_name 2>/dev/null)
    case "$board" in
    *B550* | *X570* | *B450* | *X470*)
      echo "desktop-ryzen"
      return
      ;;
    esac
  fi

  # Fallback: chequeamos el CPU directamente
  if grep -qi "ryzen" /proc/cpuinfo 2>/dev/null; then
    echo "desktop-ryzen"
    return
  fi

  log_warn "No se pudo detectar la máquina, usando configuración genérica"
  echo "unknown"
}

# ─── Dependencias ─────────────────────────────────────────────────────────────
check_dependencies() {
  local deps=(make gcc git)
  local missing=()

  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      missing+=("$dep")
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    log_error "Dependencias faltantes: ${missing[*]}"
    log_error "Instalá con: sudo pacman -S --needed ${missing[*]}"
    return 1
  fi

  log_ok "Dependencias OK"
}

# ─── Suckless ─────────────────────────────────────────────────────────────────
install_suckless() {
  local project="$1"
  local dir="$SUCKLESS_DIR/$project"

  if [ ! -d "$dir" ]; then
    log_warn "Proyecto $project no encontrado en $dir, saltando"
    return
  fi

  # Verificar si ya está instalado en el sistema
  local installed_bin="/usr/local/bin/$project"
  if [ "$FORCE" = false ] && command -v "$project" &>/dev/null; then
    log_info "$project ya instalado, saltando (usá --force para recompilar)"
    return
  fi

  log_info "Compilando $project..."

  if [ "$DRY_RUN" = true ]; then
    log_info "[DRY-RUN] make clean && make && sudo make install en $dir"
    return
  fi

  (
    cd "$dir"
    make clean 2>/dev/null || true
    make
    sudo make install
  )

  log_ok "$project instalado"
}

# ─── Symlinks ─────────────────────────────────────────────────────────────────
backup_and_link() {
  local src="$1"
  local dst="$2"

  if [ ! -e "$src" ]; then
    log_warn "Fuente no encontrada: $src — saltando"
    return
  fi

  if [ "$DRY_RUN" = false ]; then
    mkdir -p "$(dirname "$dst")"
  fi

  # Symlink viejo → reemplazar directamente
  if [ -L "$dst" ]; then
    [ "$DRY_RUN" = false ] && rm "$dst"
    log_info "Symlink anterior eliminado: $dst"
  # Archivo/directorio real → hacer backup
  elif [ -e "$dst" ]; then
    if [ "$DRY_RUN" = false ]; then
      mv "$dst" "${dst}.bak"
    fi
    log_warn "Backup creado: ${dst}.bak"
  fi

  if [ "$DRY_RUN" = false ]; then
    ln -s "$src" "$dst"
  fi

  log_ok "Enlazado: $src → $dst"
}

# ─── Desinstalación ───────────────────────────────────────────────────────────
uninstall_dotfiles() {
  log_info "Eliminando symlinks..."

  for file in "${!BASE_LINKS[@]}"; do
    local dst="${BASE_LINKS[$file]}"
    if [ -L "$dst" ]; then
      rm "$dst"
      log_ok "Symlink eliminado: $dst"
    fi
    if [ -e "${dst}.bak" ]; then
      mv "${dst}.bak" "$dst"
      log_ok "Backup restaurado: $dst"
    fi
  done
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  local machine
  machine=$(detect_machine)

  echo ""
  echo "╔══════════════════════════════╗"
  echo "║    Dotfiles Installer        ║"
  echo "╚══════════════════════════════╝"
  echo ""
  log_info "Máquina detectada: $machine"
  [ "$DRY_RUN" = true ] && log_warn "MODO DRY-RUN — no se harán cambios reales"
  [ "$FORCE" = true ] && log_warn "MODO FORCE — se recompilará todo el software suckless"
  echo ""

  if [ "$UNINSTALL" = true ]; then
    uninstall_dotfiles
    log_ok "Desinstalación completa"
    exit 0
  fi

  check_dependencies || exit 1

  # Construir mapa final de links según la máquina
  declare -A LINKS
  for k in "${!BASE_LINKS[@]}"; do LINKS[$k]="${BASE_LINKS[$k]}"; done

  case "$machine" in
  thinkpad-t480)
    for k in "${!THINKPAD_LINKS[@]}"; do LINKS[$k]="${THINKPAD_LINKS[$k]}"; done
    ;;
  desktop-ryzen)
    for k in "${!DESKTOP_LINKS[@]}"; do LINKS[$k]="${DESKTOP_LINKS[$k]}"; done
    ;;
  esac

  log_info "Instalando dotfiles..."
  for file in "${!LINKS[@]}"; do
    backup_and_link "$DOTFILES_DIR/$file" "${LINKS[$file]}"
  done
  echo ""

  log_info "Compilando software suckless..."
  for project in dwm st slock slstatus; do
    install_suckless "$project"
  done
  echo ""

  log_ok "¡Instalación completa!"
}

main "$@"
