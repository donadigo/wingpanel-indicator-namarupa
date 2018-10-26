# ![icon](data/icon.png) Wingpanel Namarupa Indicator

## Name Inspiration

The name Namarupa is used for the forces at play that govern the Ayatana, in Buddhism. Since this indicator manages the system tray icons which are under the Ayatana project, it seems clever to name this Namarupa.

## Building and Installation

You'll need the following dependencies:

* gobject-introspection
* libglib2.0-dev
* libgranite-dev
* libindicator3-dev
* libwingpanel-2.0-dev
* valac

Run meson to configure the build environment and then ninja to build:

```bash
meson build --prefix=/usr && cd build
ninja
```

To install, use ninja install:

```bash
sudo ninja install
```
