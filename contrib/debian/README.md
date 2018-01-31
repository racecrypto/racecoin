
Debian
====================
This directory contains files used to package raced/race-qt
for Debian-based Linux systems. If you compile raced/race-qt yourself, there are some useful files here.

## race: URI support ##


race-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install race-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your race-qt binary to `/usr/bin`
and the `../../share/pixmaps/race128.png` to `/usr/share/pixmaps`

race-qt.protocol (KDE)

