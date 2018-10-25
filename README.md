# Wingpanel Ayatana-Compatibility Indicator
[![l10n](https://l10n.elementary.io/widgets/wingpanel/wingpanel-indicator-ayatana/svg-badge.svg)](https://l10n.elementary.io/projects/wingpanel/wingpanel-indicator-ayatana)

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
