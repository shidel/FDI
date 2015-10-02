# FreeDOS 1.2 Installer Prototype

This project is for creating the [FreeDOS](http://freedos.org) 1.2+ installation
kit based on [V8Power Tools](http://up.lod.bz/V8Power) batch file enhancement
utilities.

* * *

### File List

    README.md   - This file.
    LICENSE     - GNU GPL v2.
    mkFDI.bat   - Create the Floppy installation media.

### Build files in INSFILES\

    MKBIN.LST    List of files copyied from C:\FDOS\BIN\ to A:\FDSETUP\BIN\
    MKHELP.LST   List of files copyied from C:\FDOS\HELP\ to A:\FDSETUP\HELP\
    MKV8P.LST    List of files copyied from V8POWER\ to A:\FDSETUP\V8POWER\
    MKSETUP.LST  List of files copyied from INSFILES\ to A:\FDSETUP\SETUP\
    AUTOEXEC.BAT Copied as-is to A:\
    FDCONFIG.SYS Copied as-is to A:\
    SETUP.BAT    Copied as-is to A:\

### What the installer does.

    AUTOEXEC.BAT calls SETUP.BAT RECOVERY

    SETUP.BAT

        Tests for presence of V8Power Tools.
        Tests for I/O redirection support at present.
        Does some basic settings initialization.

        Loads configuration from STAGE000.bat

        if RECOVERY option was present at launceh, tests if this version of
        FreeDOS is already installed using STAGE001. If so, just exists to
        prompt with a welcome message. Otherwise, proceeds with installer.

        STAGE002, Loads current color scheme from either THEMENUL.BAT or
        if THEMEADV.BAT (Advanced Mode).

        STAGE003, Displays welcome to FreeDOS installer message. Offers to
        continue or exit.

        STAGE004, Checks if drive C exists. If not prompts user that C needs
        partitioned and offers to run fdisk or exit. If user selects fdisk,
        then offers to reboot or exit.

        STAGE005, Checks if drive C is readble. If not prompts user that C
        needs formatted and offers to format or exit. If user selects formats,
        then rechecks if C is readble. If not, offers to reboot or exit.

        STAGE006, Sets up temporary TEMP Directory so I/O redirection can
        function and for storage of a couple temporary files. If I/O
        redirection is still unavailable, it will abort the installation.

        NOTE: Now that a TEMP directory exists,  FDIWIND.BAT and other
        batch files that use I/O redirection for utilities like vmath can
        now be used.

        STAGE007, Calls all Installation configuration batch files named
        FDASK???.BAT located in the FDSETUP\SETUP directory.

        STAGE008, Prompts user that installation will now begin, Offers
        to continue or exit. Then, scans current FDSETUP\SETUP for all
        FDINS???.BAT files. The scans all other drives for
        \FDSETUP\SETUP\FDINS???.BAT files and calls them in that order to
        perform the installation.

        STAGE009, Informs user that instalation is complete offers reboot or
        exit.

        STAGE999, Performs cleanup and is always run. It is only not run
        if the STAGE001 test for existing OS installation passes and the
        batch script is exiting without running the installer.

        If user had selected reboot in STAGE009, it is done now.
