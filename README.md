# suckless-btw

Meta-repositorio para orquestar mi setup suckless basado en **dwm**, **st** y **slstatus**.

Este repositorio no contiene código propio de dwm/st/slstatus.
Utiliza **git submodules** para fijar versiones exactas de cada proyecto
y proveer un único punto de instalación reproducible.

---

## 📦 Estructura del repositorio

```text

suckless-btw/
├── dwm/              -> submódulo
├── st/               -> submódulo
├── slstatus/         -> submódulo
├── dotfiles/
│   ├── bashrc
│   ├── bash_profile
│   ├── xinitrc
│   ├── nvim/                 ← config completa de Neovim
│   │   ├── init.lua
│   │   └── lua/
│   └── rofi/                 ← config de rofi
│       └── config.rasi
├── install.sh
└── README.md
```
```

## 📋 Prerrequisito
El sistema debe contar con los siguientes paquetes instalados:

- base-devel
- git
- xorg-server
- xorg-xinit
- rofi
- pamixer
- xss-lock
- inetutils
En Arch Linux:

```bash
sudo pacman -S base-devel git xorg-server xorg-xinit rofi pamixer xss-lock inetutils
```

---

## ⚙️ Instalación

Seguir los siguientes pasos para realizar la instalación:

### 1) Clonar el repositorio

```bash
mkdir dev
cd dev
git clone git@github.com:MartoNievas/suckless-btw.git
cd suckless-btw
```

### 2) Inicializar submódulos

```bash
git submodule update --init --recursive
```

### 3) Ejecutar el instalador

```bash
chmod +x install.sh
./install.sh
```

El script:

- inicializa los submódulos
- crea enlaces simbólicos de los dotfiles
- respalda archivos existentes con extensión `.bak`
- prepara el entorno base para dwm, st y slstatus
- instala nvim con NvChad como IDE principal
---

## 🔗 Trabajo con submódulos

Este repositorio utiliza **git submodules** para fijar versiones específicas
de `dwm`, `st` y `slstatus`.

### 📌 Actualizar TODOS los submódulos a la última versión de sus ramas

```bash
git submodule update --remote --merge
```

Luego, guardar los cambios en el meta-repo:

```bash
git commit -am "Update submodules"
git push
```

---

### 📌 Actualizar un submódulo específico

#### dwm

```bash
cd dwm
git checkout dwm-6.5
git pull
cd ..
git add dwm
git commit -m "Update dwm submodule"
git push
```

#### st

```bash
cd st
git checkout master
git pull
cd ..
git add st
git commit -m "Update st submodule"
git push
```

#### slstatus

```bash
cd slstatus
git checkout main
git pull
cd ..
git add slstatus
git commit -m "Update slstatus submodule"
git push
```

---

## 🔄 Workflow recomendado

### 🔹 Actualizar un proyecto (ej: dwm)

```bash
cd dwm
# trabajar normalmente (commits, patches, etc.)
git push
cd ..
git add dwm
git commit -m "Bump dwm"
git push
```

### 🔹 Actualizar todo el setup de una sola vez

```bash
git submodule update --remote --merge
git commit -am "Update all submodules"
git push
```

---

## 🧠 Notas

- El meta-repo **no duplica código**
- Los submódulos apuntan a ramas específicas
- El estado del sistema es completamente reproducible
- Este repositorio actúa como **fuente única de verdad** para el setup


