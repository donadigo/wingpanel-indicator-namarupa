# ![icon](data/icon.png) Wingpanel Namarupa Indicator

![Screenshot](data/shot.png)

## Name Inspiration

The name Namarupa is used for the forces at play that govern the Ayatana, in Buddhism. Since this indicator manages the system tray icons which are under the Ayatana project, it seems clever to name this Namarupa.

## Installation
### For users

You'll need the latest debian file (.deb) in our releases tab (TBD) and [this patched indicator-applications debian file](https://github.com/mdh34/elementary-indicators/releases), both installed.

### For developers

You'll need the following dependencies:

* gobject-introspection
* libglib2.0-dev
* libgranite-dev
* libindicator3-dev
* libwingpanel-2.0-dev
* valac

```bash
sudo apt install gobject-introspection libglib2.0-dev libgranite-dev libindicator3-dev libwingpanel-2.0-dev valac
```

Run meson to configure the build environment and then ninja to build:

```bash
meson build --prefix=/usr && cd build
ninja
```

To install, use ninja install:

```bash
sudo ninja install
```
