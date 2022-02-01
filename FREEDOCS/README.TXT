###############################################################################
		$OS_TITLE_LONG$ ("$OS_TITLE_SHORT$")
###############################################################################

-------------------------------------------------------------------------------
		General system requirements:
-------------------------------------------------------------------------------

  * DOS-compatible system (Intel + BIOS, or UEFI with Legacy support)

  * At least $REQ_BASE_MIN$ free disk space:

    $REQ_BASE_MIN$  Plain DOS system
    $REQ_BASE_MAX$  Plain DOS system, with sources

    $REQ_FULL_MIN$  Full installation including applications and games
    $REQ_FULL_MAX$  Full installation with sources


-------------------------------------------------------------------------------
		What's in all those zip files?
-------------------------------------------------------------------------------

$OS_PREFIX$-LiveCD.zip

  * $OS_PREFIX$BOOT.IMG - Basic $OS_NAME$ installation boot floppy image.
    If your computer has a CD-ROM drive, but you cannot boot from the Live CD
    or Legacy CD. Use this diskette image to boot the system. Then insert the
    install CD. The $OS_NAME$ installer should do the rest. This diskette
    image is for installation purposes only and does not provide a Live
    Environment.

  * $OS_PREFIX$LIVE.ISO - The $OS_TITLE_SHORT$ installer.  Most users should
    use this image to install $OS_NAME$.

    Depending on your computer system and hardware configuration, you
    can also use the LiveCD to boot and run $OS_NAME$ directly from the
    CD-ROM without installation to your hard drive.

$OS_PREFIX$-LegacyCD.zip

  * $OS_PREFIX$BOOT.IMG - This zip archive also contains a copy of the basic
    CD-ROM installation boot floppy.

  * $OS_PREFIX$LGCY.ISO - A bootable CD image designed for older hardware. If
    you cannot boot the LiveCD to install $OS_NAME$, try this disc image.

    This disc image uses the older El Torito boot CD format. Some newer
    computers and virtual machines cannot use this older format. Unless
    you have a computer that requires this type of bootable CD, we
    recommend using the LiveCD instead.

$OS_PREFIX$-BonusCD.zip

  * $OS_PREFIX$BNS.ISO - A non-bootable CD image that contains some $OS_NAME$
    packages that are not installed as part of either the LiveCD or
    the Legacy CD.

$OS_PREFIX$-LiteUSB.zip

  * $OS_PREFIX$LITE.IMG - A minimal $OS_NAME$ installer, as a USB fob drive
    image. This does not contain all of the packages from either the
    LiveCD or the LegacyCD, and instead only contains a basic set of
    $OS_NAME$ packages.

  * $OS_PREFIX$LITE.VMDK - A virtual machine disk file, compatible with a
    variety of virtual machine software including VirtualBox, VMware,
    and other systems.

    Using a VMDK file can simplify installing $OS_NAME$. Just attach the
    VMDK image to your virtual machine software as a hard drive, and
    boot it. (Please note that you will still need to create a virtual
    hard disk to install $OS_NAME$)

$OS_PREFIX$-FullUSB.zip

  * $OS_PREFIX$FULL.IMG - Plain DOS system and Full install USB stick image.

  * $OS_PREFIX$FULL.VMDK - A virtual machine disk file, compatible with a
    variety of virtual machine software. Just attach the VMDK image to
    your virtual machine as a hard drive, and boot it.

VERIFY.TXT

  * Contains MD5, SHA256 and SHA512 hashes for all of the different
    release files. You can verify your copy of $OS_NAME$ with these.

README.TXT

  * The "before you choose and install" document. (All of the zip
    files listed above also have a copy of the README file.)


-------------------------------------------------------------------------------
		$OS_NAME$ Floppy-Only Edition ($OS_PREFIX$-x86)
-------------------------------------------------------------------------------

$OS_NAME$ $OS_MAJOR_VERSION$ includes a Floppy-Only Edition! This edition should run on
any hardware that can run $OS_NAME$ and has EGA or better graphics:

  * Are you running a '286 or another classic system without a CD-ROM
    drive?  Install from these floppies to install $OS_NAME$.

  * Do you have just one hard drive and no CD or floppy drive? Just
    copy the contents of the floppies to a temporary directory and run
    the installer from there.

  * Want to perform a "headless" install to a different DOS directory?
    It's easy with the command line options.

The Floppy-Only Edition uses a completely different installer than
the CD-ROM or USB installers. The Floppy-Only Edition does not use
any of those other media to install.

The Floppy-Only Edition contains a limited set of $OS_NAME$ programs
that are more useful on classic PC hardware.

The $OS_NAME$ Floppy-Only Edition is distributed as single zip archive that
contains several pre-made floppy diskette images:

    These zip archives contain image files for several common floppy
    diskette media under separate directories:

    * 720k - 3.5" 720k diskette images

    * 144m - 3.5" 1.44mb diskette images

    * 120m - 5.25" 1.2mb diskette images

    Each of those sets contain a number of pre-made disk images:

    * x86BOOT.img - A floppy boot disk image with the x86 installer.

    * x86DSK??.img - Several floppy diskette images that contain the
      core $OS_NAME$ operating system files. The number of floppy images
      and amount of files on each varies depending on the diskette
      capacity.

To conserve space, the $OS_NAME$ Floppy-Only Edition does not contain
the source code for the $OS_NAME$ packages. You can find the source code
via the $OS_NAME$ website ($OS_DOWNLOAD$) or from
the other release media, like the USB or CD-ROM installer.


-------------------------------------------------------------------------------
		Support note regarding the Floppy-Only Edition
-------------------------------------------------------------------------------

As of $OS_TITLE_SHORT$, the CPU level detection algorithms in V8Power Tools
for DOS (used in the installer) need to be improved. Some systems may be
incorrectly reported to the installer as only having an 80186 CPU. When in
fact they might have a '286 or better processor. This will affect the software
installed by the $OS_NAME$ Floppy-Only Edition.

For this release, the installer will assume that the hardware has a '386 CPU
or better. When launching the SETUP.BAT installer, you can override CPU
detection by adding an option (like 8086, 186, 286, 386, 486, 586, 686, EMU,
QEMU, VBX, VMW or DBX) to force a specific CPU level to support.
