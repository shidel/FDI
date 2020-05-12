###############################################################################
FreeDOS 1.3-RC2 Installation media.
###############################################################################

-------------------------------------------------------------------------------
Some general system requirements.
-------------------------------------------------------------------------------

    A FreeDOS FULL install with sources requires 450 MiB of free HD space.
    Without sources, 250 MiB of free space will be needed.

    A FreeDOS PLAIN install with sources requires 50 MiB of free HD space.
    Without sources, 20 MiB of free space will be needed.

-------------------------------------------------------------------------------
What's in all those release ZIP files?
-------------------------------------------------------------------------------

README.TXT
    The simple "before you choose and install" document.
    (All zip archives contain a copy of this README file.)

verify.txt
    Contains MD5, SHA256 and SHA512 hashes for all of the different release
    files.

FD13-Floppy.zip

    * FD13FLOP.IMG - Basic FreeDOS installation boot floppy image for systems
    that support a CD-ROM. But, the system cannot boot from either of CD-ROM
    release media.

FD13-LiteUSB.zip

    * FD13LITE.IMG - Plain DOS system only! This USB stick image does not
    contain all of the packages that are available in a FULL install. It only
    contains the basic plain DOS set of packages.

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

FD13-LiveCD.zip

    * FD13LIVE.ISO - This media is similar to the LegacyCD. However instead
    of relying on the BIOS floppy disk emulation, it uses SYSLINUX and MEMDISK
    to boot an emulated floppy disk. Along side support to perform a Plain and
    Full installation of FreeDOS, this media is also able to run FreeDOS live
    from RAM or CD (depending on computer system and hardware) without
    installation to an internal hard disk drive.

FD13-x86.ZIP

    New with FreeDOS 1.3-RC3 is the Floppy Diskette Edition of FreeDOS. Compared
    to the other media, this edition uses a completely different installer and
    process. It is designed to be compatible with any hardware that can run
    FreeDOS. Comprised of only the FreeDOS core programs, it installs those
    packages based on hardware support. Only have a 286, then no need to install
    the CD-Drivers that require a 386. Just got one hard drive and no CD or
    Floppy? No problem. Just copy the contents of the floppies to some directory
    and run it from there. Want to perform a headless install to a different
    DOS directory, piece of cake with the command line options. The best way
    to sum-up FD13-x86 is to say -- It is the power user installer.

    * x86-BOOT.img - A 720 Kib 3.5" floppy boot disk with the FDI-x86 installer.

    * x86-D??.img - Some 1.44 Mib 3.5" floppy diskette images that contain
    the archived OS files.

    Please note that to conserve space, the Floppy Diskette Edition does not
    contain the sources for the included packages. You can obtain those sources
    through the FreeDOS website (http://www.freedos.org) or from the other
    release media, like USB or CD-ROM. The Floppy Diskette Edition does not
    require any of those other media to perform an installation and will not
    use them during installation.
