###############################################################################
$OS_NAME$ $OS_VERSION$ Installation media.
###############################################################################

-------------------------------------------------------------------------------
Some general system requirements.
-------------------------------------------------------------------------------

    A $OS_NAME$ FULL install with sources requires 450 MiB of free HD space.
    Without sources, 250 MiB of free space will be needed.

    A $OS_NAME$ PLAIN install with sources requires 50 MiB of free HD space.
    Without sources, 20 MiB of free space will be needed.

-------------------------------------------------------------------------------
What's in all those release ZIP files?
-------------------------------------------------------------------------------

readme.txt
    The simple "before you choose and install" document.
    (All zip archives contain a copy of this README file.)

verify.txt
    Contains MD5, SHA256 and SHA512 hashes for all of the different release
    files.

$OS_PREFIX$-Floppy.zip

    * FD13FLOP.IMG - Basic $OS_NAME$ installation boot floppy image for systems
    that support a CD-ROM. But, the system cannot boot from either of CD-ROM
    release media.

$OS_PREFIX$-LiteUSB.zip

    * FD13LITE.IMG - Plain DOS system only! This USB stick image does not
    contain all of the packages that are available in a FULL install. It only
    contains the basic plain DOS set of packages.

    * FD13LITE.VMDK - An Virtual Machine Disk description file to simplify
    attaching the LiteUSB image to a virtual machine (like VirtualBox and
    vmWare) as a hard drive.

$OS_PREFIX$-FullUSB.zip

    *$OS_PREFIX$FULL.IMG - Plain DOS system and Full install USB stick image.
    (Also, includes may extra packages that are not installed in the
    "Plain DOS" or even the "Full Install".  These extras can be installed
    later using FDIMPLES or another package manager)

    * $OS_PREFIX$FULL.VMDK - An Virtual Machine Disk description file to
    simplify attaching the FullUSB image to a virtual machine (like VirtualBox
    and vmWare) as a hard drive.

$OS_PREFIX$-LegacyCD.zip

    * $OS_PREFIX$LGCY.ISO - Contains all the packages as $OS_PREFIX$-FullUSB.
    However, it is a bootable CD image designed for older hardware. It uses the
    classic El Torito Boot CD-ROM format. Some modern computers and virtual
    machines are known to have issues booting CDs that use this ancient
    specification. Unless you have a computer that requires this type of
    bootable CD, we recommend using the LiveCD media.

$OS_PREFIX$-LiveCD.zip

    * $OS_PREFIX$LIVE.ISO - This media is similar to the LegacyCD. However,
    instead of relying on the BIOS floppy disk emulation, it uses SYSLINUX and
    MEMDISK to boot an emulated floppy disk. Along side support to perform a
    Plain and Full installation of $OS_NAME$, this media is also able to run
    $OS_NAME$ live from RAM or CD (depending on computer system and hardware)
    without installation to an internal hard disk drive.

$OS_PREFIX$-x86.ZIP

    New with $OS_NAME$ 1.3-RC3 is the Floppy Only Edition of $OS_NAME$. Compared
    to the other media, this edition uses a completely different installer and
    process. It is designed to be compatible with any hardware that can run
    $OS_NAME$ that has EGA or better graphics. Comprised of only a limited
    $OS_NAME$ set of core programs, it installs those packages based on
    hardware support. Only have a 286, then no need to install the CD-Drivers
    that require a 386. Just got one hard drive and no CD or Floppy? No
    problem! Just copy the contents of the floppies to some directory and
    run it from there. Want to perform a headless install to a different DOS
    directory, piece of cake with the command line options. The best way to
    sum-up $OS_PREFIX$-x86 is to say -- It is the power user installer.

    * x86-BOOT.img - A 720 Kib 3.5" floppy boot disk with the x86 installer.

    * x86-DSK?.img - Some 1.44 Mib 3.5" floppy diskette images that contain
    the archived OS files.

    Please note that to conserve space, the Floppy Diskette Edition does not
    contain the sources for the included packages. You can obtain those sources
    through the $OS_NAME$ website ($URL$) or from the other
    release media, like USB or CD-ROM. The Floppy Diskette Edition does not
    require any of those other media to perform an installation and will not
    use them during installation.

    * Please note, as of 1.3-RC4, the CPU level detection algorithms in
    V8Power Tools for DOS need improved. Some real hardware systems, report
    only 80186 level of support. This will effect the software installed by
    the FDI-x86 edition. For the time being, the installer will assume that
    the hardware has at least a 386 processer.  When launching the SETUP.BAT
    installer, you can override CPU detection by adding an option (like 8086,
    186, 286, 386, 486, 586, 686, EMU, QEMU, VBX, VMW or DBX) and force a
    specific lovel of CPU that is supported.

