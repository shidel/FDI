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

        Loads configuration from STAGE000.BAT. This is where some of the
        built-in default settings are stored. Things like New Volume Label,
        OS Version and etc.

        if RECOVERY option was present at launceh, tests if this version of
        FreeDOS is already installed using STAGE001. If so, just exists to
        prompt with a welcome message. Otherwise, proceeds with installer.

        STAGE002, Loads current color scheme from either THEMENUL.BAT or
        if THEMEADV.BAT (Advanced Mode).

        If FDSETUP\SETUP\FDSPLASH.BAT exists, it is called. It might be good
        for displaying ascii art logo or something.

        STAGE003, Displays welcome to FreeDOS installer message. Offers to
        continue or exit.

        STAGE004, Checks if drive C exists. If not prompts user that C needs
        partitioned and offers to run fdisk or exit. If user selects fdisk,
        then offers to reboot or exit.

        STAGE005, Checks if drive C is readable. If not prompts user that C
        needs formatted and offers to format or exit. If user selects formats,
        then rechecks if C is readable. If not, offers to reboot or exit.

        STAGE006, Sets up temporary TEMP Directory so I/O redirection can
        function and for storage of a couple temporary files. If I/O
        redirection is still unavailable, it will abort the installation.

        NOTE: Now that a TEMP directory exists,  FDIWIND.BAT and other
        batch files that use I/O redirection and utilities like vmath can
        now be used.

        STAGE007, Calls all Installation configuration batch files named
        FDASK???.BAT located in the FDSETUP\SETUP directory.

        STAGE008, Prompts user that installation will now begin, Offers
        to continue or exit. Then, scans current FDSETUP\SETUP for all
        FDINS???.BAT files. The scans all other drives for
        \FDSETUP\SETUP\FDINS???.BAT files and calls them in that order to
        perform the installation.

        STAGE009, Informs user that installation is complete offers reboot or
        exit.

        STAGE999, Performs cleanup and is always run. It is only not run
        if the STAGE001 test for existing OS installation passes and the
        batch script is exiting without running the installer.

        Screen is cleared, reguardless of successful or failed installation.

        If install has failed due to an error and FDSETUP\SETUP\FDERROR.BAT
        exists it will be called now. You could set FREBOOT=y, to force reboot
        or display addition error information, suggestions on how  to correct
        the issue or some such thing.

        If user had selected reboot in STAGE009, it is done now.

        If install had completed and reboot was not selected AND
        FDSETUP\SETUP\FDTHANK.BAT exists it will be called last.

### Some global environment variables.

        OS_NAME     = Should always be "FreeDOS"
        OS_VERSION  = Current OS Version.

        FADV        = "y" if running in advanced mode.
        FDIDFMT     = "y" if during this execution the batch file formatted
                    drive C.
        FWAIT       = If your going to use vpause, This is how many seconds you
                    should pause. Example: vpause /t %FWAIT%

        FDEL        = Delay in milliseconds after non-interactive messages
                    are displayed.

        FREBOOT     = "" No effect when ending batch script.
                    = "n" will cause FDTHANK to be called at exit.
                    = "y" will cause reboot at exit.

        FERROR      = Error message to display when installer is aborted
                    or exited with an error.

        FTARGET     = installation path for FreeDOS.

        FBAK        = Backup path for previous OS version, when the zip
                    archive backup method is selected in advanced mode.

        FVERB       = When is 'y', more status messages appear.

        FMEDIA      = Is the path to the FreeDOS installation packages.

### Options configured by FDASK???.BAT files.

        OVOL        If drive is formatted, set its labal to this text
                    (actually OVOL is set in STAGE000)

        OBAK        Set in FDASK200. If an operating system is detected.
                    and user selects backup it will be set to "y". In advanced
                    mode user can select 'archive to zip' then it is set as
                    "z". If no OS was detected, or uses selects no backup it
                    will be set to "n"

        OCFG        Set in FDASK300. If in advanced mode, user can choose not
                    to replace existing configuration files.

        OCLEAN      Set in FDASK400. If in advanced mode, user can choose not
                    to remove all files in FreeDOS target directory before
                    installing.

        OSYS        Set in FDASK500. If user is in basic mode it is set to
                    "y" to transfer system boot files. In advanced mode,
                    it is set to either "y" or "n" depended on choice.


### Installer FDINS???.BAT scripts included on BOOT disk.

        Note:       When an FDINS???.BAT is called. The current drive and
                    directory are set automatically to the location of
                    the FDINS???.BAT file. Also, errorlevel must be 0 on
                    exit from the FDINS???.BAT script or the Installer
                    will assume failure and terminate. You may easily insure
                    that it continues by using "verrlvl 0" to clear any
                    existing errorlevel value. Also, any custom FDINS???.BAT
                    scripts should test the OS_NAME and OS_VERSION to
                    insure compatibility with the version of FreeDOS being
                    installed. Also, if you set FERROR, it will be displayed as
                    an error message when installer aborts.

        FDINS000    Debugging batch file. When FDEBUG=y, this will display
                    the current environment variables then wait. Otherwise,
                    it does nothing.

        FDINS100    Reserved.

        FDINS200    Creates a backup folder of OS and CONFIG files if OBAK
                    is set to "y". If it is "z" then a zip archive is created
                    and stored in C:\FDBACKUP\ directory. If "n", then
                    does nothing.

        FDINS300    Removes old configuration files when OCFG is "y".

        FDINS400    Removes old FreeDOS target directory when OCLEAN is "y"

        FDINS500    Transfers system files if OSYS is "y".

        FDINS600    Creates package lists used in FDINS700.

        FDINS700    Installs binary and source packages.

        FDINS800    Copy new configuration files, maybe.

        FDINS900    Install V8Power Tools from installer, maybe.


### Other batch files.

        FDCTRLC.BAT Code that is executed anytime the user presses CONTROL-C
                    at a vchoice or vpause. Provides 3 options, Return to
                    where you were, exit to dos or switch to/from advanced mode.

                    You do not "CALL" FDCTRLC.BAT you pass control to it and
                    provide the batch file and options you wish to maintain
                    if the user does not quit. The best example of this is
                    STAGE004.BAT can return to itself in two separate places.

        FDIWIND.BAT Functions only after STAGE006 runs. Creates a normal box
                    for text or choices. %1 is the total height of the box.
                    So, add 4 to how many lines you want. You want 1 line for
                    just one line of text "CALL FDIWIND.BAT 5"

        FDIOPTS.BAT Functions only after STAGE006. Creates an area to contain
                    choices for vchoice. %1 is total number of choices you
                    want.

        FDISCAN.BAT Used internally to scan for drives that may contain paths
                    that may contain FDINS???.BAT files.

        FDIFAIL.BAT Call FDIFAIL "message about failure" to inform the user
                    that the installation has failed. It offers to reboot
                    or exit to DOS. Afterwards, if exit to DOS was selected,
                    it will return to your script. You should then exit
                    you batch file with an errorlevel of 1 to prevent
                    futher processing of the installation.
