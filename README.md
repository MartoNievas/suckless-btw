# suckless-btw

Meta-repo para orquestar mi setup suckless basado en **dwm**, **st** y **slstatus**.

Este repositorio **NO contiene código propio de dwm/st/slstatus**:  
usa **git submodules** para fijar versiones exactas de cada proyecto y proveer
un punto único de instalación.

---

## 📦 Estructura

```text
suckless-btw/
├── dwm/        -> submódulo (repo dwm-btw)
├── st/         -> submódulo (repo st-btw)
├── slstatus/   -> submódulo (repo slstatus-btw)
├── install.sh  -> script de instalación
└── README.md

