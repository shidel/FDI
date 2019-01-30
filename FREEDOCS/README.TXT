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

FD13-LiveCD1.zip

    * FD13LIVE.ISO - FreeDOS LiveCD along with support for a Plain and Full
    installation. Requires 64MB of RAM (more recommended).

    Pros: Lower RAM requirement and superior management. In fact, using less
    than 64MB it is capable of bring up some portions of FreeDOS on a most
    important first basis. The more RAM you've got -- the bigger your temporary
    DOS drive will be. Uses less space on the LiveCD leaving more room for
    additional packages in the future. Also, it's also kinda cool to watch boot.

    Cons: Complex multi-stage startup process requires a little longer to boot.
    Some systems may have issues activating the RAM drive under FreeDOS.

FD13-LiveCD2.zip

    * FD13LIVE.ISO - FreeDOS LiveCD along with support for a Plain and Full
    installation. Requires 128MB of RAM.

    Pros: Faster boot time. SysLinux & Memdisk handle creation of a RAM drive
    and may have wider system support.

    Cons: Fixed DOS drive size and a very hard RAM requirement. Don't meet the
    requirement and the system will lockup on boot. Got gigabytes of RAM? Oh
    well, it will mostly be unused. Pre-installed packages that generate COM
    executable files in the %DOSDIR%\LINKS directory have issues. However,
    they do install fine when running the FreeDOS live from the CD.
