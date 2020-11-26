# ![icon](data/icon.png) Wingpanel Namarupa Indicator

![Screenshot](data/shot.png)

## Name Inspiration

The name Namarupa is used for the forces at play that govern the Ayatana, in Buddhism. Since this indicator manages the system tray icons which are under the Ayatana project, it seems clever to name this Namarupa.

## Before Installation

You need to add Pantheon to the list of desktops abled to work with indicators:  

- With autostart (thanks to JMoerman)  

System settings -> "Applications" -> "Startup" -> "Add Startup App…" -> "Type in a custom command"

Add /usr/lib/x86_64-linux-gnu/indicator-application/indicator-application-service as custom command to the auto start applications in the system settings  

- With a patch

Install [this patched indicator-applications debian file](https://github.com/mdh34/elementary-indicators/releases) 

**reboot**  

### Easy install for users

Install the latest debian file (com.github.donadigo.wingpanel-indicator-namarupa_1.0.0_amd64.deb) try a double-click or use dpkg :  
`sudo dpkg -i com.github.donadigo.wingpanel-indicator-namarupa_1.0.0_amd64.deb `

### For developers

You'll need the following dependencies:

```bash
sudo apt-get install libglib2.0-dev libgranite-dev libindicator3-dev libwingpanel-2.0-dev 
valac gcc meson
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

Reboot or kill and let wingpanel come back:

`killall wingpanel` 
