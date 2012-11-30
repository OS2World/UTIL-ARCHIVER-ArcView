:userdoc.

.* ----------------------------------------------------------------------------
:h1 res=001 name=intro
    x=left y=bottom width=100% height=100%.About Archive Viewer
:p.The Archive Viewer is a simple utility for viewing and extracting
:link reftype=fn refid=fn_archive.archive files:elink. of several common
types (see the table below).

:nt.The Archive Viewer is deliberately unsophisticated in its functionality
and user interface.  In particular, it does not support selective extraction,
filtering, or searching; not is it designed to create or modify archives.  There
are several professional products which offer these features, and the Archive
Viewer is not intended to compete with them (particularly not from the
advantageous position of being included as part of the eComStation operating
system).:ent.

:p.:hp5.Supported archive types:ehp5.
:table cols='30 20 30'.
:row.
:c.TYPE
:c.FILENAME EXTENSION(S)
:c.REQUIRED ARCHIVE PROGRAM(S)
:row.
:c.7Z archives
:c.*.7Z
:c.7Z.EXE, 7ZA.EXE or 7ZR.EXE
:row.
:c.ARJ archives
:c.*.ARJ
:c.ARJ.EXE
:row.
:c.LHArc archives
:c.*.LZH, *.LHA
:c.LHA.EXE
:row.
:c.RAR archives
:c.*.RAR
:c.UNRAR.EXE, RAR32.EXE or RAR.EXE
:row.
:c.RPM packages
:c.*.RPM
:c.CPIO.EXE and either 7Z.EXE or RPM2CPIO.EXE
:row.
:c.Unix tape archives
:c.*.TAR
:c.TAR.EXE
:row.
:c.Unix tape archives compressed using BZIP2
:c.*.TAR.BZ2
:c.TAR.EXE and BZIP2.EXE
:row.
:c.Unix tape archives compressed using COMPRESS
:c.*.TAR.Z, *.TZ
:c.TAR.EXE and COMPRESS.EXE
:row.
:c.Unix tape archives compressed using GZIP
:c.*.TAR.GZ, *.TGZ
:c.TAR.EXE and GZIP.EXE
:row.
:c.Unix tape archives compressed using LZIP
:c.*.TAR.LZ
:c.TAR.EXE and either LZIP.EXE or PDLZIP.EXE
:row.
:c.WarpIN archives
:c.*.WPI
:c.WIC.EXE (part of WarpIN)
:row.
:c.ZIP archives
:c.*.ZIP, *.EXE, *.JAR
:c.UNZIP.EXE
:etable.

:p.In addition, single (non-archive) files which have been compressed using
COMPRESS, GZIP, BZIP2 or LZIP may also be decompressed using the Archive Viewer.

:nt text='Important&colon.'.For the Archive Viewer to be able to handle any of the above
archive types, the required archive program must be installed on your system, and
available via the PATH.:ent.

:p.:ul compact.
:li.:link reftype=hd res=090.Known limitations:elink.
:li.:link reftype=hd res=002.License:elink.
:li.:link reftype=hd res=003.Acknowledgements:elink.
:eul.
:p.

.* ............................................................................
:h2 res=002 name=license
    x=left y=bottom width=100% height=100%.License
.ce GNU GENERAL PUBLIC LICENSE
.ce Version 2, June 1991

:p.Copyright (C) 1989, 1991 Free Software Foundation, Inc.
.br
59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
:p.Everyone is permitted to copy and distribute verbatim copies of this license
document, but changing it is not allowed.
:p.
.ce Preamble

:p.The licenses for most software are designed to take away your
freedom to share and change it.  By contrast, the GNU General Public
License is intended to guarantee your freedom to share and change free
software--to make sure the software is free for all its users.  This
General Public License applies to most of the Free Software
Foundation's software and to any other program whose authors commit to
using it.  (Some other Free Software Foundation software is covered by
the GNU Library General Public License instead.)  You can apply it to
your programs, too.

:p.When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
this service if you wish), that you receive source code or can get it
if you want it, that you can change the software or use pieces of it
in new free programs; and that you know you can do these things.

:p.To protect your rights, we need to make restrictions that forbid
anyone to deny you these rights or to ask you to surrender the rights.
These restrictions translate to certain responsibilities for you if you
distribute copies of the software, or if you modify it.

:p.For example, if you distribute copies of such a program, whether
gratis or for a fee, you must give the recipients all the rights that
you have.  You must make sure that they, too, receive or can get the
source code.  And you must show them these terms so they know their
rights.

:p.We protect your rights with two steps&colon. (1) copyright the software, and
(2) offer you this license which gives you legal permission to copy,
distribute and/or modify the software.

:p.Also, for each author's protection and ours, we want to make certain
that everyone understands that there is no warranty for this free
software.  If the software is modified by someone else and passed on, we
want its recipients to know that what they have is not the original, so
that any problems introduced by others will not reflect on the original
authors' reputations.

:p.Finally, any free program is threatened constantly by software
patents.  We wish to avoid the danger that redistributors of a free
program will individually obtain patent licenses, in effect making the
program proprietary.  To prevent this, we have made it clear that any
patent must be licensed for everyone's free use or not licensed at all.

:p.The precise terms and conditions for copying, distribution and
modification follow.

:p.
.ce GNU GENERAL PUBLIC LICENSE
.ce TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

:dl tsize=6 break=none.
:dt.0.
:dd.This License applies to any program or other work which contains
a notice placed by the copyright holder saying it may be distributed
under the terms of this General Public License.  The "Program", below,
refers to any such program or work, and a "work based on the Program"
means either the Program or any derivative work under copyright law&colon.
that is to say, a work containing the Program or a portion of it,
either verbatim or with modifications and/or translated into another
language.  (Hereinafter, translation is included without limitation in
the term "modification".)  Each licensee is addressed as "you".

:p.Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running the Program is not restricted, and the output from the Program
is covered only if its contents constitute a work based on the
Program (independent of having been made by running the Program).
Whether that is true depends on what the Program does.

:dt.1.
:dd.You may copy and distribute verbatim copies of the Program's
source code as you receive it, in any medium, provided that you
conspicuously and appropriately publish on each copy an appropriate
copyright notice and disclaimer of warranty; keep intact all the
notices that refer to this License and to the absence of any warranty;
and give any other recipients of the Program a copy of this License
along with the Program.

:p.You may charge a fee for the physical act of transferring a copy, and
you may at your option offer warranty protection in exchange for a fee.

:dt.2.
:dd.You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications or work under the terms of Section 1
above, provided that you also meet all of these conditions&colon.
:dl tsize=3 break=none.
:dt.a)
:dd.You must cause the modified files to carry prominent notices
stating that you changed the files and the date of any change.

:dt.b)
:dd.You must cause any work that you distribute or publish, that in
whole or in part contains or is derived from the Program or any
part thereof, to be licensed as a whole at no charge to all third
parties under the terms of this License.

:dt.c)
:dd.If the modified program normally reads commands interactively
when run, you must cause it, when started running for such
interactive use in the most ordinary way, to print or display an
announcement including an appropriate copyright notice and a
notice that there is no warranty (or else, saying that you provide
a warranty) and that users may redistribute the program under
these conditions, and telling the user how to view a copy of this
License.  (Exception&colon. if the Program itself is interactive but
does not normally print such an announcement, your work based on
the Program is not required to print an announcement.)
:edl.

:p.These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it.

:p.Thus, it is not the intent of this section to claim rights or contest
your rights to work written entirely by you; rather, the intent is to
exercise the right to control the distribution of derivative or
collective works based on the Program.

:p.In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

:dt.3.
:dd.You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following&colon.
:dl tsize=3 break=none.
:dt.a)
:dd.Accompany it with the complete corresponding machine-readable
source code, which must be distributed under the terms of Sections
1 and 2 above on a medium customarily used for software interchange; or,

:dt.b)
:dd.Accompany it with a written offer, valid for at least three
years, to give any third party, for a charge no more than your
cost of physically performing source distribution, a complete
machine-readable copy of the corresponding source code, to be
distributed under the terms of Sections 1 and 2 above on a medium
customarily used for software interchange; or,

:dt.c)
:dd.Accompany it with the information you received as to the offer
to distribute corresponding source code.  (This alternative is
allowed only for noncommercial distribution and only if you
received the program in object code or executable form with such
an offer, in accord with Subsection b above.)
:edl.

:p.The source code for a work means the preferred form of the work for
making modifications to it.  For an executable work, complete source
code means all the source code for all modules it contains, plus any
associated interface definition files, plus the scripts used to
control compilation and installation of the executable.  However, as a
special exception, the source code distributed need not include
anything that is normally distributed (in either source or binary
form) with the major components (compiler, kernel, and so on) of the
operating system on which the executable runs, unless that component
itself accompanies the executable.

:p.If distribution of executable or object code is made by offering
access to copy from a designated place, then offering equivalent
access to copy the source code from the same place counts as
distribution of the source code, even though third parties are not
compelled to copy the source along with the object code.

:dt.4.
:dd.You may not copy, modify, sublicense, or distribute the Program
except as expressly provided under this License.  Any attempt
otherwise to copy, modify, sublicense or distribute the Program is
void, and will automatically terminate your rights under this License.
However, parties who have received copies, or rights, from you under
this License will not have their licenses terminated so long as such
parties remain in full compliance.

:dt.5.
:dd.You are not required to accept this License, since you have not
signed it.  However, nothing else grants you permission to modify or
distribute the Program or its derivative works.  These actions are
prohibited by law if you do not accept this License.  Therefore, by
modifying or distributing the Program (or any work based on the
Program), you indicate your acceptance of this License to do so, and
all its terms and conditions for copying, distributing or modifying
the Program or works based on it.

:dt.6.
:dd.Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License.

:dt.7.
:dd.If, as a consequence of a court judgment or allegation of patent
infringement or for any other reason (not limited to patent issues),
conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot
distribute so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you
may not distribute the Program at all.  For example, if a patent
license would not permit royalty-free redistribution of the Program by
all those who receive copies directly or indirectly through you, then
the only way you could satisfy both it and this License would be to
refrain entirely from distribution of the Program.

:p.If any portion of this section is held invalid or unenforceable under
any particular circumstance, the balance of the section is intended to
apply and the section as a whole is intended to apply in other
circumstances.

:p.It is not the purpose of this section to induce you to infringe any
patents or other property right claims or to contest validity of any
such claims; this section has the sole purpose of protecting the
integrity of the free software distribution system, which is
implemented by public license practices.  Many people have made
generous contributions to the wide range of software distributed
through that system in reliance on consistent application of that
system; it is up to the author/donor to decide if he or she is willing
to distribute software through any other system and a licensee cannot
impose that choice.

:p.This section is intended to make thoroughly clear what is believed to
be a consequence of the rest of this License.

:dt.8.
:dd.If the distribution and/or use of the Program is restricted in
certain countries either by patents or by copyrighted interfaces, the
original copyright holder who places the Program under this License
may add an explicit geographical distribution limitation excluding
those countries, so that distribution is permitted only in or among
countries not thus excluded.  In such case, this License incorporates
the limitation as if written in the body of this License.

:dt.9.
:dd.The Free Software Foundation may publish revised and/or new versions
of the General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

:p.Each version is given a distinguishing version number.  If the Program
specifies a version number of this License which applies to it and "any
later version", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation.  If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
Foundation.

:dt.10.
:dd.If you wish to incorporate parts of the Program into other free
programs whose distribution conditions are different, write to the author
to ask for permission.  For software which is copyrighted by the Free
Software Foundation, write to the Free Software Foundation; we sometimes
make exceptions for this.  Our decision will be guided by the two goals
of preserving the free status of all derivatives of our free software and
of promoting the sharing and reuse of software generally.
.br
.ce NO WARRANTY

:dt.11.
:dd.BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
REPAIR OR CORRECTION.

:dt.12.
:dd.IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.
:edl.
:p.
.ce END OF TERMS AND CONDITIONS

:p.
.ce How to Apply These Terms to Your New Programs

:p.If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

:p.To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
convey the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

:xmp.
   &lt.one line to give the program's name and a brief idea of what it does.&gt.
   Copyright (C) 19yy  &lt.name of author&gt.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
:exmp.

:p.Also add information on how to contact you by electronic and paper mail.

:p.If the program is interactive, make it output a short notice like this
when it starts in an interactive mode&colon.

:xmp.
   Gnomovision version 69, Copyright (C) 19yy name of author
   Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type 'show w'.
   This is free software, and you are welcome to redistribute it
   under certain conditions; type 'show c' for details.
:exmp.

:p.The hypothetical commands 'show w' and 'show c' should show the appropriate
parts of the General Public License.  Of course, the commands you use may
be called something other than 'show w' and 'show c'; they could even be
mouse-clicks or menu items--whatever suits your program.

:p.You should also get your employer (if you work as a programmer) or your
school, if any, to sign a "copyright disclaimer" for the program, if
necessary.  Here is a sample; alter the names&colon.

:xmp.
   Yoyodyne, Inc., hereby disclaims all copyright interest in the program
   'Gnomovision' (which makes passes at compilers) written by James Hacker.

   &lt.signature of Ty Coon&gt., 1 April 1989
   Ty Coon, President of Vice
:exmp.

:p.This General Public License does not permit incorporating your program into
proprietary programs.  If your program is a subroutine library, you may
consider it more useful to permit linking proprietary applications with the
library.  If this is what you want to do, use the GNU Library General
Public License instead of this License.
:p.


.* ............................................................................
:h2 res=003 name=credits
    x=left y=bottom width=100% height=100%.Acknowledgements
:p.The Archive Viewer is written by Alex Taylor (alex@altsan.org), using
:hp1.Watcom VX-REXX version 2.1d:ehp1..
:p.Special thanks go to members of the eComStation Development Group, in
particular Nicky Morrow, Veit Kannegieser, and all of the various translators.
:p.


.* ----------------------------------------------------------------------------
:h1 res=010 name=howto
    x=left y=bottom width=100% height=100%.Using the Archive Viewer
:p.The Archive Viewer's user interface consists of three parts.  These are,
from top to bottom&colon. a menu bar, a viewing area, and a status bar.

:p.The menu bar contains the :hp2.File:ehp2., :hp2.Options:ehp2. and
:hp2.Help:ehp2. menus.

:p.The viewing area is the main part of the interface.  This is the display
area where the contents of archive files are listed, as well as various
informative messages.

:p.The status bar displays context-dependent status messages.

:p.:ul compact.
:li.:link reftype=hd res=011.Opening an archive:elink.
:li.:link reftype=hd res=012.Extracting an archive:elink.
:eul.
:p.

.* ............................................................................
:h2 res=011 name=view
    x=left y=bottom width=100% height=100%.Opening an archive
:p.There are three ways to open an archive&colon.
:ol.
:li.By passing the archive file to the Archive Viewer as a parameter on startup
(for instance, by dropping the file object onto the Archive Viewer's program
icon on the desktop).
:li.By using the :hp2.Open:ehp2. command from the :hp2.File:ehp2. menu.  This
menu item may also be accessed by pressing &osq.Ctrl+O&csq..
:li.By dragging and dropping an archive file from the Workplace Shell into the
main window of the Archive Viewer.
:eol.

:p.When you open an archive file, the Archive Viewer attempts to read its
contents.  If there are no errors, the archive's contents are displayed in the
viewing area.

:p.In some cases, a password may be required to view the archive's contents.
If this is the case, you will be :link reftype=hd refid=password_dlg.prompted:elink.
to provide the appropriate password.

:p.If the Archive Viewer encouters an error, a message popup will appear.  If
the external archive handler encounters an error, an error message should be
displayed in the viewing area.
:p.

.* ............................................................................
:h2 res=012 name=extract
    x=left y=bottom width=100% height=100%.Extracting an archive
:p.Once you have opened an archive and have its contents listed in the main
display area, you may extract those contents to a location of your choice.

:p.To extract the current archive, either choose :hp2.File:ehp2.->:hp2.Extract:ehp2.
from the menu bar, or press &osq.Ctrl+E&csq..

:p.This will cause the :link reftype=hd refid=extract_dlg.Extract dialog:elink.
to appear.

:p.If the archive is password-protected, you will be
:link reftype=hd refid=password_dlg.prompted:elink. for the appropriate
password.


:h3 res=013 name=extract_dlg
    x=left y=bottom width=100% height=100%.The Extract dialog
:p.The Extract dialog asks you to specify the directory (folder) into which files
extracted from the current archive will be placed.

:p.When you select 'OK', the files will be extracted into the directory
specified in the entryfield at the top of the dialog.  You can use the listbox
underneath to select a different directory, or you can manually type in a
directory name (if you do so, you must specify the fully-qualified path,
including drive letter).

:p.When the Extract dialog initially appears, the listbox will always show the
current directory (the one in which the archive file is located).

:p.The entryfield is automatically updated to reflect whatever directory the
listbox is currently showing.  If :hp2.Append archive name to selected
path:ehp2. is checked, then the entryfield will specify a subdirectory of that
directory, which has the same name as the archive file (minus the extension).
Otherwise, it will specify the directory as shown in the listbox.

:nt.Whatever directory you specify will be created if it does not already exist,
but only as long as its parent folder exists.
:p.For example, if you specify :hp2.C&colon.\DOWNLOAD\STUFF:ehp2., the
:hp2.C&colon.\DOWNLOAD:ehp2. directory must exist already, but the
:hp2.STUFF:ehp2. subdirectory need not.:ent.

:nt.When the Archive Viewer extracts the files within an archive, :hp8.it will
overwrite:ehp8. (replace) any files in the destination folder which have the
same name as a file within the archive.:ent.
:p.


:h3 res=014 name=password_dlg
    x=left y=bottom width=100% height=100%.The Password dialog
:p.The Password dialog appears if (and only if) the archive is protected by
a password.  It prompts you to enter the correct password for viewing and/or
extracting the archive contents.

:p.ZIP, 7Z, ARJ, and RAR format archives may be password-protected.  In most
cases, you can freely view the contents of a password-protected archive, but
cannot extract them without entering the correct password.  However, some 7Z
and RAR archives may be encrypted so that a password is required even to view
the archive contents.

:p.The password will not display when typed.


.* ----------------------------------------------------------------------------
:h1 res=020 name=custom
    x=left y=bottom width=100% height=100%.Customizing the Archive Viewer
:p.The following aspects of the Archive Viewer may be customized by the
user&colon.
:ul compact.
:li.The language used in the user interface and online help.
:li.The font used in the viewing area.
:li.The font used in the status bar.
:li.The background and text colours used in the viewing area.
:li.The window size and position.
:li.Whether the viewing area wraps the display of long lines.
:eul.
:p.To change the fonts, you may use the :hp2.Font:ehp2. selections under the
:hp2.Options:ehp2. menu.  You may also change them by dragging and dropping
fonts from the operating system's Font Palette.

:p.To change the background and foreground colours, you may drag and drop
any colour onto the viewing area from the operating system's Solid Color
Palette or Mixed Color Palette.  (Dragging normally will change the background
colour; dragging with the &osq.Ctrl&csq. key depressed will change the
foreground colour.)

:p.The Archive Viewer's window size and position may be changed as with
any other window&colon. by resizing the window frame or dragging the
window titlebar.

:p.To change the program language, drag a locale object from the operating
system's Locale (Country) palette.  If the language defined by the dropped
locale object is supported by the Archive Viewer, the language will change
automatically.  If the language is not supported, the Archive Viewer will
revert to English (locale :hp2.en_US:ehp2.).

:p.Customization changes are automatically saved in the configuration file
:hp2.ARCVIEW.INI:ehp2. when you exit the program.  This file is located in
the same directory as the operating system's user INI file, and will be created
automatically if it does not exist.
:p.


.* ----------------------------------------------------------------------------
:h1 res=090 name=bugs
    x=left y=bottom width=100% height=100%.Limitations
:p.The Archive Viewer has the following known limitations&colon.
:ul.
:li.Files with the same name that already exist in the destination path are
overwritten.  A warning dialog will pop up whenever you choose to extract an
archive to an existing directory.

:li.The programs used to handle archives (UNZIP.EXE, ARJ.EXE, etc.) and their
parameters are hard-coded into the Archive Viewer.  Consequently, if a new
version of one of these programs were to change its command-line syntax, the
Archive Viewer might no longer work properly.  This also means that the Archive
Viewer must be explicitly modified in order to add support for new archive
types.

:li.Individual files or groups of files within archives may not be selected or
extracted.  The Archive Viewer only supports the extraction of entire archives.

:li.Some versions of BZIP2.EXE are incompatible with the Archive Viewer because
they do not properly support pipes.  Specifically, versions which are statically
linked with the EMX libraries appear to exhibit this problem.  Versions which are
dynamically linked against EMX should be fine, as are those compiled with the IBM
compiler(s).  However, this should not be a problem with recent versions of
BZIP2.EXE.

:li.Intelligent identification of executable (EXE) archives has not been
implemented.  At present, all EXE files opened by the Archive Viewer are assumed
to be self-extracting ZIP files.

:li.When extracting password-protected ARJ archives, if you enter an incorrect
password, there will be a long delay during which nothing appears to happen.  This
is caused by ARJ.EXE attempting to decrypt every file in the archive with the
incorrect password before it returns an error.
:eul.


.* ----------------------------------------------------------------------------
:fn id=fn_archive.
:p.An :hp2.archive file:ehp2. is a special kind of file which acts as a
container for other files, and includes a table of contents describing the
files it contains.
:p.The files contained within the archive may or may not be compressed,
depending on the archive type.
:efn.

:euserdoc.

