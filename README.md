# ![icon](data/icon.png) Wingpanel Namarupa Indicator

![Screenshot](data/shot.png)

## Name Inspiration

The name Namarupa is used for the forces at play that govern the Ayatana, in Buddhism. Since this indicator manages the system tray icons which are under the Ayatana project, it seems clever to name this Namarupa.

## Installation

1. You need to add Pantheon to the list of desktops abled to work with indicators:
<pre>sudo nano /etc/xdg/autostart/indicator-application.desktop</pre>
Search the parameter: OnlyShowIn= and add "Pantheon" at the end of the line : 
<pre>OnlyShowIn=Unity;GNOME;Pantheon;</pre>
Save your changes (Ctrl+X to quit + Y(es) save the changes + Enter to valid the filename).<br/>

2.<b>reboot</b>.

3.You'll need the following dependencies:

* gobject-introspection
* libglib2.0-dev
* libgranite-dev
* libindicator3-dev
* libwingpanel-2.0-dev
* valac

```bash
sudo apt install gobject-introspection libglib2.0-dev libgranite-dev libindicator3-dev libwingpanel-2.0-dev valac
```

4.Run meson to configure the build environment and then ninja to build:

```bash
meson build --prefix=/usr && cd build
```

5.To install, use ninja install:

```bash
sudo ninja install
```
