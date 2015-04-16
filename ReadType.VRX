/*:VRX         Main
*/
/* These functions donated by Veit Kannegieser.  Many thanks!
 * Adapted for use with ARCVIEW by Alex Taylor.
 */
Main:
    signal on halt

    Numeric Digits 40
    Parse Arg FileName

    if FileName=='' then
        Return ''
    if Stream(FileName, 'C', 'Query Exist')=='' then
        Return ''
    rc=Stream(FileName, 'C', 'Open Read')
    if rc<>'READY:' then
        Return ''

    FileOffset=0
    FileLength=Stream(FileName, 'C', 'Query Size')

    do while FileOffset<FileLength
      BlockLength=FileLength-FileOffset
      FileType=GetFileType(FileName,FileOffset)

      if BlockLength<1 then BlockLength=1
      FileOffset=FileOffset+BlockLength
    end
    Call Stream FileName, 'C', 'Close'

Return FileType


/*******************************************************************/
/*** read first bytes to find out the file type ********************/
/*******************************************************************/
/*:VRX         compare_bytes
*/
/* '?' matches all chars */
compare_bytes:
  Parse Arg FilePosition,CompareString
  tmp=read_bytes(FilePosition,Length(CompareString))
  if Length(tmp)<>Length(CompareString) then Return 0
  do compare_bytes_i=1 to Length(CompareString)
    if Substr(tmp,compare_bytes_i,1)<>Substr(CompareString,compare_bytes_i,1) then
      if Substr(CompareString,compare_bytes_i,1)<>'?' then
        Return 0
  end
  Return 1

/*******************************************************************/


/*:VRX         GetFileType
*/
GetFileType:
  b01   =X2C(D2X(read_word_motorola(0)))
  b01234=X2C(D2X(read_dword_motorola(0)))
  if b01   ='a596'x                                     then Return 'IBM'
  if b01234='PK'||'3'x'4'x                              then Return 'ZIP'
  if b01   ='60'x'ea'x                                  then Return 'ARJ'
  if b01234='Rar'||'21'x                                then Return 'RAR'
  if b01234='770402be'x                                 then Return 'WPI'
  if compare_bytes(2,'-lh?-')                           then Return 'LHA'
  if compare_bytes(54,'FAT')                            then Return 'DSK'
  if compare_bytes(4+1+1,'archivefile/20??-??-??/')     then Return 'PF'
  if compare_bytes(0,'MSCF'||'0'x)                      then Return 'CAB'

  if b01='MZ' | b01='ZM' then
    do /* executable, try to skip executable header */

      /* special speedup for warpin: locate end of archive header,
         aligned to 512 bytes */

      o1=((FileLength-572) % 512)*512
      if (o1>0) & compare_bytes(o1,'77'x'04'x'02'x'be'x) then
        do  /* have end of file trailer, read the archive start */
          BlockLength=read_longint_intel(o1+536-FileOffset)-FileOffset
          Return 'WPI'
        end

      /* try to look for ZIP end without comment */
      if BlockLength>1000 then
        do
          o1=BlockLength-22
          if compare_bytes(o1, 'PK'||'5'x'6'x) then
            do
              o1=read_dword_intel(o1+16)
              /* main directory: file entry: */
              if compare_bytes(o1, 'PK'||'1'x'2'x) then
                do
                  /* read offset to that file -- assume it it the first.. */
                  o1=read_dword_intel(o1+42)
                  /* without 'zip.exe -A' the address is not fixed and
                     points to zero - not helpful. check valid zip begin */
                  if (o1>FileOffset) & compare_bytes(o1,'PK') then
                    do
                      BlockLength=o1
                      Return 'ZIP'
                    end
                end
            end
        end

      /* would need to implement more complicate code here to get
         the length of executable types:
           COFF
           ELF
           LE
           LX
           MZ
           NE
           PE
         executables */

      Return ''
    end

  if b01234='CA'x'FE'x'BA'x'BE'x        then Return 'JBC'

  Return ''


/*******************************************************************/
/*** file access helper functions **********************************/
/*******************************************************************/

/*:VRX         Halt
*/
Halt:

exit

/*:VRX         read_byte
*/
read_byte:
  Parse Arg FilePosition
  tmp=read_bytes(FilePosition,1)
  Return C2D(tmp)

/*:VRX         read_bytes
*/
read_bytes:
  Parse Arg FilePosition, NumberOfBytes
  Return CharIn(FileName, FileOffset+FilePosition+1, NumberOfBytes)

/*:VRX         read_c_string
*/
/* read zero terminated string */
read_c_string:
  Parse Arg FilePosition
  tmp=read_bytes(FilePosition,255)
  w1=Pos('00'x,tmp)
  if w1=0 then w1=256
  Return Left(tmp,w1-1)

/*:VRX         read_dword_intel
*/
read_dword_intel:
  Parse Arg FilePosition
  tmp=Translate('4321', read_bytes(FilePosition,4), '1234')
  Return C2D(tmp)

/*:VRX         read_dword_motorola
*/
read_dword_motorola:
  Parse Arg FilePosition
  Return C2D(read_bytes(FilePosition,4))

/*:VRX         read_integer_intel
*/
read_integer_intel:
  Parse Arg FilePosition
  tmp=Translate('21', read_bytes(FilePosition,2), '12')
  if C2D(tmp)>C2D('8000'x) then Return C2D(tmp)-C2D('10000'x)
  else                          Return C2D(tmp)

/*:VRX         read_longint_intel
*/
read_longint_intel:
  Parse Arg FilePosition
  tmp=Translate('4321', read_bytes(FilePosition,4), '1234')
  if C2D(tmp)>C2D('80000000'x) then Return C2D(tmp)-C2D('100000000'x)
  else                              Return C2D(tmp)

/*:VRX         read_word_intel
*/
read_word_intel:
  Parse Arg FilePosition
  tmp=Translate('21', read_bytes(FilePosition,2), '12')
  Return C2D(tmp)

/*:VRX         read_word_motorola
*/
read_word_motorola:
  Parse Arg FilePosition
  Return C2D(read_bytes(FilePosition,2))

