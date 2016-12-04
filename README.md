# The FreeDOS Installer (FDI)

The [FreeDOS](http://freedos.org) Installer is a customizable and flexible
batch based installation kit based on the
[V8Power Tools](http://up.lod.bz/V8Power) batch file enhancement utilities.

If you do not want to use one of the
[pre-built install images](http://up.lod.bz/FDI)
and want to build a custom operating system release, please see
the [FDI wiki](https://github.com/shidel/FDI/wiki)
on [Github](https://github.com).

* * *
### Installation Requirements

FDI has a fairly modest set of requirements.

* EGA or better graphics.
* 80386 or better CPU.
* 640k RAM (under 4Mb is untested)

_(Although V8Power Tools and FDI only requires an 8086, some other utilities
that are currently required by FDI do not support CPUs lower than a 386.)_

### FreeDOS installation methods

There are basically four methods using FDI to install
[FreeDOS](http://freedos.org).

* The FULL USB or LITE USB stick
  * All supported virtual machines
  * Many modern computers
* Bootable CD-ROM
  * Most virtual machines (including VirtualBox)
  * Most 486 or better computers
* Alternate Legacy CD-ROM
  * Virtual Machines (excluding VirtualBox)
  * Most computers that support CD booting.
* Bootable Floppy + CD-ROM (or USB Stick).
  * All supported virtual machines
  * Nearly any computer with a CD-ROM.
* Separate Hard Disk
  * Any computer or machine that supports [FreeDOS](http://freedos.org) and
  meets the minimum requirements.

To use the "Separate Hard Disk" method, you must copy all files and directories
from one of the USB sticks to the root directory of the spare hard disk drive.
If performing this from DOS, you can use xcopy with the /e switch. This is not
the drive where you will be installing [FreeDOS](http://freedos.org). It should
be a spare and completely separate drive.

A special note for [DOSBox](http://dosbox.com) users. FDI can install to
[DOSBox](http://dosbox.com) using the "Separate Hard Disk" method. This assumes
you have already setup a drive *C:* and know how to mount the _Spare Drive_
into [DOSBox](http://dosbox.com). It will perform the install and prepare an
*AUTOEXEC.BAT* file on drive *C:* to use the [FreeDOS](http://freedos.org)
binaries and the FreeCOM shell. This does not cause the
[FreeDOS](http://freedos.org) kernel to be used. So, technically this not a
[FreeDOS](http://freedos.org) install. It really is just enhancing
[DOSBox](http://dosbox.com) with the [FreeDOS](http://freedos.org) binaries.
