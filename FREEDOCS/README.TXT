### FreeDOS 1.3-RC1 Installation media.

README.TXT
    The simple "before you choose and install" document.
    (All zip archives contain a copy of this README file.)

verify.txt
    Contains MD5, SHA256 and SHA512 hashes for all of the different release
    files.

FD13-Floppy.zip

    * FD13FLOP.IMG - Basic FreeDOS installation boot floppy image.

FD13-LiteUSB.zip

    * FD13LITE.IMG - Plain DOS system only! USB stick image.

    * FD13LITE.VMDK - An Virtual Machine Disk description file to simplify
    attaching the LiteUSB image to a virtual machine (like VirtualBox and
    vmWare) as a hard drive.

FD13-FullUSB.zip

    * FD13FULL.IMG - Plain DOS system and Full install USB stick image.
    (Also, includes may extra packages that are not installed in the
    "Plain DOS" or even the "Full Install".  These extras can be installed
    later using FDIMPLES or another package manager)

    * FD13FULL.VMDK - An Virtual Machine Disk description file to simplify
    attaching the FullUSB image to a virtual machine (like VirtualBox and
    vmWare) as a hard drive.

FD13-LegacyCD.zip

    * FD13LGCY.ISO - Contains all the packages as FD13-FullUSB. However, it
    is a bootable CD image designed for older hardware. It uses the classic
    El Torito Boot CD-ROM format. Some modern computers and virtual machines
    are known to have issues booting CDs that use this ancient specification.
    Unless you have a computer that requires this type of bootable CD, we
    recommend using the LiveCD media.

Two prototypes of LiveCDs are being provided with RC1. However, one will be
discarded. Both types have some live FreeDOS packages at boot and support
temporarily installing/removing more by using FDIMPLES. Also, both will
automatically start networking support when used inside VirtualBox or vmWare.
Otherwise, you will need to manually start it.

So, let your voice be heard on which (if any) LiveCD you prefer.

FD13-LiveCD.zip

    * FD13LIVE.ISO - FreeDOS LiveCD along with support for a Plain and Full
    installation.