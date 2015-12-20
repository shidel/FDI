# FreeDOS 1.2 Installer Prototype

This project is for creating the [FreeDOS](http://freedos.org) 1.2+ installation
kit based on [V8Power Tools](http://up.lod.bz/V8Power) batch file enhancement
utilities.

* * *

### File List

    README.md   - This file.
    LICENSE     - GNU GPL v2.
    mkFDI.bat   - Create the Floppy installation media.

### Build files and directories

    FDIBUILD\FDIBUILD.CFG - Configuration file for FDINST.

    FDIBUILD\PACKAGES.LST - List of packages to use for install disk.

    FDIBUILD\CLEANUP.LST - Files/directories to be removed after all packages
    have been added to the install disk.

    FDISETUP\ - Contains installer files.

    LANGUAGE\ - Contains language translation directories and files for the
    installer.

    V8POWER\ - (Not included, but is required). A copy of the V8Power Tools
    binaries. Available from http://up.lod.bz/V8Power

    PACKAGES\ - If present, mkFDI will use these packages over any packages
    on the package repository disc. They will also be copied to the install
    disk and have priority over packages that will be on the install media.

    BINARIES\ - If present, mkFDI will copy any files to the install disks
    copy of the FreeDOS binaries and will overwrite any conflicting files.
    These files will not automatically be copied to the installation system.

### Creating the install media

    It basically has the same requirements as the installer. It just requires
    less free environment space. I've been using /E:1024 without issue.

    Download the latest V8Power Tools from http://up.lod.bz/V8Power/latest
    and place them in a V8POWER subdirectory.

    Create a FreeDOS package repository disc. One can be downloaded from
    http://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.1/repos/

    FDINST from the FDNPKG package must be installed.
    SHSUFDRV package must also be installed.
    A memory manager the can be used to allocate a 32Mb ram-disk. (like JEMM)

    Stick the CD in your CD drive.
    Stick a floppy to destroy in drive A:
    run mkFDI.BAT

    (Warning: all previous ramdisks will be shutdown!!)

### Installer requirements.

    FreeCom and 1024 bytes free enviroment space. (/E:2048 recommended)
    V8Power Tools located in path environment variable.
    (V8Power Tools requires an 8086+ or better cpu and EGA or better graphics)

### What the installer does.

    AUTOEXEC.BAT calls SETUP.BAT RECOVERY

    SETUP.BAT

        Tests for presence of V8Power Tools.
        Starts FDSETUP.BAT

    FDSETUP.BAT

        Tests for presence of V8Power Tools.
        Tests for I/O redirection support at present.
        Does some basic settings initialization.

        Loads configuration from STAGE000.BAT. This is where some of the
        built-in default settings are stored. Things like New Volume Label,
        OS Version and etc.

        If RECOVERY option was present at launceh, tests if this version of
        FreeDOS is already installed using STAGE100. If so, it just exists to
        the prompt with a welcome message. Otherwise, it proceeds with
        installation process.

        STAGE200, Loads current color scheme from either THEMEDEF.BAT or
        THEMEADV.BAT (Advanced Mode).

        If FDSETUP\SETUP\FDSPLASH.BAT exists, it is called. It might be good
        for displaying ascii art logo or something.

        STAGE300, Displays the "Welcome to FreeDOS" installer message and offers
        to continue or exit.

        STAGE400, Checks if drive C exists. If not, prompts user that C needs
        partitioned and offers to run fdisk or exit. If user selects fdisk,
        then it offers to reboot or exit.

        STAGE500, Checks if drive C is readable. If not, prompts user that C
        needs to be formatted and offers to format or exit. If user selected
        format, it formats and then rechecks if C is readable. If not, offers
        to reboot or exit.

        STAGE600, Sets up temporary TEMP Directory so I/O redirection can
        function.  Also, it provides for storage of a couple temporary files.
        If I/O redirection is still unavailable, it will abort the
        installation.

        NOTE: Now that a TEMP directory exists, batch files that use I/O
        redirection and utilities like vmath can now be used.

        STAGE700, Calls all Installation configuration batch files named
        FDASK???.BAT located in the FDSETUP\SETUP directory.

        STAGE800, Prompts user that installation will now begin, Offers
        to continue or exit. Then, scans current FDSETUP\SETUP for all
        FDINS???.BAT files.

        STAGE900, Informs user that installation is complete offers reboot or
        exit.

        STAGE999, Performs cleanup and is always run. It is only not run
        if the STAGE100 test for existing OS installation passes and the
        batch script is exiting without running the installer.

        Screen is cleared, reguardless of successful or failed installation.

        If install has failed due to an error and FDSETUP\SETUP\FDERROR.BAT
        exists it will be called now. You could set FREBOOT=y, to force reboot
        or display addition error information, suggestions on how  to correct
        the issue or some such thing.

        If user had selected reboot in STAGE900, it is done now.

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

        FDRIVE      = installation drive for FreeDOS.

        FTARGET     = installation path for FreeDOS.

        FBAK        = Backup path for previous OS version, when the zip
                    archive backup method is selected in advanced mode.

        FVERB       = When is 'y', more status messages appear. By default,
                    FVERB is "n" unless the installer is started with the
                    option "adv". Switching to advanced mode from within
                    the installer does not change this setting.

        FINSP       = Installer path, set in Stage600.

        FMEDIA      = Is the path to the FreeDOS installation packages.

        FPKGS       = Set in FPINS600 and points to list of binary packages
                    to be installed.

        FEXT        = File extension of new source AUTOEXEC.BAT and FDCONFIG.SYS
                    files that will be used to replace existing versions.
                    The default setting is "DEF". (AUTOEXEC.DEF, FDCONFIG.DEF)

        FLANG       = Current Language translation file.

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

        OALL        Set in FDASK600. If user wants all binary packages, it is
                    set to 'y'

        OSRC        Set in FDASK600. If user wans sources for selected packages
                    installed it is set to 'y'


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

        FDINS100    Configures package list options FPBIN and FPSRC to point
                    to their respective package list files to be used in
                    FDINS700 during package installation.

        FDINS200    Creates a backup folder of OS and CONFIG files if OBAK
                    is set to "y". If it is "z" then a zip archive is created
                    and stored in C:\FDBACKUP\ directory. If "n", then
                    does nothing.

        FDINS300    Remove old conflicting packages.

        FDINS400    Removes old FreeDOS target directory when OCLEAN is "y"

        FDINS500    Removes old configuration files when OCFG is "y".

        FDINS600    Transfers system files if OSYS is "y".

        FDINS700    Installs binary and source packages.

        FDINS800    Copy new configuration files, maybe. If so, also
                    creates the VERSION.FDI file for testing if this
                    version of the OS is already installed. It will use
                    the AUTOEXEC.DEF and FDCONFIG.DEF template files to
                    create the new configuration files. It will convert
                    $FLANG$ to the current %LANG%. Also, it will
                    replace $FDRIVE$ with the target drive (like C:) and
                    $FTARGET$ with the installation base directory (like
                    C:\FDOS).

        FDINS900    Install V8Power Tools from installer, maybe.


### Other batch files.

        FDCTRLC.BAT Code that is executed anytime the user presses CONTROL-C
                    at a vchoice or vpause. Provides 3 options, Return to
                    where you were, exit to dos or switch to/from advanced mode.

                    You do not "CALL" FDCTRLC.BAT you pass control to it and
                    provide the batch file and options you wish to maintain
                    if the user does not quit. The best example of this is
                    STAGE400.BAT can return to itself in two separate places.

        FDIFAIL.BAT Call FDIFAIL "message about failure" to inform the user
                    that the installation has failed. It offers to reboot
                    or exit to DOS. Afterwards, if exit to DOS was selected,
                    it will return to your script. You should then exit
                    you batch file with an errorlevel of 1 to prevent
                    futher processing of the installation. Note: if %1 is
                    "cc" and in advanced mode, then an additional option to
                    continue will be also displayed at some points during
                    the installation process.

        FDIPKG.BAT  Actual package installer. %1 is package name like "appendx".
                    It is run from the new freedos installation directory
                    %FTARGET% (probably "C:\FDOS") set errorlevel to 0 for
                    sucess, 1 for failure on leaving this batch.

        FDILANG.BAT Uses current %LANG% setting and %1, %2, %3... and %FADV%
                    to locate the current text translation file and point
                    %FLANG% to it.

        FDCHECK.BAT If it exists, use to test system for compatibilty prior to
                    installation of FreeDOS.

        FDSPLASH.BAT If it exists, use to display spash screen or logo prior to
                    the welcome message.

        FDERROR.BAT If it exists, use it to display custom error messages when
                    the installer exists.

        FDTHANK.BAT If it exists, use it to display a custom message after
                    the installer completes successfully just prior to
                    exiting the installer.

        FDNOTICE.BAT If run during the boot process and this version is
                     already installed, this file will be called instead of
                     automatically starting the installer.

### Other Data Files

        SETTINGS\PKG_ALL.LST  List of "All" package files.

        SETTINGS\PKG_BASE.LST List of "Base" package files.

        FDNPBIN.CFG  FDINST Package manager binaries only config file.

        FDNPSRC.CFG  FDINST Package manager source mode config file.

### FDI Roadmap

    Verify, sufficient disk space prior to install.

    Should, verify integrity of backup folder and zip backups.

    Should, in STAGE700, add detection if installing from a folder and skip
    searching for installation media. Just set FMEDIA to subdirectory. This
    is waiting on the layout of a ALPHA release to be configured.

    Probably, remove need to leave in install media to reboot.

    Maybe, add ability to install from Floppy only sources.

    Might, deploy a solution to adjust for the long perceived pauses during
    backup and some package installations. Not a bug, but it may appear
    "hung-up" do to many files being copied. Namely, a backup of a previous
    version that included source files, will stick for a long time around 37%
    while coping all the old sources.

    (These require some additional tools not yet created for V8Power Tools)

    Maybe, localization support in exit error messages.

    Someday, advanced mode, individual package selections.

### Known issues

    Stuff in the Roadmap.

    Package files that are not part of "BASE" that are located under the
    %DOSDIR% will be lost when doing a "Clean" install of FreeDOS.

    Will not detect Current OS version when it was installed to a directory
    other than the default "C:\FDOS" directory. Might add some common
    locations to check later. Might not. We will see.
