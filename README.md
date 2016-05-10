# The FreeDOS Installer (FDI)

The [FreeDOS](http://freedos.org) Installer is a customizable and flexible
batch based installation kit based on [V8Power Tools](http://up.lod.bz/V8Power)
batch file enhancement utilities.

If you do not want to use one of the pre-built installer image files and want
to build a operating system release, please see the
[FDI wiki](https://github.com/shidel/FDI/wiki) on [Github](https://github.com).

* * *
### Installation Requirements

FDI has a fairly modest set of requirements.

* EGA or better graphics.
* 80386 or better CPU.
* 640k RAM (under 4Mb is untested)

(Although V8Power Tools only requires an 8086, some other utilities required
by FDI at present do not support CPUs lower than a 386)

### FreeDOS installation methods

There are basically four ways to install FreeDOS using FDI.

* The Big USB or Slim USB stick
  * All Virtual Machines
  * Many modern computers
* Bootable CD-ROM
  * Most Virtual Machines (excluding VirtualBox)
  * Most 486 or better computers
* Bootable Floppy + CD-ROM (or USB Stick).
  * All Virtual Machines
  * Nearly any computer with a CD-ROM.
* Separate Hard Disk
  * Any computer or machine that supports FreeDOS.

To use the "Separate Hard Disk" method. You must copy all files and directories
from one of the USB sticks to the root directory of the spare hard disk drive.
If performing this from DOS, you can use xcopy with the /e switch.

A special note for DOSBox users. FDI can install to DOSBox using the "Separate
Hard Disk" method. This assumes you have already setup a drive C: and know
how to mount the Spare Drive into DOSBox. It will perform the install and
prepare a AUTOEXEC.BAT file on drive C: to use the FreeDOS binaries and the
FreeCOM shell. This does not cause the FreeDOS kernel to be used. So,
technically this not a FreeDOS install. It really is just enhancing DOSBox with
the FreeDOS binaries.
