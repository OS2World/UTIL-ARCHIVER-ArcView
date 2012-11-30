/*:VRX         Main
*/
/*  Main
*/
Main:
/*  Process the arguments.
    Get the parent window.
*/
    parse source . calledAs .
    parent = ""
    argCount = arg()
    argOff = 0
    if( calledAs \= "COMMAND" )then do
        if argCount >= 1 then do
            parent = arg(1)
            argCount = argCount - 1
            argOff = 1
        end
    end; else do
        call VROptions 'ImplicitNames'
        call VROptions 'NoEchoQuit'
    end
    InitArgs.0 = argCount
    if( argCount > 0 )then do i = 1 to argCount
        InitArgs.i = arg( i + argOff )
    end
    drop calledAs argCount argOff

/*  Load the windows
*/
    call VRInit
    parse source . . spec
    _VREPrimaryWindowPath = ,
        VRParseFileName( spec, "dpn" ) || ".VRW"
    _VREPrimaryWindow = ,
        VRLoad( parent, _VREPrimaryWindowPath )
    drop parent spec
    if( _VREPrimaryWindow == "" )then do
        call VRMessage "", "Cannot load window:" VRError(), ,
            "Error!"
        _VREReturnValue = 32000
        signal _VRELeaveMain
    end

/*  Process events
*/
    call Init
    signal on halt
    do while( \ VRGet( _VREPrimaryWindow, "Shutdown" ) )
        _VREEvent = VREvent()
        interpret _VREEvent
    end
_VREHalt:
    _VREReturnValue = Fini()
    call VRDestroy _VREPrimaryWindow
_VRELeaveMain:
    call VRFini
exit _VREReturnValue

VRLoadSecondary:
    __vrlsWait = abbrev( 'WAIT', translate(arg(2)), 1 )
    if __vrlsWait then do
        call VRFlush
    end
    __vrlsHWnd = VRLoad( VRWindow(), VRWindowPath(), arg(1) )
    if __vrlsHWnd = '' then signal __vrlsDone
    if __vrlsWait \= 1 then signal __vrlsDone
    call VRSet __vrlsHWnd, 'WindowMode', 'Modal'
    __vrlsTmp = __vrlsWindows.0
    if( DataType(__vrlsTmp) \= 'NUM' ) then do
        __vrlsTmp = 1
    end
    else do
        __vrlsTmp = __vrlsTmp + 1
    end
    __vrlsWindows.__vrlsTmp = VRWindow( __vrlsHWnd )
    __vrlsWindows.0 = __vrlsTmp
    do while( VRIsValidObject( VRWindow() ) = 1 )
        __vrlsEvent = VREvent()
        interpret __vrlsEvent
    end
    __vrlsTmp = __vrlsWindows.0
    __vrlsWindows.0 = __vrlsTmp - 1
    call VRWindow __vrlsWindows.__vrlsTmp
    __vrlsHWnd = ''
__vrlsDone:
return __vrlsHWnd

/*:VRX         CHK_EXNAME_Click
*/
CHK_EXNAME_Click: PROCEDURE EXPOSE globals. settings. arcstem

    currentval = VRGet('EF_EXPATH', 'Value')
    currentval = STRIP( currentval, 'T', '\')

    IF VRGet('CHK_EXNAME', 'Set') == 1 THEN DO
        CALL VRSet 'EF_EXPATH', 'Value', currentval'\'arcstem
    END
    ELSE DO
        cutoff = LASTPOS('\'arcstem, currentval ) - 1
        IF cutoff < 0 THEN
            newval = currentval
        ELSE
            newval = SUBSTR( currentval, 1, cutoff )
        IF FILESPEC('PATH', newval ) == '' THEN CALL VRSet 'EF_EXPATH', 'Value', newval'\'
        ELSE                                    CALL VRSet 'EF_EXPATH', 'Value', newval
    END

RETURN

/*:VRX         DisplayContents
*/
DisplayContents: PROCEDURE EXPOSE globals. settings.

    globals.!currentType = VRInfo('type')
    CALL VRSet 'WN_MAIN', 'StatusText', ''
    CALL VRSet 'WN_MAIN', 'HintText',   ''

    /*
     * Update the flags field (there might already be flags defined if the
     * OpenFile thread was called twice, i.e. from ListPassword).
     */
    globals.!currentFlags = globals.!currentFlags || VRInfo('flags')

    CALL VRMethod 'Application', 'GetVar', 'entries.'

    /* Output the result */
    CALL VRSet VRWindow(),   'Pointer',  'WAIT'

    /* CALL VRSet 'CN_VIEWER',  'Painting', 0    */
    CALL VRMethod 'MLE_VIEWER', 'DisableRefresh'

    IF globals.!currentFlags == 'F' THEN DO
        /* Singly-compressed file; the lines of entries.x are as follows:
         *  1 - uncompressed filename
         *  2 - name of compression program used
         *  3 - compressed file size (optional)
         *  4 - file time & date (optional)
         *  5 - file attributes (optional)
         */
        filename = entries.1
        program  = entries.2
        _size     = ''
        _modified = ''
        _attrs    = ''
        IF entries.0 > 2 THEN _size     = entries.3
        IF entries.0 > 3 THEN _modified = entries.4
        IF entries.0 > 4 THEN _attrs    = entries.5
        DROP entries.

        /* Now generate a new entries. stem for our actual output.
         */
        entries.2 = filename ||'   '|| _modified ||'   '|| NLVGetMessage( 108, _size )
        entries.1 = COPIES('-', LENGTH( entries.2 ))
        entries.3 = entries.1
        entries.0 = 3
    END

    DO i = 1 TO entries.0
        CALL VRMethod 'MLE_VIEWER', 'Insert', entries.i || '0d0a'x
    END

    /* CALL VRSet 'CN_VIEWER', 'Painting', 1    */
    CALL VRMethod 'MLE_VIEWER', 'EnableRefresh'

    CALL VRSet VRWindow(),  'Pointer',  '<default>'

    CALL VRSet 'MI_OPEN',    'Enabled',  1
    CALL VRSet 'MI_EXTRACT', 'Enabled',  1
    CALL VRSet 'MI_CLOSE',   'Enabled',  1

    CALL VRSet VRWindow(), 'Caption', NLVGetMessage( 1 ) '-' VRParseFileName( globals.!currentFile, 'NE')                           /* 1: "Archive Viewer" */

    SELECT
        WHEN globals.!currentFlags == 'F'  THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 107, program )
        WHEN globals.!currentType == 'ZIP' THEN DO
            IF POS('V', globals.!currentFlags ) > 0 THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 121 )  /* 121: "is a multi-volume ZIP archive" */
            ELSE                                         stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 120 )  /* 120: "is a ZIP archive" */
        END
        WHEN globals.!currentType == 'RAR' THEN DO
            IF POS('V', globals.!currentFlags ) > 0 THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 123 )  /* 123: "is a multi-volume RAR archive" */
            ELSE                                         stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 122 )  /* 122: "is a RAR archive" */
        END
        WHEN globals.!currentType == 'ARJ' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 124 )           /* 124: "is an ARJ archive" */
        WHEN globals.!currentType == 'TAR' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 125 )           /* 125: "is a Unix tape archive" */
        WHEN globals.!currentType == 'TGZ' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 126 )           /* 126: "is a GZIP-compressed Unix tape archive" */
        WHEN globals.!currentType == 'TBZ' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 127 )           /* 127: "is a BZIP2-compressed Unix tape archive" */
        WHEN globals.!currentType == 'TZ'  THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 128 )           /* 128: "is a compressed Unix tape archive" */
        WHEN globals.!currentType == 'WPI' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 129 )           /* 129: "is a WarpIN archive" */
        WHEN globals.!currentType == 'LZH' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 130 )           /* 130: "is an LZH archive" */
        WHEN globals.!currentType == 'RPM' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 132 )           /* 132: "is an RPM package" */
        WHEN globals.!currentType == 'LZ'  THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 133 )           /* 133: "is an LZ-compressed Unix tape archive" */
        WHEN globals.!currentType == '7Z'  THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 134 )           /* 134: "is a 7Z archive" */
        OTHERWISE                               stext = VRParseFileName( globals.!currentFile, 'NE')
    END
    CALL VRSet VRWindow(), 'StatusText', stext

RETURN

/*:VRX         DisplayError
*/
DisplayError: PROCEDURE EXPOSE globals. settings.
    PARSE ARG error, status, type

    /* Values for status:
     *      0  Success
     *      1  Could not determine archive type
     *      2  Password required to view contents
     *      3  Archive handler not available
     *      4  Support not yet implemented
     *      5  Directory change/create failed
     *      9  Unknown error encountered
     */

    text.0 = 3
    text.1 = error
    text.2 = ''

    SELECT
        WHEN type == 'ZIP' THEN handler = 'UNZIP.EXE'
        WHEN type == 'RAR' THEN handler = 'UNRAR.EXE, RAR32.EXE, or RAR.EXE'
        WHEN type == 'ARJ' THEN handler = 'ARJ.EXE'
        WHEN type == 'TAR' THEN handler = 'TAR.EXE'
        WHEN type == 'TGZ' THEN handler = 'TAR.EXE' NLVGetMessage( 113 ) 'GZIP.EXE'       /* 113: "or" */
        WHEN type == 'TBZ' THEN handler = 'TAR.EXE' NLVGetMessage( 113 ) 'BZIP2.EXE'
        WHEN type == 'TZ'  THEN handler = 'TAR.EXE' NLVGetMessage( 113 ) 'COMPRESS.EXE'
        OTHERWISE               handler = NLVGetMessage( 112 )                            /* 112: "The appropriate file-type handler" */
    END

    SELECT
        WHEN status == 1 THEN text.3 = NLVGetMessage( 115 )                               /* 115: "Could not determine the archive type." */
        WHEN status == 2 THEN text.3 = NLVGetMessage( 116 )                               /* 116: "The archive header is encrypted; header decryption for this archive type has not yet been implemented." */
        WHEN status == 3 THEN text.3 = NLVGetMessage( 117, handler )                      /* 117: "%1 could not be found on your system." */
        WHEN status == 4 THEN text.3 = NLVGetMessage( 118 )                               /* 118: "Support for this archive type has not yet been implemented." */
        WHEN status == 5 THEN text.3 = NLVGetMessage( 119 )                               /* 119: "Unable to set the target directory." */
        OTHERWISE             text.3 = NLVGetMessage( 114 )                               /* 114: "Unknown error." */
    END

    buttons.0 = 1
    buttons.1 = NLVGetMessage( 2 )                                                        /* 2: "~OK" */

    ok = VRMessageStem( VRWindow(), 'text.', NLVGetMessage( 144 ), 'W', 'buttons.', 1 )   /* 144: "Problem" */

RETURN

/*:VRX         ExtractError
*/
ExtractError: PROCEDURE EXPOSE globals. settings.

    CALL VRSet 'WN_MAIN', 'StatusText', ''
    CALL VRSet 'WN_MAIN', 'HintText',   ''

    type   = VRInfo('type')
    status = VRInfo('status')

    CALL DisplayError NLVGetMessage( 111 ), status, type                             /* 111: "A problem was encountered when trying to extract the archive:" */

    CALL VRSet 'MI_OPEN',    'Enabled', 1
    CALL VRSet 'MI_EXTRACT', 'Enabled', 1
    CALL VRSet VRWindow(),   'Caption', NLVGetMessage( 1 ) '-' globals.!currentFile  /* 1: "Archive Viewer" */

RETURN

/*:VRX         ExtractFile
*/
ExtractFile: PROCEDURE EXPOSE globals. settings.
    PARSE ARG openwps, destination

    password = ''

    /*
     * Prompt for password if necessary.
     */
    IF ( POS('E', globals.!currentFlags ) > 0 ) | ( POS('H', globals.!currentFlags ) > 0 ) THEN DO
        action = 'EXTRACT'
        CALL VRLoadSecondary 'SW_PASSWORD', 'WAIT'
        DROP action
        IF password == '' THEN RETURN
    END

    tid = VRMethod('Application', 'StartThread', 'Extract', VRWindow(),,
                                                  globals.!currentFile,,
                                                  globals.!currentType,,
                                                  globals.!currentFlags,,
                                                  password, openwps, destination )
    IF tid = -1 THEN DO
        CALL VRSet VRWindow(), 'StatusText', NLVGetMessage( 145 )':' NLVGetMessage( 146 )       /* 145: "Error";  146: "could not start thread." */
        RETURN
    END

    CALL NLVSetText 'WN_MAIN', 'StatusText', 106
    CALL NLVSetText 'WN_MAIN', 'HintText',   106
    CALL VRSet 'WN_MAIN', 'Caption', NLVGetMessage( 1 ) '-' NLVGetMessage( 103 )

    CALL VRSet 'MI_EXTRACT', 'Enabled',  0
    CALL VRSet 'MI_OPEN',    'Enabled',  0
    CALL VRSet 'MLE_VIEWER', 'Value', ''

RETURN

/*:VRX         ExtractPassword
*/
ExtractPassword:
    /*
     * This method is called when the Extract thread discovers that the provided
     * password is incorrect (and terminates).  We prompt for the correct
     * password, then call the Extract thread again (unless the user cancels).
     */

    globals.!currentFlags = VRInfo('flags')

    password = ''
    action = 'EXTRACT'
    CALL VRLoadSecondary 'SW_PASSWORD', 'WAIT'
    DROP action
    IF password == '' THEN DO   /* User cancelled, return to normal state */
        CALL VRSet 'WN_MAIN', 'StatusText', ''
        CALL VRSet 'WN_MAIN', 'HintText', ''
        CALL SetNoFile
    END
    ELSE DO
        globals.!currentPassword = password
        tid = VRMethod('Application', 'StartThread', 'OpenFile', VRWindow(), globals.!currentFile, password )
        IF tid = -1 THEN DO
            CALL VRSet VRWindow(), 'StatusText', NLVGetMessage( 145 )':' NLVGetMessage( 146 )       /* 145: "Error";  146: "could not start thread." */
            RETURN
        END
    END

RETURN

/*:VRX         Fini
*/
Fini:
    window = VRWindow()
    call VRSet window, "Visible", 0
    drop window
return 0

/*:VRX         FinishExtraction
*/
/*
 * Displays the results of extraction in the viewer window.
 */
FinishExtraction: PROCEDURE EXPOSE globals. settings.

    CALL VRSet 'WN_MAIN', 'StatusText', ''
    CALL VRSet 'WN_MAIN', 'HintText',   ''

    CALL VRMethod 'Application', 'GetVar', 'entries.'
    openview = VRInfo('open')
    destpath = VRInfo('destination')

    /* Output the result */
    CALL VRSet VRWindow(),   'Pointer',  'WAIT'
    CALL VRMethod 'MLE_VIEWER', 'DisableRefresh'

    IF globals.!currentFlags == 'F' THEN DO
        /* Singly-compressed file; the lines of entries.x are as follows:
         *  1 - program return code
         *  2 - name of decompressed file
         */
        _result = entries.1
        _output = entries.2
        DROP entries.

         /* Generate a new entries. stem for output.
          */
        CALL SysFileTree destpath'\'_output, 'file_info.', 'FL'
        IF _result == 0 & file_info.0 == 1 THEN DO
            PARSE VAR file_info.1 _date _time _size _attrs _fullname
            entries.2 = _fullname ' ' _size ' ',
                        TRANSLATE( _attrs, ,
                                   'abcdefghijklmnopqrstuvwxyz',,
                                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ') ' ',
                         _date _time
            entries.1 = COPIES('-', LENGTH( entries.2 ))
            entries.3 = entries.1
            entries.0 = 3
        END
        ELSE DO
            entries.1 = NLVGetMessage( 111 ) 'RC =' _result                                                 /* 111: "A problem was encountered when trying to extract the archive:" */
            entries.0 = 1
        END
    END

    DO i = 1 TO entries.0
        CALL VRMethod 'MLE_VIEWER', 'Insert', entries.i || '0d0a'x
    END
    CALL VRMethod 'MLE_VIEWER', 'Insert', '0d0a'x || NLVGetMessage( 104 ) || '0d0a'x                        /* 104: "Done." */

    CALL VRMethod 'MLE_VIEWER', 'EnableRefresh'
    CALL VRSet VRWindow(),  'Pointer',  '<default>'

    CALL VRSet 'MI_EXTRACT', 'Enabled',  1
    CALL VRSet 'MI_OPEN',    'Enabled',  1

    CALL VRSet VRWindow(), 'Caption', NLVGetMessage( 1 ) '-' VRParseFileName( globals.!currentFile, 'NE')   /* 1: "Archive Viewer" */

    IF openview == 1 THEN DO
        /*
         * Open the folder in the WPS.  (Note that root directories require
         * some special handling.)
         */
        destpath = STRIP( destpath, 'T', '\')
        IF ( FILESPEC('PATH', destpath ) == '') & ( FILESPEC('NAME', destpath ) == '') THEN DO
            /* swname = 'Drive' STRIP( FILESPEC('DRIVE', destpath ), 'T', ':') */
            ok = SysOpenObject( destpath, 'DEFAULT', 'TRUE')
            IF ok == 1 THEN CALL SysOpenObject destpath, 'DEFAULT', 'TRUE'
        END
        ELSE DO
            destpath = STRIP( destpath, 'T', '\')
            swname   = FILESPEC('NAME', destpath )
            ok = SysOpenObject( destpath, 'DEFAULT', 'TRUE')
            IF ok == 1 THEN CALL SysSwitchSession swname
        END
        IF ok \= 1 THEN
            CALL VRMessage VRWindow(), NLVGetMessage( 147 ), NLVGetMessage( 144 ), 'W'                      /* 144: "Problem";  147: "Unable to open folder view." */
    END

RETURN

/*:VRX         Halt
*/
Halt:
    signal _VREHalt
return

/*:VRX         Init
*/
Init:

    NUMERIC DIGITS 13

    IF RxFuncQuery('SysGetMessage') == 1 THEN DO
        CALL RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs'
        CALL SysLoadFuncs
    END

    /*
     * Initialize settings to defaults (in case no INI file exists)
     */
    settings.!locale = ''
    settings.!x      = -1
    settings.!y      = -1
    settings.!width  = 0
    settings.!height = 0
    settings.!bgclr   = 'EntryField'
    settings.!fgclr   = 'Black'
    settings.!font    = '6.System VIO'
    settings.!dlgfont = '9.WarpSans'

    /*
     * Load the program settings
     */
    CALL SetupPreferences
    fLang = SetupLanguage( settings.!locale )
    IF fLang == 0 THEN CALL Quit

    /*
     * Hide the VX-REXX console window
     */
    CALL VRSet 'Console', 'WindowListTitle', ''

    /*
     * Display the program window
     */
    window = VRWindow()
    CALL VRSet window,    'Visible', 1
    CALL VRMethod window, 'Activate'
    DROP window

    /*
     * Initialize the current-file data
     */
    CALL SetNoFile

    /*
     * Get command-line arguments
     */
    IF InitArgs.0 > 0 THEN DO
        filename = strip( InitArgs.1, 'B', '"')
        CALL OpenArchive filename
    END

RETURN
/*:VRX         LB_EXDIRS_DoubleClick
*/
LB_EXDIRS_DoubleClick:

    selidx = VRGet('LB_EXDIRS', 'Selected')
    IF selidx == 0 THEN RETURN

    seltype  = VRMethod('LB_EXDIRS', 'GetItemData', selidx )
    selected = VRGet('LB_EXDIRS', 'SelectedString')
    oldpath  = STRIP( VRGet('LB_EXDIRS', 'UserData'), 'T', '\')

    IF TRANSLATE( LEFT( seltype, 1 )) == 'D' THEN DO
        newpath = SUBSTR( selected, 2, 2 )
    END
    ELSE DO
        IF selected == '..' THEN
            newpath = FILESPEC('DRIVE', oldpath ) || FILESPEC('PATH', oldpath )
        ELSE
            newpath = oldpath'\'selected
    END

    CALL SW_EXTRACT_OpenDir( newpath )

    DROP selected
    DROP seltype
    DROP selidx
    DROP oldpath
    DROP newpath

RETURN

/*:VRX         ListError
*/
ListError: PROCEDURE EXPOSE globals. settings.

    type   = VRInfo('type')
    status = VRInfo('status')

    CALL VRSet 'WN_MAIN', 'StatusText', ''
    CALL VRSet 'WN_MAIN', 'HintText',   ''

    CALL DisplayError NLVGetMessage( 110 ), status, type    /* 110: "A problem was encountered when trying to read the archive contents:" */
    CALL SetNoFile

RETURN

/*:VRX         ListPassword
*/
/* Handle the case when an archive's table of contents is password-protected. */
ListPassword: PROCEDURE EXPOSE globals. settings.

    /*
     * This method is called when the OpenFile thread discovers that a password
     * is required (and terminates).  We prompt for the password, then call the
     * OpenFile thread again, this time passing the password in.
     */

    globals.!currentFlags = VRInfo('flags')

    password = ''
    action = 'LIST'
    CALL VRLoadSecondary 'SW_PASSWORD', 'WAIT'
    DROP action
    IF password == '' THEN DO   /* User cancelled, return to normal state */
        CALL VRSet VRWindow(), 'StatusText', ''
        CALL VRSet VRWindow(), 'HintText', ''
        CALL SetNoFile
    END
    ELSE DO
        globals.!currentPassword = password
        tid = VRMethod('Application', 'StartThread', 'OpenFile', VRWindow(), globals.!currentFile, password )
        IF tid = -1 THEN DO
            CALL VRSet VRWindow(), 'StatusText', NLVGetMessage( 145 )':' NLVGetMessage( 146 )       /* 145: "Error";  146: "could not start thread." */
            RETURN
        END
    END

RETURN

/*:VRX         MakePath
*/
/*
 * Creates a new directory even if its parent directory does not exist.
 */
MakePath: PROCEDURE
    ARG path

    /* not implemented */

RETURN ok

/*:VRX         MI_ABOUT_Click
*/
MI_ABOUT_Click:
    CALL VRLoadSecondary 'SW_ABOUT', 'WAIT'
RETURN

/*:VRX         MI_CLOSE_Click
*/
MI_CLOSE_Click:
    CALL VRSet 'MLE_VIEWER', 'Value', ''
    CALL SetNoFile
RETURN

/*:VRX         MI_EXIT_Click
*/
MI_EXIT_Click:
    CALL Quit
RETURN

/*:VRX         MI_EXTRACT_Click
*/
MI_EXTRACT_Click:

    /*
     * Get the extract destination from the user.
     */
    vwrfont = VRGet('MLE_VIEWER', 'Font')
    CALL VRLoadSecondary 'SW_EXTRACT', 'WAIT'
    DROP vwrfont
    IF exdir == '' THEN RETURN

    /*
     * Do a couple of sanity checks on this destination.
     */
    IF VRFileExists( exdir ) == 1 THEN DO
        IF VRIsDir( exdir ) == 0 & ( FILESPEC('PATH', exdir ) \= '') THEN DO
            CALL VRMessage VRWindow(), NLVGetMessage( 140, exdir ), NLVGetMessage( 141 ), 'E'   /* 140: "A file named %1 already exists.";  141: "File Exists" */
            RETURN
        END
        CALL SysFileTree exdir'\*', 'files.', 'O'
        IF ( files.0 > 0 ) & ( globals.!currentType <> 'LHA') THEN DO
            btn.1    = NLVGetMessage( 5 )                                                       /* 5: "C~ontinue" */
            btn.2    = NLVGetMessage( 3 )                                                       /* 3: "~Cancel" */
            btn.0    = 2
            exfile   = VRParseFileName( globals.!currentFile, 'NE')
            warntext = NLVGetMessage( 142, exdir, exfile )                                      /* 142: "This action will overwrite any existing files under %1 which also exist in %2." */
            ok = VRMessage( VRWindow(), warntext, NLVGetMessage( 143 ), 'W', 'btn.', 1, 2 )     /* 143: "Warning" */
            DROP btn.
            IF ok \= 1 THEN RETURN
        END
    END

    CALL ExtractFile openwp, exdir

RETURN

/*:VRX         MI_FIND_Click
*/
MI_FIND_Click:

return

/*:VRX         MI_FINDAGAIN_Click
*/
MI_FINDAGAIN_Click:

return

/*:VRX         MI_HELP_CONTENTS_Click
*/
MI_HELP_CONTENTS_Click:
    CALL VRMethod 'MI_HELP_CONTENTS', 'InvokeHelp'
RETURN

/*:VRX         MI_HELP_INTRO_Click
*/
MI_HELP_INTRO_Click:
    CALL VRMethod 'MI_HELP_INTRO', 'InvokeHelp'
RETURN

/*:VRX         MI_HELP_USING_Click
*/
MI_HELP_USING_Click:
    CALL VRMethod 'MI_HELP_USING', 'InvokeHelp'
RETURN

/*:VRX         MI_OPEN_Click
*/
MI_OPEN_Click:
    CALL SelectFile
RETURN

/*:VRX         MI_STATUSFONT_Click
*/
MI_STATUSFONT_Click:

    currentFont = VRGet( VRWindow(), 'StatusFont')
    newFont = VRFontDialog( VRWindow(), currentFont, NLVGetMessage( 67 ))   /* 67: "Select Font" */
    IF newFont == '' THEN RETURN

    CALL VRSet VRWindow(), 'StatusFont', newFont
    stext = VRGet( VRWindow(), 'StatusText')
    CALL VRSet VRWindow(), 'StatusText', ''
    CALL VRSet VRWindow(), 'StatusText', stext

RETURN

/*:VRX         MI_VIEWERFONT_Click
*/
MI_VIEWERFONT_Click:

    currentFont = VRGet('MLE_VIEWER', 'Font')
    newFont = VRFontDialog( VRWindow(), currentFont, NLVGetMessage( 67 ))   /* 67: "Select Font" */
    IF newfont == '' THEN RETURN
    CALL VRSet 'MLE_VIEWER', 'Font', newFont

RETURN

/*:VRX         MI_WRAP_Click
*/
MI_WRAP_Click:
    checked = VRGet('MI_WRAP', 'Checked')
    ok = VRSet('MLE_VIEWER', 'WordWrap', \checked )
    CALL VRSet 'MI_WRAP', 'Checked', \checked
RETURN

/*:VRX         MLE_VIEWER_DragDrop
*/
MLE_VIEWER_DragDrop: PROCEDURE EXPOSE globals. settings.

    _contnr = STRIP( VRInfo('ContainerName'), 'T', '\')
    _name   = STRIP( VRInfo('SourceName'), 'B', '\')
    _format = TRANSLATE( VRInfo('NativeFormat'), '>', ')')
    _file   = _contnr'\'_name

    PARSE UPPER VAR _format '<' _fmt1 ',' _fmt2 '>' .
    _fmt1 = STRIP( _fmt1 )
    _fmt2 = STRIP( _fmt2 )
    IF _fmt1 <> 'DRM_OS2FILE' THEN RETURN

    /* A locale object (reported as DRF_BITMAP for some reason) was dropped.
     */
    IF ( _contnr == '.') & ( _fmt2 == 'DRF_BITMAP') THEN
        CALL NewLocale _name

    /* A file was dropped.
     */
    ELSE IF VRFileExists( _file ) == 1 THEN
        CALL OpenArchive _file

RETURN

/*:VRX         NewLocale
*/
NewLocale: PROCEDURE EXPOSE globals. settings.
    PARSE ARG localespec

    PARSE VAR localespec _locale '.' _codepage'.' .
    PARSE VAR _locale 1 _loclang 3 '_' _locctry 6 .
    IF _loclang == '' _locctry == '' THEN RETURN

    /* Update the UI text
     */
    IF SetupLanguage( _locale ) == 0 THEN
        RETURN
    settings.!locale = _locale

    /* Update the status text based on the current open-file state.
     */
    IF globals.!currentFile == '' THEN DO
        CALL VRSet VRWindow(),   'StatusText', NLVGetMessage( 100 )     /* 100: "No file is currently open" */
    END
    ELSE DO
        CALL VRSet VRWindow(), 'Caption', NLVGetMessage( 1 ) '-' VRParseFileName( globals.!currentFile, 'NE')                           /* 1: "Archive Viewer" */
        SELECT
            WHEN globals.!currentType == 'ZIP' THEN DO
                IF POS('V', globals.!currentFlags ) > 0 THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 121 )  /* 121: "is a multi-volume ZIP archive" */
                ELSE                                         stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 120 )  /* 120: "is a ZIP archive" */
            END
            WHEN globals.!currentType == 'RAR' THEN DO
                IF POS('V', globals.!currentFlags ) > 0 THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 123 )  /* 123: "is a multi-volume RAR archive" */
                ELSE                                         stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 122 )  /* 122: "is a RAR archive" */
            END
            WHEN globals.!currentType == 'ARJ' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 124 )           /* 124: "is an ARJ archive" */
            WHEN globals.!currentType == 'TAR' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 125 )           /* 125: "is a Unix tape archive" */
            WHEN globals.!currentType == 'TGZ' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 126 )           /* 126: "is a GZIP-compressed Unix tape archive" */
            WHEN globals.!currentType == 'TBZ' THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 127 )           /* 127: "is a BZIP2-compressed Unix tape archive" */
            WHEN globals.!currentType == 'TZ'  THEN stext = VRParseFileName( globals.!currentFile, 'NE') NLVGetMessage( 128 )           /* 128: "is a compressed Unix tape archive" */
            OTHERWISE                               stext = VRParseFileName( globals.!currentFile, 'NE')
        END
        CALL VRSet VRWindow(), 'StatusText', stext
    END

RETURN

/*:VRX         NLVGetMessage
*/
/*
 * Gets the message text associated with the given message number from the
 * current language file.
 */
NLVGetMessage: PROCEDURE EXPOSE settings.
    PARSE ARG msgnum, .
    args = ARG()

    msgfile = settings.!messages
    IF msgnum == '' THEN RETURN ''

    sub_parms = ''
    DO i = 2 TO args
        sub_parms = sub_parms', "'ARG( i )'"'
    END

    INTERPRET 'msgfromfile = SysGetMessage( msgnum, msgfile' sub_parms ')'

    PARSE VAR msgfromfile message '0D'x .
    IF SUBSTR( message, 1, 4 ) == 'SYS0' THEN message = ''

RETURN message

/*:VRX         NLVSetText
*/
/*
 * Sets the specified property of the specified control to the specified
 * message text.
 */
NLVSetText: PROCEDURE EXPOSE settings.
    PARSE ARG control, property, message, substitution
    args = ARG()

    success = 1
    IF args < 4 THEN
        text = NLVGetMessage( message )
    ELSE DO
        sub_parms = ''
        DO i = 4 TO args
            sub_parms = sub_parms '"'|| ARG( i ) ||'",'
        END
        sub_parms = STRIP( sub_parms, 'T', ',')
        INTERPRET 'text = NLVGetMessage( message, 'sub_parms')'
    END

    IF text == '' THEN success = 0
    ELSE               CALL VRSet control, property, text

RETURN success

/*:VRX         OpenArchive
*/
OpenArchive: PROCEDURE EXPOSE globals. settings.
    ARG filearg

    filename = STREAM( filearg, 'C', 'QUERY EXISTS')

    tid = VRMethod('Application', 'StartThread', 'OpenFile', VRWindow(), filename )
    IF tid = -1 THEN DO
        CALL VRSet 'WN_MAIN', 'StatusText', NLVGetMessage( 145 )':' NLVGetMessage( 146 )       /* 145: "Error";  146: "could not start thread." */
        RETURN
    END

    CALL NLVSetText 'WN_MAIN', 'StatusText', 105
    CALL NLVSetText 'WN_MAIN', 'HintText',   105
    CALL VRSet 'WN_MAIN', 'Caption', NLVGetMessage( 1 ) '-' NLVGetMessage( 102 )

    CALL VRSet 'MI_EXTRACT', 'Enabled',  0
    CALL VRSet 'MI_OPEN',    'Enabled',  0

    CALL VRSet 'MLE_VIEWER', 'Value', ''

    globals.!currentFile  = filename
    globals.!currentPath  = VRParseFileName( filename, 'DP')
    globals.!currentName  = VRParseFileName( filename, 'N')
    globals.!currentType  = ''
    globals.!currentFlags = ''

RETURN

/*:VRX         PB_ABOUTOK_Click
*/
PB_ABOUTOK_Click:
    CALL SW_ABOUT_Close
return

/*:VRX         PB_EXCANCEL_Click
*/
PB_EXCANCEL_Click:
    exdir = ''
    CALL SW_EXTRACT_Close
RETURN

/*:VRX         PB_EXHELP_Click
*/
PB_EXHELP_Click:
    CALL VRMethod 'SW_EXTRACT', 'InvokeHelp'
RETURN

/*:VRX         PB_EXOK_Click
*/
PB_EXOK_Click:
    exdir  = VRGet('EF_EXPATH',   'Value')
    openwp = VRGet('CHK_OPENWPS', 'Set')
    CALL SW_EXTRACT_Close
RETURN

/*:VRX         PB_PWCANCEL_Click
*/
PB_PWCANCEL_Click:
    CALL SW_PASSWORD_Close
RETURN

/*:VRX         PB_PWHELP_Click
*/
PB_PWHELP_Click:
    CALL VRMethod 'SW_PASSWORD', 'InvokeHelp'
RETURN

/*:VRX         PB_PWOK_Click
*/
PB_PWOK_Click:
    password = VRGet('EF_PASSWORD', 'Value')
    CALL SW_PASSWORD_Close
RETURN

/*:VRX         Quit
*/
Quit:

    CALL SavePreferences

    window = VRWindow()
    CALL VRSet window, 'Shutdown', 1
    DROP window

RETURN

/*:VRX         SavePreferences
*/
SavePreferences: PROCEDURE EXPOSE settings.

    bgclr   = VRGet('MLE_VIEWER', 'BackColor')
    fgclr   = VRGet('MLE_VIEWER', 'ForeColor')
    vwrfont = VRGet('MLE_VIEWER', 'Font')
    dlgfont = VRGet('WN_MAIN',    'StatusFont')
    wrap    = VRGet('MI_WRAP',    'Checked')

    xpos   = VRGet( VRWindow(), 'Left')
    ypos   = VRGet( VRWindow(), 'Top')
    width  = VRGet( VRWindow(), 'Width')
    height = VRGet( VRWindow(), 'Height')

    IF settings.!locale <> '' THEN
        CALL VRSetIni 'Archive Viewer', 'Locale', settings.!locale, settings.!ini, 'NoClose'

    CALL VRSetIni 'Archive Viewer', 'XPos',   xpos,   settings.!ini, 'NoClose'
    CALL VRSetIni 'Archive Viewer', 'YPos',   ypos,   settings.!ini, 'NoClose'
    CALL VRSetIni 'Archive Viewer', 'Width',  width,  settings.!ini, 'NoClose'
    CALL VRSetIni 'Archive Viewer', 'Height', height, settings.!ini, 'NoClose'

    CALL VRSetIni 'Archive Viewer', 'Background', bgclr,   settings.!ini, 'NoClose'
    CALL VRSetIni 'Archive Viewer', 'Foreground', fgclr,   settings.!ini, 'NoClose'
    CALL VRSetIni 'Archive Viewer', 'Font',       vwrfont, settings.!ini, 'NoClose'
    CALL VRSetIni 'Archive Viewer', 'DialogFont', dlgfont, settings.!ini, 'NoClose'
    CALL VRSetIni 'Archive Viewer', 'Wrap',       wrap,    settings.!ini

RETURN

/*:VRX         SelectFile
*/
SelectFile: PROCEDURE EXPOSE globals. settings.

    IF globals.!currentPath = '' THEN
        filename = VRFileDialog( VRWindow(), NLVGetMessage( 101 ), 'O')                                 /* 101: "Select File" */
    ELSE
        filename = VRFileDialog( VRWindow(), NLVGetMessage( 101 ), 'O', globals.!currentPath || '\*')

    IF filename \= '' THEN CALL OpenArchive filename

RETURN

/*:VRX         SetNoFile
*/
/*
 * Resets the current-file data to none.
 */
SetNoFile: PROCEDURE EXPOSE globals. settings.

    globals.!currentFile     = ''
    globals.!currentPath     = ''
    globals.!currentName     = ''
    globals.!currentType     = ''
    globals.!currentFlags    = ''
    globals.!currentPassword = ''

    CALL VRSet 'MI_OPEN',    'Enabled', 1
    CALL VRSet 'MI_EXTRACT', 'Enabled', 0
    CALL VRSet 'MI_CLOSE',   'Enabled', 0
    CALL VRSet VRWindow(),   'Caption',    NLVGetMessage( 1 )       /* 1: "Archive Viewer" */
    CALL VRSet VRWindow(),   'StatusText', NLVGetMessage( 100 )     /* 100: "No file is currently open" */

RETURN

/*:VRX         SetupContainer
*/
SetupContainer: PROCEDURE EXPOSE cnrFields.

    cnrFields.!icon = VRMethod('CN_VIEWER', 'AddField', Icon )
    cnrFields.!name = VRMethod('CN_VIEWER', 'AddField', String, 'File')
    cnrFields.!size = VRMethod('CN_VIEWER', 'AddField', String, 'Size')
    cnrFields.!time = VRMethod('CN_VIEWER', 'AddField', String, 'Time')
    cnrFields.!date = VRMethod('CN_VIEWER', 'AddField', String, 'Date')
    cnrFields.!idx  = VRMethod('CN_VIEWER', 'AddField', String, 'Index')

    CALL VRMethod 'CN_VIEWER', 'SetFieldAttr', cnrFields.!icon, 'VertSeparator', '0', 'HorizSeparator', '0'
    CALL VRMethod 'CN_VIEWER', 'SetFieldAttr', cnrFields.!name, 'VertSeparator', '0'
    CALL VRMethod 'CN_VIEWER', 'SetFieldAttr', cnrFields.!size, 'VertSeparator', '0'
    CALL VRMethod 'CN_VIEWER', 'SetFieldAttr', cnrFields.!time, 'VertSeparator', '0'
    CALL VRMethod 'CN_VIEWER', 'SetFieldAttr', cnrFields.!date, 'VertSeparator', '0'
    CALL VRMethod 'CN_VIEWER', 'SetFieldAttr', cnrFields.!idx,  'VertSeparator', '0', 'Visible', '0'

RETURN

/*:VRX         SetupLanguage
*/
SetupLanguage: PROCEDURE EXPOSE globals. settings.
    PARSE ARG _locale

    /*
     * This function locates the proper language files, and uses the message
     * file to sets all UI text.  If the language could not be determined, we
     * default to English.
     */

    execPath = VRGet("Application", "Program")
    execDir  = VRParseFileName( execPath, "DP")

    /*
     * First, figure out what language/message file to use.
     */
    IF _locale <> '' THEN
        syslanguage = _locale
    ELSE
        syslanguage = VALUE('LANG',,'OS2ENVIRONMENT')

    SELECT
        WHEN TRANSLATE( syslanguage ) == 'ZH_TW' THEN nlv = 'tw'
        WHEN TRANSLATE( syslanguage ) == 'ZH_CN' THEN nlv = 'cx'
        OTHERWISE                                PARSE VAR syslanguage nlv '_' .
    END
    IF ( STREAM( execDir'\arcv_'nlv'.msg', 'C', 'QUERY EXISTS') \= '') | ( SysSearchPath('DPATH', 'arcv_'nlv'.msg') \= '') THEN DO
        settings.!messages = 'arcv_'nlv'.msg'
        helpfile           = 'arcv_'nlv'.hlp'
        CALL VRSet 'WN_MAIN', 'HelpFile', helpfile
    END
    ELSE DO
        settings.!messages = 'arcv_en.msg'
        helpfile           = 'arcv_en.hlp'
        CALL VRSet 'WN_MAIN', 'HelpFile', helpfile
    END

    /*
     * If the message file is missing or unreadable, display an error and then exit.
     */
    IF NLVGetMessage( 1 ) == '' THEN DO
        CALL VRMessage VRWindow(), 'Language file' TRANSLATE( settings.!messages ) 'could not be loaded.', 'Cannot Continue', 'E'
        RETURN 0
    END


    /*
     * Now set the captions for the UI controls on the main window, according
     * to the specified language.
     */
    CALL NLVSetText 'WN_MAIN',          'Caption', 1
    CALL NLVSetText 'MN_FILE',          'Caption', 10
    CALL NLVSetText 'MI_OPEN',          'Caption', 11
    CALL NLVSetText 'MI_EXTRACT',       'Caption', 12
    CALL NLVSetText 'MI_CLOSE',         'Caption', 13
    CALL NLVSetText 'MI_EXIT',          'Caption', 14

    CALL NLVSetText 'MN_OPTIONS',       'Caption', 20
    CALL NLVSetText 'MN_FONTS',         'Caption', 21
    CALL NLVSetText 'MI_VIEWERFONT',    'Caption', 22
    CALL NLVSetText 'MI_STATUSFONT',    'Caption', 23
    CALL NLVSetText 'MI_WRAP',          'Caption', 25

    CALL NLVSetText 'MN_HELP',          'Caption', 30
    CALL NLVSetText 'MI_HELP_INTRO',    'Caption', 31
    CALL NLVSetText 'MI_HELP_USING',    'Caption', 32
    CALL NLVSetText 'MI_HELP_CONTENTS', 'Caption', 33
    CALL NLVSetText 'MI_ABOUT',         'Caption', 34

    /*
     * Set language-dependent menu accelerators (i.e. those which include a
     * mnemonic letter character).
     */
    CALL NLVSetText 'MI_OPEN',          'Accelerator', 80
    CALL NLVSetText 'MI_EXTRACT',       'Accelerator', 81

RETURN 1

/*:VRX         SetupPreferences
*/
SetupPreferences: PROCEDURE EXPOSE globals. settings.

    os2_ini = VALUE('USER_INI',,'OS2ENVIRONMENT')
    inipath = VRParseFilePath( os2_ini, 'DP')
    IF inipath == '' THEN inipath = SysBootDrive() || '\OS2'

    settings.!ini    = inipath'\arcview.ini'
    IF STREAM( settings.!ini, 'C', 'QUERY EXISTS') == '' THEN DO
        CALL VRMethod VRWindow(), 'CenterWindow'
        RETURN
    END

    /*
     * Load the language setting, if one is defined.
     */
    settings.!locale = VRGetIni('Archive Viewer', 'Locale', settings.!ini, 'NoClose')

    /*
     * Load position and size settings
     */
    settings.!x      = VRGetIni('Archive Viewer', 'XPos',   settings.!ini, 'NoClose')
    settings.!y      = VRGetIni('Archive Viewer', 'YPos',   settings.!ini, 'NoClose')
    settings.!width  = VRGetIni('Archive Viewer', 'Width',  settings.!ini, 'NoClose')
    settings.!height = VRGetIni('Archive Viewer', 'Height', settings.!ini, 'NoClose')
    IF settings.!x      == '' THEN settings.!x      = -1
    IF settings.!y      == '' THEN settings.!y      = -1
    IF settings.!width  == '' THEN settings.!width  = 0
    IF settings.!height == '' THEN settings.!height = 0

    settings.!wrap = VRGetIni('Archive Viewer', 'Wrap', settings.!ini, 'NoClose')
    IF settings.!wrap == '' THEN settings.!wrap = 1

    /*
     * Load font and colour settings
     */
    settings.!bgclr   = VRGetIni('Archive Viewer', 'Background', settings.!ini, 'NoClose')
    settings.!fgclr   = VRGetIni('Archive Viewer', 'Foreground', settings.!ini, 'NoClose')
    settings.!font    = VRGetIni('Archive Viewer', 'Font',       settings.!ini, 'NoClose')
    settings.!dlgfont = VRGetIni('Archive Viewer', 'DialogFont', settings.!ini )
    IF settings.!bgclr    == '' THEN settings.!bgclr   = 'EntryField'
    IF settings.!fgclr    == '' THEN settings.!fgclr   = 'Black'
    IF settings.!font     == '' THEN settings.!font    = '6.System VIO'
    IF settings.!dlgfont  == '' THEN settings.!dlgfont = '9.WarpSans'

    /*
     * Now apply the settings
     */
    IF ( settings.!width > 0 ) & ( settings.!height > 0 ) THEN DO
        CALL VRSet VRWindow(), 'Width',  settings.!width
        CALL VRSet VRWindow(), 'Height', settings.!height
    END

    IF ( settings.!x >= 0 ) & ( settings.!y >= 0 ) THEN DO
        CALL VRSet VRWindow(), 'Left', settings.!x
        CALL VRSet VRWindow(), 'Top',  settings.!y
    END
    ELSE
        CALL VRMethod VRWindow(), 'CenterWindow'

    CALL VRSet 'MLE_VIEWER', 'WordWrap',   settings.!wrap
    CALL VRSet 'MI_WRAP',    'Checked',    settings.!wrap
    CALL VRSet 'WN_MAIN',    'StatusFont', settings.!dlgfont
    CALL VRSet 'MLE_VIEWER', 'Font',       settings.!font
    CALL VRSet 'MLE_VIEWER', 'BackColor',  settings.!bgclr
    CALL VRSet 'MLE_VIEWER', 'ForeColor',  settings.!fgclr

RETURN

/*:VRX         SW_ABOUT_Close
*/
SW_ABOUT_Close:
    call SW_ABOUT_Fini
return

/*:VRX         SW_ABOUT_Create
*/
SW_ABOUT_Create:
    call SW_ABOUT_Init
return

/*:VRX         SW_ABOUT_Fini
*/
SW_ABOUT_Fini:
    window = VRInfo( "Window" )
    call VRDestroy window
    drop window
return
/*:VRX         SW_ABOUT_Init
*/
SW_ABOUT_Init:

    CALL NLVSetText 'SW_ABOUT',         'Caption', 70
    CALL NLVSetText 'DT_ABOUT_NAME',    'Caption', 71
    CALL NLVSetText 'DT_ABOUT_VERSION', 'Caption', 72, '2.1'
    CALL NLVSetText 'DT_ABOUT_BUILD',   'Caption', 73, '201105121'
    CALL NLVSetText 'DT_ABOUT_COPY',    'Caption', 74
    CALL NLVSetText 'DT_ABOUT_LICENSE', 'Caption', 75
    CALL NLVSetText 'PB_ABOUTOK',       'Caption', 2

    window = VRInfo( "Object" )
    if( \VRIsChildOf( window, "Notebook" ) ) then do
        call VRMethod window, "CenterWindow"
        call VRSet window, "Visible", 1
        call VRMethod window, "Activate"
    end
    DROP window

RETURN

/*:VRX         SW_EXTRACT_Close
*/
SW_EXTRACT_Close:
    call SW_EXTRACT_Fini
return

/*:VRX         SW_EXTRACT_Create
*/
SW_EXTRACT_Create:
    call SW_EXTRACT_Init
return

/*:VRX         SW_EXTRACT_Fini
*/
SW_EXTRACT_Fini:
    window = VRInfo( "Window" )
    call VRDestroy window
    drop window
return
/*:VRX         SW_EXTRACT_Init
*/
SW_EXTRACT_Init:

    CALL NLVSetText 'SW_EXTRACT',  'Caption', 50
    CALL NLVSetText 'DT_EXPATH',   'Caption', 51
    CALL NLVSetText 'CHK_EXNAME',  'Caption', 52
    CALL NLVSetText 'CHK_OPENWPS', 'Caption', 53
    CALL NLVSetText 'PB_EXOK',     'Caption', 2
    CALL NLVSetText 'PB_EXCANCEL', 'Caption', 3
    CALL NLVSetText 'PB_EXHELP',   'Caption', 4

    /* Get the name of the archive file minus any archive extensions.
     */
    arcstem = globals.!currentName
    IF ( globals.!currentType == 'TGZ') | ( globals.!currentType == 'TBZ') |,
       ( globals.!currentType == 'TLZ') | ( globals.!currentType == 'TZ') THEN
    DO
        _tarpos = LASTPOS('.TAR', arcstem )
        IF _tarpos > 0 THEN
            arcstem = SUBSTR( arcstem, 1, _tarpos - 1 )
    END

    /* Now open the initial directory.
     */
    CALL SW_EXTRACT_OpenDir globals.!currentPath

    IF vwrfont \= '' THEN CALL VRSet 'LB_EXDIRS', 'Font', vwrfont

    window = VRInfo( "Object" )
    if( \VRIsChildOf( window, "Notebook" ) ) then do
        call VRMethod window, "CenterWindow"
        call VRSet window, "Visible", 1
        call VRMethod window, "Activate"
    end
    DROP window

RETURN

/*:VRX         SW_EXTRACT_OpenDir
*/
SW_EXTRACT_OpenDir: PROCEDURE EXPOSE globals. settings. arcstem
    PARSE ARG path
    path = STRIP( path, 'T', '\')

    CALL VRMethod 'LB_EXDIRS', 'Clear'
    CALL VRSet    'LB_EXDIRS', 'UserData', path

    /*
     * Populate the directories listbox.
     */
    IF FILESPEC('PATH', path ) \= '' THEN CALL VRMethod 'LB_EXDIRS', 'AddString', '..',, 'FOLDER'
    CALL SysFileTree path'\*', 'subdirs.', 'DO'
    DO i = 1 TO subdirs.0
        dirname = FILESPEC('NAME', subdirs.i )
        CALL VRMethod 'LB_EXDIRS', 'AddString', dirname,, 'FOLDER'
    END

    drives = SysDriveMap('A:', 'USED')
    DO d = 1 TO WORDS( drives )
        CALL VRMethod 'LB_EXDIRS', 'AddString', '[' || WORD( drives, d ) || ']',, 'DRIVE'
    END

    /*
     * Set the default value of the path field.
     */
    IF VRGet('CHK_EXNAME', 'Set') == 1 THEN
        CALL VRSet 'EF_EXPATH', 'Value', path'\'arcstem
    ELSE IF FILESPEC('PATH', path ) == '' THEN
        CALL VRSet 'EF_EXPATH', 'Value', path'\'
    ELSE
        CALL VRSet 'EF_EXPATH', 'Value', path

RETURN

/*:VRX         SW_PASSWORD_Close
*/
SW_PASSWORD_Close:
    call SW_PASSWORD_Fini
return

/*:VRX         SW_PASSWORD_Create
*/
SW_PASSWORD_Create:
    call SW_PASSWORD_Init
return

/*:VRX         SW_PASSWORD_Fini
*/
SW_PASSWORD_Fini:
    window = VRInfo( "Window" )
    call VRDestroy window
    drop window
return
/*:VRX         SW_PASSWORD_Init
*/
SW_PASSWORD_Init:

    CALL NLVSetText 'SW_PASSWORD',      'Caption', 60
    IF POS('I', globals.!currentFlags ) <> 0 THEN
        CALL NLVSetText 'DT_PASSWORD1', 'Caption', 64
    ELSE IF action == 'EXTRACT' THEN
        CALL NLVSetText 'DT_PASSWORD1', 'Caption', 61
    ELSE
        CALL NLVSetText 'DT_PASSWORD1', 'Caption', 62
    CALL NLVSetText 'DT_PASSWORD2',     'Caption', 63
    CALL NLVSetText 'PB_PWOK',          'Caption', 2
    CALL NLVSetText 'PB_PWCANCEL',      'Caption', 3
    CALL NLVSetText 'PB_PWHELP',        'Caption', 4

    window = VRInfo( "Object" )
    if( \VRIsChildOf( window, "Notebook" ) ) then do
        call VRMethod window, "CenterWindow"
        call VRSet window, "Visible", 1
        call VRMethod window, "Activate"
    end
    DROP window

RETURN

/*:VRX         WN_MAIN_Close
*/
WN_MAIN_Close:
    call Quit
return

/*:VRX         WN_MAIN_DragDrop
*/
WN_MAIN_DragDrop:

    CALL NewLocale

RETURN

