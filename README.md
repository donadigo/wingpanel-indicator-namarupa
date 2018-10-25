# Wingpanel Namarupa Indicator

## Name Inspiration

The name Namarupa is used for the forces at play that govern the Ayatana, in Buddhism. Since this indicator manages the system tray icons which are under the Ayatana project, it seems clever to name this Namarupa.

## Building and Installation

You'll need the following dependencies:

* cmake
* gobject-introspection
* libglib2.0-dev
* libgranite-dev
* libindicator3-dev
* libwingpanel-2.0-dev
* valac

It's recommended to create a clean build environment

    mkdir build
    cd build/
    
Run `cmake` to configure the build environment and then `make` to build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make
    
To install, use `make install`

    sudo make install
