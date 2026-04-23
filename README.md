# suckless-btw

Meta-repositorio para orquestar un setup suckless basado en **dwm**, **st** y **slstatus**.
No contiene código propio de dwm/st/slstatus. Utiliza **git submodules** para fijar versiones
exactas de cada proyecto y proveer un único punto de instalación reproducible.

---

## Estructura del repositorio

```
suckless-btw/
├── dwm/        (submodule)
├── st/         (submodule)
├── slstatus/   (submodule)
├── slock/      (submodule)
├── dotfiles/
├── scripts/
├── install.sh
├── README.md
└── .gitmodules
```

---

## Prerrequisitos

### Laptop (Intel)

```bash
sudo pacman -S base-devel git xorg-server xorg-xinit rofi pamixer xss-lock inetutils gsimplecal
```

Paquetes AUR (requiere `yay`):

```bash
yay -S vesktop ttf-jetbrains-mono-nerd
```

### Desktop (AMD CPU + AMD GPU)

```bash
sudo pacman -S base-devel git xorg-server xorg-xinit rofi pamixer xss-lock inetutils gsimplecal \
               mesa vulkan-radeon xf86-video-amdgpu lm_sensors
```

Paquetes AUR (requiere `yay`):

```bash
yay -S vesktop ttf-jetbrains-mono-nerd
```

---

## Instalacion

### 1. Clonar el repositorio

```bash
mkdir -p ~/dev && cd ~/dev
git clone git@github.com:MartoNievas/suckless-btw.git
cd suckless-btw
```

### 2. Inicializar submodulos

```bash
git submodule update --init --recursive
```

### 3. Ejecutar el instalador

```bash
chmod +x install.sh
./install.sh
```

El script se encarga de:

- inicializar los submodulos
- crear enlaces simbolicos de los dotfiles
- respaldar archivos existentes con extension `.bak`
- preparar el entorno base para dwm, st y slstatus
- instalar nvim con LazyVim como IDE principal

---

## Trabajo con submodulos

### Actualizar todos los submodulos

```bash
git submodule update --remote --merge
git commit -am "Update submodules"
git push
```

### Actualizar un submodulo especifico

```bash
cd <submodulo>
git checkout <rama>
git pull
cd ..
git add <submodulo>
git commit -m "Bump <submodulo>"
git push
```

---

## Workflow recomendado

Tras hacer cambios dentro de un submodulo, registrar el nuevo commit en el meta-repo:

```bash
cd <submodulo>
git push
cd ..
git add <submodulo>
git commit -m "Bump <submodulo>"
git push
```

Para actualizar todo el setup de una sola vez:

```bash
git submodule update --remote --merge
git commit -am "Update all submodules"
git push
```

---

## Notas

- El meta-repo no duplica codigo
- Los submodulos apuntan a ramas especificas
- El estado del sistema es completamente reproducible
- Este repositorio actua como fuente unica de verdad para el setup
