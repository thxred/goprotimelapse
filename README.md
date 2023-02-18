# GoProTimeLapse
A shell script that uses GoPro http command's to create a timelapse.

This project is the combination of a GoPro camera and a Linux computer with WIFI interface. 
Using a shell script and tools like FFMPEG, ImageMagick, FLock and the Crontab service. 
The goal is to create a timelapse video based on photos using a shell script. 
Taking advantage of 4K we can do a panning and zooming effect.

ts.sh is the main timelapse script.
wifi.sh is used for establish P2P connection and keep alive. 

Usage method with Crontab:

0 */3 * * * flock -x /home/USER/ts.lock -c "/home/USER/tl.sh 600" >/dev/null 2>&1
