Boot-Splash für Syslinux/Isolinux und Bildschirm-Hintergrund für
die virtuelle Appliance
===================================================================

Die Ausgangs-Dateien liegen in "orig":
	splash.svg
	desktop-image.svg

Batik installieren:
	./get-batik

Rastern:
	./rasterize

Die generierten Dateien liegen dann in "out":
	splash.png
	splash.pdf
	desktop-image-640x480.png
	desktop-image-800x600.png
	desktop-image-1024x786.png


splash.png hat die Größe 640 * 400 px.
Nicht verwirren lassen von der seltsamen Größe.
./rasterize gibt am Ende die weiteren Anweisungen aus.

Die PNG-Datei muß in ein PPM umgewandelt werden (z.B. mit dem
GraphicConverter oder mit ImageMagick).
Achtung: In dem PPM dürfen nur 16 Farben verwendet werden,
sonst funktioniert die Konvertierung zu LSS16 nicht richtig!
Und das PPM muß binär sein (nicht plain ASCII) und es darf auch
keine Kommentarzeile in dem Format enthalten sein!

Konvertierung von PPM zu LSS16 geht per ppmtolss16
http://linux.die.net/man/1/ppmtolss16

Auf Debian ist das Tool im Paket syslinux-common enthalten.
http://packages.debian.org/squeeze/all/syslinux-common/filelist
	
	aptitude install syslinux-common
	
	ppmtolss16 < splash.ppm > splash.16

Sicherheitshalber danach nochmal umgekehrt checken ob die
Konvertierung richtig war:

	lss16toppm < splash.16 > splash-check.ppm

Und splash-check.ppm kontrollieren.

