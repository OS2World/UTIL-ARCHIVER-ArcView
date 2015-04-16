/*:VRX         Main
*/
Main:
    SIGNAL ON HALT
    PARSE ARG window, filespec, password

    IF ( filespec \= null ) THEN DO

        CALL VRSet window, 'Pointer', 'WAIT'

        entries.0 = 0
        flags = ''

        /* Determine the archive type */
        type = DetermineArchiveType( filespec )
        IF type == '' THEN
            status = 1
        ELSE DO
            IF password <> '' THEN DO
                status = ListArchive( filespec, type, password )
                IF status == 99 THEN DO
                    flags = flags || 'I'
                    CALL VRSet window, 'Pointer', '<default>'
                    CALL VRMethod 'Application', 'PostQueue', 0, 1, 'CALL ListPassword', 'type', type, 'flags', flags
                    EXIT
                END
            END
            ELSE DO
                flags = GetFlags( filespec, type )
                IF POS('H', flags ) > 0 THEN DO
                    CALL VRSet window, 'Pointer', '<default>'
                    CALL VRMethod 'Application', 'PostQueue', 0, 1, 'CALL ListPassword', 'type', type, 'flags', flags
                    EXIT
                END
                ELSE DO
                    status = ListArchive( filespec, type )
                    IF status == 99 THEN DO
                        flags = flags || 'H'
                        CALL VRSet window, 'Pointer', '<default>'
                        CALL VRMethod 'Application', 'PostQueue', 0, 1, 'CALL ListPassword', 'type', type, 'flags', flags
                        EXIT
                    END
                END
            END
        END

        CALL VRSet window, 'Pointer',    '<default>'

        IF status \= 0 THEN DO
            CALL VRMethod 'Application', 'PostQueue', 0, 1, 'CALL ListError', 'type', type, 'status', status
            RETURN
        END

        /* Return with PutVar */
        CALL VRMethod 'Application', 'PutVar', 'entries.'
        CALL VRMethod 'Application', 'PostQueue', 0, 1, 'CALL DisplayContents', 'type', type, 'flags', flags

    END

EXIT

/*:VRX         ArjCheckEncryption
*/
/*
 * This somewhat imprecisely-named function not only determines the encryption
 * flags of an ARJ archive, but also whether it is part of a multi-volume set.
 */
ArjCheckEncryption:
    ARG arjfile

    offset = 0
    arjflags = ''

    /* Read the archive header block */
    IF ArjReadBlock( arjfile, offset ) \= 0 THEN RETURN 'X'     /* Not an ARJ archive */
    offset = offset + block.!length

    IF ( BITAND( block.!flags, '01'x ) == '01'x ) THEN
        arjflags = arjflags || 'E'
    IF ( BITAND( block.!flags, '04'x ) == '04'x ) THEN
        arjflags = arjflags || 'V'
/*
 * I'm not actually 100% sure about this one, so let's disable it for now
 *
 *   IF ( BITAND( block.!flags, '02'x ) == '02'x ) | ( BITAND( block.!flags, '40'x ) == '40'x ) THEN
 *       arjflags = arjflags || 'H'
 */


    /* Now read the first file block */
    CALL ArjReadBlock arjfile, offset
    offset = offset + block.!length
    IF ( BITAND( block.!flags, '01'x ) == '01'x ) THEN
        IF POS('E', arjflags ) == 0 THEN arjflags = arjflags || 'E'

RETURN arjflags

/*:VRX         ArjGetContents
*/
ArjGetContents: PROCEDURE EXPOSE entries. flags
    ARG filespec

    command = 'arj l "'filespec'" 2>&1 |rxqueue'

    IF CheckForProgram('ARJ.EXE') == 0 THEN RETURN 3

    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    pastheader = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = line
        /* A non-space in column 77 means an encrypted file. */
        IF ( POS('E', flags ) == 0 ) & ( pastheader == 1 ) & ( SUBSTR( line, 77, 1 ) == 1 ) THEN
            flags = flags || 'E'
        IF SUBSTR( line, 69, 11 ) == 'AttrBTPMGVX' THEN pastheader = 1
    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    /* TODO: Do some error checking on the results */

RETURN 0

/*:VRX         ArjReadBlock
*/
/*
 * This function reads a header block within an ARJ archive (either the
 * archive header or a file header within the archive) to get various flags.
 */
ArjReadBlock: PROCEDURE EXPOSE block.
    ARG arjfile, offset

    marker = C2X( CHARIN( arjfile, offset+1 )) || C2X( CHARIN( arjfile, offset+2 )) /* Bytes 1-2 */
    IF marker \= '60EA' THEN RETURN 1   /* Invalid ARJ block */

    size = C2X( CHARIN( arjfile, offset+4 )) || C2X( CHARIN( arjfile, offset+3 ))   /* Bytes 3-4, bigendian */

    block.!flags = CHARIN( arjfile, offset+9 )                                      /* Byte 9 */

    offset  = offset + X2D( size ) + 8
    crcsize = C2X( CHARIN( arjfile, offset+2 )) || C2X( CHARIN( arjfile, offset+1 ))
    IF X2D( crcsize > 0 ) THEN
        block.!length = offset + 2 + crcsize + 4
    ELSE
        block.!length = offset + 2 + crcsize

RETURN 0

/*:VRX         CheckForProgram
*/
/* Checks to see if the specified program executable is installed on the system */
CheckForProgram: PROCEDURE
    ARG program

    found   = 0
    current = DIRECTORY()
    IF SysSearchPath( current, program ) \= ''    THEN found = 1
    ELSE IF SysSearchPath('PATH', program ) \= '' THEN found = 1

RETURN found

/*:VRX         DetermineArchiveType
*/
DetermineArchiveType: PROCEDURE
    ARG filename

    /*
     * Not all of these types are necessarily supported by ArcView just yet,
     * but why not plan ahead? :)
     */
    SELECT
        WHEN RIGHT( filename, 4 ) == '.ZIP'    THEN type = 'ZIP'
        WHEN RIGHT( filename, 3 ) == '.7Z'     THEN type = '7Z'
        WHEN RIGHT( filename, 4 ) == '.WPI'    THEN type = 'WPI'
        WHEN RIGHT( filename, 4 ) == '.RPM'    THEN type = 'RPM'
        WHEN RIGHT( filename, 4 ) == '.EXE'    THEN type = ExeGetType( filename )
        WHEN RIGHT( filename, 4 ) == '.RAR'    THEN type = 'RAR'
        WHEN RIGHT( filename, 4 ) == '.ARJ'    THEN type = 'ARJ'
        WHEN RIGHT( filename, 4 ) == '.JAR'    THEN type = 'ZIP'
        WHEN RIGHT( filename, 4 ) == '.LHA'    THEN type = 'LHA'
        WHEN RIGHT( filename, 4 ) == '.LZH'    THEN type = 'LHA'
        WHEN RIGHT( filename, 4 ) == '.TAR'    THEN type = 'TAR'
        WHEN RIGHT( filename, 4 ) == '.TGZ'    THEN type = 'TGZ'
        WHEN RIGHT( filename, 5 ) == '.TBZ2'   THEN type = 'TBZ'
        WHEN RIGHT( filename, 4 ) == '.TBZ'    THEN type = 'TBZ'
        WHEN RIGHT( filename, 4 ) == '.TLZ'    THEN type = 'TLZ'
        WHEN RIGHT( filename, 6 ) == 'TAR.GZ'  THEN type = 'TGZ'
        WHEN RIGHT( filename, 7 ) == 'TAR.BZ2' THEN type = 'TBZ'
        WHEN RIGHT( filename, 6 ) == 'TAR.LZ'  THEN type = 'TLZ'
        WHEN RIGHT( filename, 5 ) == 'TAR.Z'   THEN type = 'TZ'
        WHEN RIGHT( filename, 3 ) == '.PF'     THEN type = 'PF'    /* Not supported */
        /* Non-tar compressed files - none of these are actually supported yet.
         * Note that these lines must come AFTER the TAR.* lines (above).
         */
        WHEN RIGHT( filename, 3 ) == '.GZ'     THEN type = 'GZ'    /* Not supported */
        WHEN RIGHT( filename, 4 ) == '.BZ2'    THEN type = 'BZ'    /* Not supported */
        WHEN RIGHT( filename, 3 ) == '.LZ'     THEN type = 'LZ'    /* Not supported */
        WHEN RIGHT( filename, 2 ) == '.Z'      THEN type = 'Z'     /* Not supported */
        OTHERWISE                                   type = ReadType( filename )
    END

RETURN type

/*:VRX         ExeGetType
*/
ExeGetType: PROCEDURE
    PARSE ARG filename
    type = ReadType( filename )
RETURN type

/*:VRX         GetFlags
*/
GetFlags: PROCEDURE
    ARG filespec, type

    /* Identify any special properties of this archive, e.g. encrypted */

    SELECT
        WHEN type == 'ZIP' THEN DO
            flags = ''
            IF ZipCheckEncryption( filespec ) == 1 THEN flags = flags || 'E'
        END
        WHEN type == 'RAR' THEN DO
            flags = RarCheckEncryption( filespec )
        END
        WHEN type == 'ARJ' THEN DO
            flags = ArjCheckEncryption( filespec )
        END
        WHEN ( type == 'GZ') | ( type == 'BZ') | ( type == 'LZ') | ( type == 'Z') THEN DO
            flags = 'F'
        END
        OTHERWISE flags = ''
    END

    /* Possible values for 'flags':
     *    ''   No flags
     *    'E'  Contains encrypted files
     *    'F'  Singly-compressed file (not an archive)
     *    'H'  Archive header (table of contents) is encrypted
     *    'I'  An incorrect password was specified (only set in Main function)
     *    'V'  File is part of a multi-volume archive
     *    'X'  File is invalid
     */

RETURN flags

/*:VRX         Halt
*/
Halt:

EXIT

/*:VRX         LhaGetContents
*/
LhaGetContents:  PROCEDURE EXPOSE entries. flags
    ARG filespec

    command = 'lha v "'filespec'" 2>&1 |rxqueue'

    IF CheckForProgram('LHA.EXE') == 0 THEN RETURN 3

    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    i = 0
    pastheader = 0
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

/*:VRX         ListArchive
*/
ListArchive: PROCEDURE EXPOSE entries. flags
    PARSE ARG filespec, type, password

    /*
     * Much of the code is duplicated between each xxxGetContents function.  It
     * seems like a redundancy, but I want to isolate each routine so it'll
     * eventually be easier to add format-specific exit handling and/or parsing,
     * if I ever decide to do so.  Besides, a couple of them do need to do
     * special things already.
     */

    SELECT
        WHEN type == 'ZIP' THEN status = ZipGetContents(    filespec )
        WHEN type == 'TAR' THEN status = TarGetContents(    filespec )
        WHEN type == 'TGZ' THEN status = TarGzGetContents(  filespec )
        WHEN type == 'TBZ' THEN status = TarBz2GetContents( filespec )
        WHEN type == 'TLZ' THEN status = TarLzGetContents(  filespec )
        WHEN type == 'TZ'  THEN status = TarZGetContents(   filespec )
        WHEN type == 'RAR' THEN status = RarGetContents(    filespec, password )
        WHEN type == 'ARJ' THEN status = ArjGetContents(    filespec )
        WHEN type == 'WPI' THEN status = WpiGetContents(    filespec )
        WHEN type == 'RPM' THEN status = RpmGetContents(    filespec )
        WHEN type == '7Z'  THEN status = SzGetContents(     filespec, password )
        WHEN type == 'LHA' THEN status = LhaGetContents(    filespec )
        WHEN ( type == 'GZ') | ( type == 'BZ') | ( type == 'LZ') | ( type == 'Z') THEN
            status = ShowCompressedFile( type, filespec )
        OTHERWISE status = 4
    END

    IF ( status == 0 ) & ( entries.0 == 0 ) THEN status = 9

    /* Values for status:
     *      0  Success
     *      1  Unknown/unsupported archive type
     *      2  Password required to view contents
     *      3  Archive handler not available
     *      4  Known but (currently) unsupported archive type
     *      9  Unknown error encountered
     *      99 Bad or incorrect password provided
     */

RETURN status

/*:VRX         RarCheckEncryption
*/
/*
 * This somewhat imprecisely-named function not only determines the encryption
 * flags of a RAR archive, but also whether it is part of a multi-volume set.
 */
RarCheckEncryption: PROCEDURE
    ARG rarfile

    /* Skip the marker block, which is constant */
    offset   = 7
    eof      = 0
    rarflags = ''

    /* Read the archive header block */
    CALL RarReadBlock rarfile, offset
    offset = offset + block.!length

    IF ( BITAND( block.!flags, '0001'x ) == '0001'x ) THEN
        rarflags = rarflags || 'V'                              /* multi-volume archive */
    IF ( BITAND( block.!flags, '0080'x ) == '0080'x ) THEN DO
        rarflags = rarflags || 'H'                              /* archive header is encrypted */
        RETURN rarflags
    END

    /*
     * Now read the first file block to see if it's encrypted.
     * Note that this won't detect cases where only some files (later in the
     * archive) are encrypted.  We have a little 'trick' in the RarGetContents
     * function to check for that.
     */
    DO UNTIL block.!type == '74'
        CALL RarReadBlock rarfile, offset
        offset = offset + block.!length
    END
    IF ( BITAND( block.!flags, '0004'x ) == '0004'x ) THEN
        rarflags = rarflags || 'E'                              /* archive is encrypted */

    CALL STREAM rarfile, 'C', 'CLOSE'

RETURN rarflags

/*:VRX         RarGetContents
*/
RarGetContents: PROCEDURE EXPOSE entries. flags
    PARSE ARG filespec, password

    IF password == '' THEN password = '-'

    SELECT
        WHEN CheckForProgram('UNRAR.EXE') == 1 THEN command = 'unrar v -p'password '"'filespec'" 2>&1 |rxqueue'
        WHEN CheckForProgram('RAR32.EXE') == 1 THEN command = 'rar32 v -p'password '"'filespec'" 2>&1 |rxqueue'
        WHEN CheckForProgram('RAR.EXE')   == 1 THEN command = 'rar v -p'password '"'filespec'" 2>&1 |rxqueue'
        OTHERWISE RETURN 3
    END

    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )
    ADDRESS CMD '@' command listqueue

    open_ok = 0
    i = 0
    DO QUEUED()
        i = i + 1
        PARSE PULL line
        entries.i = line

        /* Check for bad/missing password */
        IF RIGHT( STRIP( line, 'T'), 22 ) == '(password incorrect ?)' THEN
        DO
            open_ok = 99
            LEAVE
        END

        /* Check for files marked as encrypted. */
        IF ( POS('E', flags ) == 0 ) & ( LEFT( line, 1 ) == '*') THEN
            flags = flags || 'E'

    END
    entries.0 = i

    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

RETURN open_ok

/*:VRX         RarReadBlock
*/
/*
 * This function reads the flags of a compressed RAR archive block.
 */
RarReadBlock: PROCEDURE EXPOSE block.
    ARG rarfile, offset

    block.!type  = C2X( CHARIN( rarfile, offset+3, 1 ))                            /* Byte 3   */
    block.!flags = CHARIN( rarfile, offset+5 ) || CHARIN( rarfile, offset+4, 1 )   /* Byte 4-5 */

    size = C2X( CHARIN( rarfile, offset+7 )) || C2X( CHARIN( rarfile, offset+6 ))  /* Byte 6-7 */
    IF ( BITAND( block.!flags, '8000'x ) == '8000'x ) THEN DO
        /* Add bytes 8-11 to the size total */
        add   = C2X( CHARIN( rarfile, offset+11 )) || C2X( CHARIN( rarfile, offset+10 )) || C2X( CHARIN( rarfile, offset+9 )) || C2X( CHARIN( rarfile, offset+8 ))
        block.!length = X2D( size ) + X2D( add )
    END
    ELSE
        block.!length = X2D( size )

RETURN

/*:VRX         RpmGetContents
*/
RpmGetContents: PROCEDURE EXPOSE entries.
    ARG filespec

    IF CheckForProgram('CPIO.EXE') == 0 THEN
        RETURN 3

    IF ( CheckForProgram('7Z.EXE') == 1 ) THEN
        command = '7z e -so -bd -y "'filespec'" 2>NUL | cpio -t -v --quiet 2>&1 |rxqueue'
    ELSE IF ( CheckForProgram('RPM2CPIO.EXE') == 1 ) THEN
        command = 'rpm2cpio "'filespec'" 2>NUL | cpio -t -v --quiet 2>&1 |rxqueue'
    ELSE
        RETURN 3

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

/*:VRX         ShowCompressedFile
*/
ShowCompressedFile: PROCEDURE EXPOSE entries.
    ARG type, filespec

    SELECT
        WHEN type == 'BZ' THEN DO
            _ext = '.BZ2'
            _program = 'bzip2'
        END
        WHEN type == 'GZ' THEN DO
            _ext = '.GZ'
            _program = 'gzip'
        END
        WHEN type == 'LZ' THEN DO
            _ext = '.LZ'
            _program = 'lzip'
        END
        WHEN type == 'Z' THEN DO
            _ext = '.Z'
            _program = 'compress'
        END
        OTHERWISE RETURN 1
    END

    IF CheckForProgram( _program'.exe') == 0 THEN
        RETURN 3

    CALL SysFileTree filespec, 'file_info.', 'FL'
    IF file_info.0 == 1 THEN DO
        PARSE VAR file_info.1 _date _time _size _attrs _fullname
        _fullname = FILESPEC('NAME', STRIP( _fullname ))
        entries.1 = SUBSTR( _fullname, 1, LASTPOS( _ext, TRANSLATE( _fullname )) - 1 )
        entries.3 = _size
        entries.4 = _date _time
        entries.5 = TRANSLATE( _attrs, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')
        entries.0 = 5
    END
    ELSE DO
        _fullname = FILESPEC('NAME', STRIP( filespec ))
        entries.1 = SUBSTR( _fullname, 1, LASTPOS( _ext, TRANSLATE( _fullname )) - 1 )
        entries.0 = 2
    END
    entries.2 = _program

RETURN 0

/*:VRX         SzGetContents
*/
SzGetContents: PROCEDURE EXPOSE entries.
    PARSE ARG filespec, password

    IF password == '' THEN password = '-'
    SELECT
        WHEN CheckForProgram('7Z.EXE')  == 1 THEN sz_exe = '7z'
        WHEN CheckForProgram('7ZA.EXE') == 1 THEN sz_exe = '7za'
        WHEN CheckForProgram('7ZR.EXE') == 1 THEN sz_exe = '7zr'
        OTHERWISE RETURN 3
    END
    command = sz_exe 'l -p'password '-bd -y "'filespec'" 2>&1|rxqueue'

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

    /* TODO: Do some error checking on the results */

RETURN open_ok

/*:VRX         TarBz2GetContents
*/
TarBz2GetContents: PROCEDURE EXPOSE entries.
    ARG filespec

    IF ( CheckForProgram('TAR.EXE') == 0 ) | ( CheckForProgram('BZIP2.EXE') == 0 ) THEN RETURN 3

    /* Check the TAR version because the bzip2 syntax varies.
     */
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
    CALL RXQUEUE 'DELETE', listqueue

    IF tarver <= '1.10' THEN
        command = 'tar -t -v --zip=bzip2 -f "'filespec'" 2>&1 |rxqueue'
    ELSE
        command = 'tar tvjf "'filespec'" 2>&1 |rxqueue'

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

/*:VRX         TarGetContents
*/
TarGetContents: PROCEDURE EXPOSE entries.
    ARG filespec

    command = 'tar tvf "'filespec'" 2>&1 |rxqueue'

    IF CheckForProgram('TAR.EXE') == 0 THEN RETURN 3

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

/*:VRX         TarGzGetContents
*/
TarGzGetContents: PROCEDURE EXPOSE entries.
    ARG filespec

    command = 'tar tvzf "'filespec'" 2>&1 |rxqueue'

    /* TODO: Should we allow UNTGZ as handler also? */

    IF ( CheckForProgram('TAR.EXE') == 0 ) | ( CheckForProgram('GZIP.EXE') == 0 ) THEN RETURN 3

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

/*:VRX         TarLzGetContents
*/
TarLzGetContents: PROCEDURE EXPOSE entries.
    ARG filespec

    IF ( CheckForProgram('TAR.EXE') == 0 ) THEN RETURN 3
    SELECT
        WHEN CheckForProgram('LZIP.EXE')   == 1 THEN lz_command = 'lzip'
        WHEN CheckForProgram('PDLZIP.EXE') == 1 THEN lz_command = 'pdlzip'
        OTHERWISE RETURN 3
    END

    /* Check the TAR version because the lzip syntax varies.
     */
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
    CALL RXQUEUE 'DELETE', listqueue

    IF tarver <= '1.10' THEN
        compress_switch = '--zip'
    ELSE
        compress_switch = '--use-compress-program'

    command = 'tar -t -v' compress_switch'='lz_command '-f "'filespec'" 2>&1 |rxqueue'

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

/*:VRX         TarZGetContents
*/
TarZGetContents: PROCEDURE EXPOSE entries.
    ARG filespec

    command = 'tar -t -v --compress -f "'filespec'" 2>&1 |rxqueue'

    IF ( CheckForProgram('TAR.EXE') == 0 ) | ( CheckForProgram('COMPRESS.EXE') == 0 ) THEN RETURN 3

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

/*:VRX         WpiGetContents
*/
WpiGetContents: PROCEDURE EXPOSE entries.
    ARG filespec

    command = 'wic -l "'filespec'" 2>&1 |rxqueue'

    PARSE VALUE SysIni('USER', 'WarpIN', 'Path') WITH warpin '00'x .
    IF LEFT( warpin, 6 ) == 'ERROR:' THEN RETURN 3
    warpin = STRIP( warpin, 'T', '\')

    CALL SETLOCAL
    old_blp = SysQueryExtLIBPATH('B')
    CALL SysSetExtLIBPATH warpin, 'B'
    _path = VALUE('PATH',,'OS2ENVIRONMENT')
    CALL VALUE 'PATH', warpin';'_path, 'OS2ENVIRONMENT'

    listqueue = RXQUEUE('CREATE')
    defqueue  = RXQUEUE('SET', listqueue )

    ADDRESS CMD '@' command listqueue

    wpaks = ''
    _tl = 0
    DO QUEUED()
        _tl = _tl + 1
        PARSE PULL line
        entries._tl = line

        IF LEFT( line, 8 ) == 'Package ' THEN DO
            PARSE VAR line 'Package ' _pckno .
            wpaks = wpaks _pckno
        END

    END

    /* Now list each of the reported packages from the archive.
     */
    DO i = 1 TO WORDS( wpaks )
        pak = WORD( wpaks, i )
        IF VERIFY( pak, '0123456789') <> 0 THEN ITERATE

        _tl = _tl + 1
        entries._tl = ''
        command = 'wic -l "'filespec'"' pak '2>&1 |rxqueue'
        ADDRESS CMD '@' command listqueue

        DO QUEUED()
            _tl = _tl + 1
            PARSE PULL line
            entries._tl = line
        END
    END

    entries.0 = _tl
    CALL RXQUEUE 'SET',    defqueue
    CALL RXQUEUE 'DELETE', listqueue

    IF old_blp <> '' THEN
        CALL SysSetExtLIBPATH old_blp, 'B'
    CALL ENDLOCAL

RETURN 0

/*:VRX         ZipCheckEncryption
*/
/*
 * Determine if a ZIP archive is encrypted with a password.
 * Returns 1 if yes, 0 otherwise.
 */
ZipCheckEncryption: PROCEDURE
    ARG zipfile

    byteseven = C2X( CHARIN( zipfile, 7, 1 ))
    encflag   = SUBSTR( X2B( byteseven ), 8, 1 )
    CALL STREAM zipfile, 'C', 'CLOSE'

RETURN encflag

/*:VRX         ZipGetContents
*/
ZipGetContents: PROCEDURE EXPOSE entries.
    ARG filespec

    command = 'unzip -l "'filespec'" 2>&1 |rxqueue'

    IF CheckForProgram('UNZIP.EXE') == 0 THEN RETURN 3

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

