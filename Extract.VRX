/*:VRX         Main
*/
Main:
    SIGNAL ON HALT

    PARSE ARG window, filespec, type, flags, password, openwps, destination, mask

    IF ( filespec \= null ) THEN DO

        CALL VRSet window, 'Pointer',    'WAIT'

        entries.0 = 0

        IF type == '' THEN
            status = 1
        ELSE
            status = ExtractArchive( filespec, type, flags, password, destination, mask )

        CALL VRSet window, 'Pointer',    '<default>'

        IF status == 99 THEN DO
            IF password <> '' THEN flags = flags || 'I'
            CALL VRMethod 'Application', 'PostQueue', 0, 1, 'CALL ExtractPassword', 'type', type, 'flags', flags,,
                                                                                    'openwps', openwps, 'destination', destination, 'mask', mask
            RETURN
        END
        ELSE IF status <> 0 THEN DO
            CALL VRMethod 'Application', 'PostQueue', 0, 1, 'CALL ExtractError', 'status', status
            RETURN
        END

        CALL VRMethod 'Application', 'PutVar', 'entries.'
        CALL VRMethod 'Application', 'PostQueue', 0, 1, 'CALL FinishExtraction', 'open', openwps, 'destination', destination, 'mask', mask

    END

    /* Values for status:
     *      0  Success
     *      1  Unknown/unsupported archive type
     *      2  Password invalid
     *      3  Archive handler not available
     *      4  Known archive type, but not currently supported (for debugging)
     *      5  Directory change/create failed (for TAR formats)
     *      9  Unknown error encountered
     *     99  Missing (or incorrect) password
     */

EXIT

/*:VRX         ArjExtract
*/
ArjExtract: PROCEDURE EXPOSE entries.
    PARSE ARG filespec, flags, password, destination, mask

    IF ( POS('H', flags ) > 0 ) | ( POS('E', flags ) > 0 ) THEN
        command  = 'arj x "'filespec'" "'destination'" -g'password '-i -jycknorsvy' mask '2>&1 |rxqueue'
    ELSE
        command  = 'arj x "'filespec'" "'destination'" -i -jycknorsvy' mask '2>&1 |rxqueue'

    /*
     * Create the target directory if necessary.
     */
    destination = STRIP( destination, 'T', '\')
    IF VRFileExists( destination) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    status = 0
    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = line
        IF RIGHT( STRIP( line, 'T'), 41 ) == 'Bad file data or bad password, CRC error!' THEN DO
            status = 99
            LEAVE
        END
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* TODO: Do some more error checking on the results */

RETURN status

/*:VRX         CheckForProgram
*/
CheckForProgram: PROCEDURE
    ARG program

    found   = 0
    current = DIRECTORY()
    IF SysSearchPath( current, program ) \= ''    THEN found = 1
    ELSE IF SysSearchPath('PATH', program ) \= '' THEN found = 1

RETURN found

/*:VRX         ExtractArchive
*/
ExtractArchive: PROCEDURE EXPOSE entries.
    PARSE ARG filespec, type, flags, password, destination, mask

    /*
     * Much of the code is duplicated between each xxxExtract function.  It seems
     * like a redundancy, but I want to isolate each extraction routine so it'll
     * eventually be easier to add format-specific exit handling and/or parsing,
     * if I ever decide to do so.
     */

    SELECT
        WHEN type == 'ZIP' THEN status = ZipExtract(    filespec, flags, password, destination, mask )
        WHEN type == 'TAR' THEN status = TarExtract(    filespec, flags, password, destination, mask )
        WHEN type == 'TGZ' THEN status = TarGzExtract(  filespec, flags, password, destination, mask )
        WHEN type == 'TBZ' THEN status = TarBz2Extract( filespec, flags, password, destination, mask )
        WHEN type == 'TLZ' THEN status = TarLzExtract(  filespec, flags, password, destination, mask )
        WHEN type == 'TZ'  THEN status = TarZExtract(   filespec, flags, password, destination, mask )
        WHEN type == 'RAR' THEN status = RarExtract(    filespec, flags, password, destination, mask )
        WHEN type == 'ARJ' THEN status = ArjExtract(    filespec, flags, password, destination, mask )
        WHEN type == 'RPM' THEN status = RpmExtract(    filespec, flags, password, destination, mask )
        WHEN type == 'WPI' THEN status = WpiExtract(    filespec, flags, password, destination, mask )
        WHEN type == '7Z'  THEN status = SzExtract(     filespec, flags, password, destination, mask )
        WHEN type == 'LHA' THEN status = LhaExtract(    filespec, flags, password, destination, mask )
        WHEN ( type == 'GZ') | ( type == 'BZ') | ( type == 'LZ') | ( type == 'Z') THEN
            status = UncompressFile( type, filespec, destination )
        OTHERWISE               status = 4
    END

    IF ( status == 0 ) & ( entries.0 == 0 ) THEN status = 9

RETURN status

/*:VRX         GetTarVersion
*/
GetTarVersion: PROCEDURE
    tarver = '0'
    testqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', testqueue )
    ADDRESS CMD '@tar --version 2>&1 |rxqueue' testqueue
    IF QUEUED() \= 0 THEN DO
        PARSE PULL verstring
        _verpos = VERIFY( verstring, '0123456789', 'M')
        PARSE VAR verstring =(_verpos) _ver .
        tarver = _ver
    END
    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', testqueue
RETURN tarver

/*:VRX         Halt
*/
Halt:

exit

/*:VRX         LhaExtract
*/
LhaExtract:  PROCEDURE EXPOSE entries.
    ARG filespec, flags, password, destination, mask

    /*
     * Change to the target directory, creating it first if necessary.
     */
    old_cd = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination ) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    command = 'lha x -ncml2i2 "'filespec'" "'destination'/"' mask '2>&1 |rxqueue'

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    DO QUEUED()
        PARSE PULL line
        IF line == '' THEN ITERATE
        ELSE IF STRIP( line ) == 'Melting' THEN ITERATE
        ELSE IF STRIP( line ) == 'Melted'  THEN line = ''
        i = i + 1
        entries.i = line
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY old_cd

    /* TODO: Do some error checking on the results */

RETURN 0

/*:VRX         RarExtract
*/
RarExtract: PROCEDURE EXPOSE entries.
    PARSE ARG filespec, flags, password, destination, mask

    IF password == '' THEN password = '-'

    SELECT
        WHEN CheckForProgram('UNRAR.EXE') == 1 THEN command = 'unrar x "'filespec'" -idp -p'password '-o+' mask '2>&1 |rxqueue'
        WHEN CheckForProgram('RAR32.EXE') == 1 THEN command = 'rar32 x "'filespec'" "'destination'" -idp -p'password '-o+' mask '2>&1 |rxqueue'
        WHEN CheckForProgram('RAR.EXE') == 1   THEN command = 'rar x "'filespec'" "'destination'" -idp -p'password '-o+' mask '2>&1 |rxqueue'
        OTHERWISE RETURN 3
    END

    /*
     * Create the target directory if necessary.
     */
    destination = STRIP( destination, 'T', '\')
    IF VRFileExists( destination) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END

    /*
     * UNRAR.EXE only supports extracting to the current directory,
     * so we have to implement a workaround...
     */
    IF TRANSLATE( LEFT( command, 5 )) == 'UNRAR' THEN DO
        od = DIRECTORY()
        IF FILESPEC('PATH', destination'\') == '\' THEN
            ok = DIRECTORY( destination'\')
        ELSE
            ok = DIRECTORY( destination )
        IF ok == '' THEN RETURN 5
    END

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    IF rc == 3 THEN
        status = 99
    ELSE DO
        status = 0
        i = 0
        DO QUEUED()
            i = i + 1
            PARSE PULL line
            entries.i = line

            IF RIGHT( STRIP( line, 'T'), 22 ) == '(password incorrect ?)' THEN DO
                status = 99
                LEAVE
            END

        END
        entries.0 = i
    END

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    IF TRANSLATE( LEFT( command, 5 )) == 'UNRAR' THEN CALL DIRECTORY od

RETURN status

/*:VRX         RpmExtract
*/
RpmExtract: PROCEDURE EXPOSE entries.
    PARSE ARG filespec, flags, password, destination, mask

    IF CheckForProgram('CPIO.EXE') == 0 THEN
        RETURN 3

    IF ( CheckForProgram('7Z.EXE') == 1 ) THEN
        command = '7z x -so -bd -y "'filespec'" 2>NUL | cpio -d -i -v -u --no-absolute-filenames --quiet' mask '2>&1 |rxqueue'
    ELSE IF ( CheckForProgram('RPM2CPIO.EXE') == 1 ) THEN
        command = 'rpm2cpio "'filespec'" 2>NUL | cpio -d -i -v -u --no-absolute-filenames --quiet' mask '2>&1 |rxqueue'
    ELSE
        RETURN 3

    /*
     * Change to the target directory, creating it first if necessary.
     */
    od = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination ) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = TRANSLATE( destination, '/', '\') || '/'line
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY od

    /* TODO: Do some error checking on the results */

RETURN 0

/*:VRX         SzExtract
*/
SzExtract: PROCEDURE EXPOSE entries.
    PARSE ARG filespec, flags, password, destination, mask

    IF password == '' THEN password = '-'
    SELECT
        WHEN CheckForProgram('7Z.EXE')  == 1 THEN sz_exe = '7z'
        WHEN CheckForProgram('7ZA.EXE') == 1 THEN sz_exe = '7za'
        WHEN CheckForProgram('7ZR.EXE') == 1 THEN sz_exe = '7zr'
        OTHERWISE RETURN 3
    END
    command = sz_exe 'x -o"'destination'" -p'password '-bd -y "'filespec'"' mask '2>&1|rxqueue'

    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    open_ok = 0
    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = line
        IF LEFT( line, 6 ) == 'Error:' THEN DO
            IF RIGHT( STRIP( line ), 47 ) == 'Can not open encrypted archive. Wrong password?' THEN DO
                open_ok = 99    /* Bad/missing password error */
                LEAVE
            END
            ELSE open_ok = 9    /* Unknown error */
        END
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

RETURN open_ok

/*:VRX         TarBz2Extract
*/
TarBz2Extract: PROCEDURE EXPOSE entries.
    ARG filespec, flags, password, destination, mask

    /* Check the TAR version because the syntax varies.
     */
    IF GetTarVersion() <= '1.10' THEN
        command = 'tar -x -v --zip=bzip2 -f "'filespec'"' mask '2>&1 |rxqueue'
    ELSE
        command = 'tar -x -v -j --ignore-case -f "'filespec'"' mask '2>&1 |rxqueue'

    /*
     * Change to the target directory, creating it first if necessary.
     */
    od = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = TRANSLATE( destination, '/', '\') || '/'line
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY od

    /* TODO: Do some error checking on the results */

RETURN 0

/*:VRX         TarExtract
*/
TarExtract: PROCEDURE EXPOSE entries.
    ARG filespec, flags, password, destination, mask

    /* Check the TAR version because the case-sensitivity option varies.
     */
    IF GetTarVersion() <= '1.10' THEN
        command = 'tar xvf "'filespec'"' mask '2>&1 |rxqueue'
    ELSE
        command = 'tar -x -v --ignore-case -f "'filespec'"' mask '2>&1 |rxqueue'

    /*
     * Change to the target directory, creating it first if necessary.
     */
    od = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination ) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = TRANSLATE( destination, '/', '\') || '/'line
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY od

    /* TODO: Do some error checking on the results */

RETURN 0

/*:VRX         TarGzExtract
*/
TarGzExtract: PROCEDURE EXPOSE entries.
    ARG filespec, flags, password, destination, mask

    /* Check the TAR version because the case-sensitivity option varies.
     */
    IF GetTarVersion() <= '1.10' THEN
        command = 'tar xvzf "'filespec'"' mask '2>&1 |rxqueue'
    ELSE
        command = 'tar -x -v -z --ignore-case -f "'filespec'"' mask '2>&1 |rxqueue'

    /*
     * Change to the target directory, creating it first if necessary.
     */
    od = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = TRANSLATE( destination, '/', '\') || '/'line
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY od

    /* TODO: Do some error checking on the results */

RETURN 0

/*:VRX         TarLzExtract
*/
TarLzExtract: PROCEDURE EXPOSE entries.
    ARG filespec, flags, password, destination, mask

    SELECT
        WHEN CheckForProgram('LZIP.EXE')   == 1 THEN lz_command = 'lzip'
        WHEN CheckForProgram('PDLZIP.EXE') == 1 THEN lz_command = 'pdlzip'
        OTHERWISE RETURN 3
    END

    /*
     * Check the TAR version because the syntax varies.
     */
    IF GetTarVersion() <= '1.10' THEN
        command = 'tar -x -v --zip='lz_command '-f "'filespec'"' mask '2>&1 |rxqueue'
    ELSE
        command = 'tar -x -v --ignore-case --use-compress-program='lz_command '-f "'filespec'"' mask '2>&1 |rxqueue'

    /*
     * Change to the target directory, creating it first if necessary.
     */
    od = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = TRANSLATE( destination, '/', '\') || '/'line
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY od

    /* TODO: Do some error checking on the results */

RETURN 0

/*:VRX         TarZExtract
*/
TarZExtract: PROCEDURE EXPOSE entries.
    ARG filespec, flags, password, destination, mask

    /* Check the TAR version because the case-sensitivity option varies.
     */
    IF GetTarVersion() <= '1.10' THEN
        command = 'tar -x -v --compress -f "'filespec'"' mask '2>&1 |rxqueue'
    ELSE
        command = 'tar -x -v --compress --ignore-case -f "'filespec'"' mask '2>&1 |rxqueue'

    /*
     * Change to the target directory, creating it first if necessary.
     */
    od = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    /*
     * Now extract the archive.
     */
    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = TRANSLATE( destination, '/', '\') || '/'line
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY od

    /* TODO: Do some error checking on the results */

RETURN 0

/*:VRX         UncompressFile
*/
UncompressFile: PROCEDURE EXPOSE entries.
    ARG type, filespec, destination

    /*
     * Get the non-uppercased filename, if possible.
     */
    CALL SysFileTree filespec, 'file_info.', 'FO'
    IF file_info.0 == 1 THEN
        filename = FILESPEC('NAME', file_info.1 )
    ELSE
        filename = FILESPEC('NAME', filespec )

    /*
     * Change to the target directory, creating it first if necessary.
     */
    od = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination ) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    SELECT
        WHEN type == 'BZ' THEN DO
            outfile = SUBSTR( filename, 1, LASTPOS('.BZ2', TRANSLATE( filename )) - 1 )
            command = 'bzip2 -d -c "'filespec'" > "'destination'\'outfile'"'
        END
        WHEN type == 'GZ' THEN DO
            outfile = SUBSTR( filename, 1, LASTPOS('.GZ', TRANSLATE( filename )) - 1 )
            command = 'gzip -d -c  "'filespec'" > "'destination'\'outfile'"'
        END
        WHEN type == 'LZ' THEN DO
            outfile = SUBSTR( filename, 1, LASTPOS('.LZ', TRANSLATE( filename )) - 1 )
            command = 'lzip -d -c "'filespec'" > "'destination'\'outfile'"'
        END
        WHEN type == 'Z' THEN DO
            outfile = SUBSTR( filename, 1, LASTPOS('.Z', TRANSLATE( filename )) - 1 )
            command = 'compress -d -c "'filespec'" > "'destination'\'outfile'"'
        END
        OTHERWISE
            RETURN 1
    END

    /*
     * Now extract the archive.
     */
    ADDRESS CMD '@'command
    IF rc == 0 THEN DO
        status = 0
        entries.1 = '0'
    END
    ELSE DO
        status = 9
        entries.1 = rc
    END
    entries.2 = outfile
    entries.0 = 2

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY od

RETURN status

/*:VRX         WpiExtract
*/
WpiExtract: PROCEDURE EXPOSE entries.
    ARG filespec, flags, password, destination, mask

    PARSE VALUE SysIni('USER', 'WarpIN', 'Path') WITH warpin '00'x .
    IF LEFT( warpin, 6 ) == 'ERROR:' THEN RETURN 3
    warpin = STRIP( warpin, 'T', '\')

    /*
     * Change to the target directory, creating it first if necessary.
     */
    od = DIRECTORY()
    destination = STRIP( destination, 'T', '\')
    IF FILESPEC('PATH', destination'\') == '\' THEN destination = destination'\'
    IF VRFileExists( destination ) == 0 THEN DO
        ok = VRMkDir( destination )
        IF ok \= 1 THEN RETURN 5
    END
    ok = DIRECTORY( destination )
    IF ok == '' THEN RETURN 5
    destination = STRIP( destination, 'T', '\')

    CALL SETLOCAL
    old_blp = SysQueryExtLIBPATH('B')
    CALL SysSetExtLIBPATH warpin, 'B'
    _path = VALUE('PATH',,'OS2ENVIRONMENT')
    CALL VALUE 'PATH', warpin';'_path, 'OS2ENVIRONMENT'

    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )

    IF mask <> '' THEN DO
        /* If a filemask was specified, query all the package numbers in the
         * archive and then try each of them one by one.
         */
        ADDRESS CMD '@wic -l "'filespec'" 2>&1 |rxqueue' listqueue
        wpaks = ''
        DO QUEUED()
            PARSE PULL line
            IF LEFT( line, 8 ) == 'Package ' THEN DO
                PARSE VAR line 'Package ' _pckno .
                wpaks = wpaks _pckno
            END
        END
        i = 0
        DO j = 1 TO WORDS( wpaks )
            pak = WORD( wpaks, j )
            IF VERIFY( pak, '0123456789') <> 0 THEN ITERATE
            command = 'wic -x "'filespec'"' pak mask '2>&1 |rxqueue'
            ADDRESS CMD '@' command listqueue
            DO QUEUED()
                PARSE PULL line
                /* Skip these lines as they make the output needlessly messy */
                IF line == '' THEN ITERATE
                ELSE IF line == entries.i THEN ITERATE
                /* Also filter out incomplete-progress lines */
                ELSE IF POS('%)', line ) > 0 THEN DO
                    PARSE VAR line . '('_percent'%)' .
                    IF _percent <> '100' THEN ITERATE
                END
                i = i + 1
                entries.i = line
            END
        END
        entries.0 = i
    END
    ELSE DO
        command = 'wic -x "'filespec'" 2>&1 |rxqueue'
        ADDRESS CMD '@' command listqueue
        i = 0
        DO QUEUED()
            PARSE PULL line
            /* Skip these lines as they make the output needlessly messy */
            IF line == '' THEN ITERATE
            ELSE IF line == entries.i THEN ITERATE
            /* ELSE IF LEFT( line, 18 ) == 'Extracting package' THEN ITERATE */
            /* Also filter out incomplete-progress lines */
            ELSE IF POS('%)', line ) > 0 THEN DO
                PARSE VAR line . '('_percent'%)' .
                IF _percent <> '100' THEN ITERATE
            END
            i = i + 1
            entries.i = line
        END
        entries.0 = i
    END

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    IF old_blp <> '' THEN
        CALL SysSetExtLIBPATH old_blp, 'B'
    CALL ENDLOCAL

    /* Make sure the new directory isn't current for the drive */
    CALL VRChDir '\'
    /* Return to the previous directory */
    CALL DIRECTORY od

RETURN 0

/*:VRX         ZipExtract
*/
ZipExtract: PROCEDURE EXPOSE entries.
    PARSE ARG filespec, flags, password, destination, mask

    /* The ZIP "-d" option requires a trailing backslash to be doubled. */
    IF RIGHT( destination, 1 ) == "\" THEN destination = destination"\"

    /* Let the user assume responsibility for quoting the mask? */
    /*IF mask <> '' THEN mask = '"'mask'"'*/

    IF ( POS('H', flags ) > 0 ) | ( POS('E', flags ) > 0 ) THEN
        command = 'unzip -o -P 'password' "'filespec'"' mask '-d "'destination'" 2>&1 |rxqueue'
    ELSE
        command = 'unzip -o "'filespec'"' mask ' -d "'destination'" 2>&1 |rxqueue'

    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = line
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* TODO: Do some error checking on the results */

RETURN 0

