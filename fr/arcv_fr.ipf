:userdoc.
.* ----------------------------------------------------------------------------

.***************************************************
.* Archive Viewer Help - French version
.* Translator : Guillaume Gay <guillaume.gay@bigfoot.com>
.* Translation : 2012-04-08
.***************************************************
:h1 res=001 name=intro x=left y=bottom width=100% height=100%.· propos de Archive Viewer
:p.Archive Viewer est un outil simple pour afficher et extraire des 
:link reftype=fn refid=fn_archive.fichiers d'archive:elink. de diff‚rents
types communs (voir le tableau ci-dessous). 
:nt.Archive Viewer est d‚lib‚r‚ment peu sophistiqu‚ dans ses
fonctionnalit‚s et son interface utilisateur. En particulier, il
ne prend pas en charge l'extraction s‚lective, le filtrage ni la
recherche &semi. il n'a pas non plus ‚t‚ con‡u pour cr‚er ou
modifier des archives.  Il y a plusieurs autres gestionnaires
d'archives commerciaux qui proposent ces services, et Archive Viewer
n'a pas pour vocation d'entrer en concurrence avec ceux-ci (d'autant
moins au vu de sa position avantageuse, ‚tant inclus dans le systŠme
d'exploitation eComStation). :ent.
:p.Types d'archives pris en charge &colon.
:table cols='30 20 20'.
:row.
:c.TYPE
:c.EXTENSION(S) DE FICHIERS
:c.ARCHIVEUR(S) REQUIS
:row.
:c.Archives 7Z
:c.*.7Z
:c.7Z.EXE, 7ZA.EXE ou 7ZR.EXE
:row.
:c.Archives ARJ
:c.*.ARJ
:c.ARJ.EXE
:row.
:c.Archives LHArc
:c.*.LZH, *.LHA
:c.LHA.EXE
:row.
:c.Archives RAR
:c.*.RAR
:c.UNRAR.EXE, RAR32.EXE ou RAR.EXE
:row.
:c.Paquetages RPM
:c.*.RPM
:c.CPIO.EXE et soit 7Z.EXE, soit RPM2CPIO.EXE
:row.
:c.Archives de bande Unix
:c.*.TAR
:c.TAR.EXE
:row.
:c.Archives de bande Unix compress‚e en utilisant BZIP2
:c.*.TAR.BZ2, *.TBZ
:c.TAR.EXE et BZIP2.EXE
:row.
:c.Archives de bande Unix compress‚e en utilisant COMPRESS
:c.*.TAR.Z, *.TZ
:c.TAR.EXE et COMPRESS.EXE
:row.
:c.Archives de bande Unix compress‚e en utilisant GZIP
:c.*.TAR.GZ, *.TGZ
:c.TAR.EXE et GZIP.EXE
:row.
:c.Archives de bande Unix compress‚e en utilisant LZIP
:c.*.TAR.LZ
:c.TAR.EXE et soit LZIP.EXE, soit PDLZIP.EXE
:row.
:c.Archives WarpIN
:c.*.WPI
:c.WIC.EXE (fait partie de WarpIN)
:row.
:c.Archives ZIP
:c.*.ZIP, *.EXE, *.JAR
:c.UNZIP.EXE
:etable.
:p.En outre, les fichiers simples (pas des archives) qui ont ‚t‚
compress‚s utilisant COMPRESS, GZIP, BZIP2 ou LZIP peuvent aussi
ˆtre d‚compress‚s en utilisant Archive Viewer. 
:nt text='Remarque importante &colon.'.pour que Archive Viewer soit
capable de prendre en charge l'un des types d'archives ci-dessus,
l'archiveur correspondant doit ˆtre install‚ sur votre systŠme et doit
ˆtre disponible dans le chemin de recherche PATH.:ent. 
:p.:ul.
:li.:link reftype=hd res=090.Limitations connues:elink.
:li.:link reftype=hd res=002.Licence:elink.
:li.:link reftype=hd res=003.Auteur et remerciements:elink.
:eul.
:p.
.* ............................................................................
:h2 res=002 name=license x=left y=bottom width=100% height=100%.Licence
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
:h2 res=003 name=credits x=left y=bottom width=100% height=100%.Auteur et remerciements
:p.Archive Viewer a ‚t‚ ‚crit par Alex Taylor (<alex@altsan.org>), 
en utilisant :hp1.Watcom VX-REXX version 2.1d:ehp1.&per. 
:p.Mes remerciements aux membres du groupe de d‚veloppement de eComStation,
en particulier … Nicky Morrow, … Veit Kannegieser, ainsi qu'aux divers
traducteurs. 
:p.
.* ----------------------------------------------------------------------------
:h1 res=010 name=howto x=left y=bottom width=100% height=100%.Utilisation de Archive Viewer
:p.L'interface utilisateur de Archive Viewer consiste en trois parties,
qui sont, de haut en bas, la barre de menus, la zone d'affichage et la
barre d'‚tat. 
:p.La barre de menus contient les menus :hp2.Fichier:ehp2.,
:hp2.Options:ehp2. et :hp2.Aide:ehp2.&per. 
:p.La zone d'affichage repr‚sente la partie principale de l'interface. 
C'est … cet endroit qu'est list‚ le contenu d'un fichier d'archive, ainsi
que les divers messages d'informations. 
:p.La barre d'‚tat affiche les messages d'‚tat d‚pendants du contexte. 
:p.:ul.
:li.:link reftype=hd res=011.Ouvrir une archive:elink.
:li.:link reftype=hd res=012.Extraire une archive:elink.
:eul.
:p.
.* ............................................................................
:h2 res=011 name=view x=left y=bottom width=100% height=100%.Ouvrir une archive
:p.Il y a trois maniŠres d'ouvrir une archive &colon. 
:ol.
:li.en passant le fichier d'archive comme paramŠtre … Archive Viewer au
lancement (par exemple en d‚posant l'objet fichier sur l'ic“ne de Archive
Viewer sur votre bureau),
:li.en utilisant l'‚l‚ment :hp2.Ouvrir...:ehp2. du menu
:hp2.Fichier:ehp2.&per. Il est aussi possible d'acc‚der … ce menu en
effectuant la combinaison de touche
&osq.:hp2.Ctrl:ehp2.+:hp2.O:ehp2.&csq.&per. 
:li.En glissant et d‚posant un fichier d'archive du bureau ‚lectronique
dans la fenˆtre principale de Archive Viewer. 
:eol.
:p.Lorsque vous ouvrez un fichier d'archive, Archive Viewer tente de lire
son contenu. S'il n'y a aucune erreur, le contenu de l'archive apparaŒt
dans la zone d'affichage. 
:p.Dans certains cas, un mot de passe peut ˆtre requis pour afficher le
contenu de l'archive. Si c'est le cas, il vous sera 
:link reftype=hd refid=password_dlg.demand‚:elink. de fournir le mot de
passe appropri‚. 
:p.Si Archive Viewer rencontre une erreur, un message apparaŒtra en
incrustation. Si c'est le programme externe de prise en charge de
l'archive qui rencontre une erreur, le message d'erreur devrait alors
apparaŒtre dans la zone d'affichage. 
:p.
.* ............................................................................
:h2 res=012 name=extract x=left y=bottom width=100% height=100%.Extraction d'une archive
:p.Une fois l'archive ouverte et son contenu affich‚ dans la zone
d'affichage principale, vous pouvez extraire ce contenu dans
l'emplacement de votre choix. 
:p.Pour extraire l'archive en cours, utilisez soit
:hp2.Fichier:ehp2.-&gt.:hp2.Extraire...:ehp2. depuis la barre de menus,
ou appuyez sur la combinaison de touches
&osq.:hp2.Ctrl:ehp2.+:hp2.E:ehp2.&csq.&per. 
:p.La :link reftype=hd refid=extract_dlg.boŒte de dialogue
d'extraction:elink. devrait alors apparaŒtre. 
:p.Si l'archive est prot‚g‚e par mot de passe, il vous sera 
:link reftype=hd refid=password_dlg.demand‚:elink. de fournir le mot de
passe appropri‚.  
:p.
.* ............................................................................
:h3 res=013 name=extract_dlg x=left y=bottom width=100% height=100%.BoŒte de dialogue d'extraction
:p.La boŒte de dialogue d'extraction vous demande d'indiquer le
r‚pertoire (dossier) dans lequel les fichiers … extraire de l'archive
devront ˆtre plac‚s. 
:p.Lorsque vous cliquez sur ':hp2.OK:ehp2.', les fichiers sont extraits
dans le r‚pertoire indiqu‚ dans le champ d'entr‚e en haut de la boŒte de
dialogue. Vous pouvez aussi utiliser la boŒte de liste en dessous pour
s‚lectionner un r‚pertoire diff‚rent, ou vous pouvez encore taper son nom
manuellement (auquel cas, vous devrez indiquer le chemin complet, lettre
d'unit‚ incluse). 
:p.· l'ouverture initiale de la boŒte de dialogue d'extraction, la boŒte
de liste affichera toujours le r‚pertoire en cours (celui dans lequel le
fichier d'archive est situ‚). 
:p.Le champ d'entr‚e est automatiquement mis … jour pour refl‚ter le
r‚pertoire en cours d'affichage dans la boŒte de liste. Si l'option
:hp2.Ajouter le nom du fichier d'archive au chemin:ehp2. est coch‚e,
le champ d'entr‚e fera alors apparaŒtre un sous-r‚pertoire de ce
r‚pertoire portant le mˆme nom que le fichier d'archive (sans son
extension). Dans le cas contraire, il contiendra le r‚pertoire tel
qu'il est affich‚ dans la boŒte de liste. 
:nt.tout r‚pertoire que vous indiquez sera cr‚‚ s'il n'existe pas d‚j…, 
mais seulement si le dossier parent existe. 
:p.Par exemple, si vous entrez :hp2.C&colon.\TELECHARGEMENT\TRUC:ehp2.,
le r‚pertoire :hp2.C&colon.\TELECHARGEMENT:ehp2. doit ˆtre existant,
alors que le sous-r‚pertoire :hp2.TRUC:ehp2. pas forc‚ment.:ent. 
:nt.lorsque Archive Viewer extrait les fichiers d'une archive, :hp8.il
‚crase:ehp8. (remplace) tout fichier du dossier de destination
comportant le mˆme nom par celui contenu dans l'archive.:ent.
:p.
.* ............................................................................
:h3 res=014 name=password_dlg x=left y=bottom width=100% height=100%.BoŒte de dialogue de mot de passe
:p.Cette boŒte de dialogue apparaŒt si (et seulement si) l'archive est
prot‚g‚e par un mot de passe. Il vous est alors demand‚ d'entrer le
mot de passe appropri‚ pour afficher ou extraire le contenu de l'archive. 
:p.Les archives au format ZIP, 7Z, ARJ et RAR sont susceptibles d'ˆtre
prot‚g‚es par mot de passe. Dans la plupart des cas, vous pouvez
librement afficher le contenu d'une archive prot‚g‚e par mot de passe, 
mais vous ne pouvez pas l'extraire sans entrer le mot de passe correct. 
Certaines archives 7Z et RAR peuvent cependant ˆtre chiffr‚es de telle
maniŠre que le mot de passe est requis mˆme pour afficher le contenu de
l'archive. 
:p.Le mot de passe n'est pas affich‚ au cours de la frappe. 
:p. 
.* ----------------------------------------------------------------------------
:h1 res=020 name=custom x=left y=bottom width=100% height=100%.Personnalisation de Archive Viewer
:p.L'utilisateur peut personnaliser les aspects de Archive Viewer
suivants &colon. 
:ul.
:li.la langue utilis‚e pour l'interface utilisateur et l'aide en ligne,
:li.la police utilis‚e dans la zone d'affichage,
:li.la police utilis‚e dans la barre d'‚tat,
:li.les couleurs d'arriŠre-plan et de texte utilis‚es dans la zone
d'affichage,
:li.les taille et position de la fenˆtre,
:li.le reformatage ou non des longues lignes dans la zone d'affichage. 
:eul.
:p.Pour modifier les polices, vous pouvez utiliser l'‚l‚ment
:hp2.Police:ehp2. dans le menu :hp2.Options:ehp2.&per. Vous pouvez aussi
les modifier en glissant et d‚posant la police de votre choix depuis
la palette de polices du systŠme. 
:p.Pour modifier les couleurs d'arriŠre et avant-plan, vous pouvez glisser
et d‚poser n'importe quelle couleur sur la zone d'affichage depuis la
palette de couleurs simples ou la palette de couleurs compos‚es du
systŠme. Un simple glisser/d‚poser modifiera la couleur
d'arriŠre-plan&semi. glisser/d‚poser en maintenant la touche
&osq.:hp2.Ctrl:ehp2.&csq. enfonc‚e modifiera la couleur d'avant-plan. 
:p.Les taille et position de la fenˆtre de Archive Viewer peuvent ˆtre
modifi‚es comme pour n'importe quelle fenˆtre &colon. en redimensionnant
le cadre de la fenˆtre ou en d‚pla‡ant la fenˆtre par sa barre de titre. 
:p.Pour modifier la langue du programme, glissez et d‚posez un objet
depuis la palette d'options r‚gionales et linguistiques. Si la langue
d‚finie par l'objet d‚pos‚ est prise en charge par le programme, la
modification sera automatique. Dans le cas contraire, Archive Viewer
passera en anglais (option r‚gionale :hp2.en_US:ehp2.). 
:p.Les personnalisations sont automatiquement sauvegard‚es dans le fichier
de configuration :hp2.ARCVIEW.INI:ehp2. lorsque vous quittez le programme. 
Ce fichier est situ‚ dans le mˆme r‚pertoire que celui dans lequel se
trouve le fichier INI utilisateur du systŠme et sera cr‚‚ automatiquement
s'il n'existe pas d‚j…. 
:p.
.* ----------------------------------------------------------------------------
:h1 res=090 name=bugs x=left y=bottom width=100% height=100%.Limitations
:p.Archive Viewer pr‚sente les limitation connues suivantes &colon. 
:ul.
:li.Les fichiers existants dans le chemin de destination portant les mˆmes
noms que ceux de l'archive sont ‚cras‚s. Une boŒte de dialogue
d'avertissement s'affichera dŠs qiue vous voudrez extraire une archive
dans un r‚pertoire existant. 
:li.Les programmes utilis‚s pour prendre en charge les archives
(UNZIP.EXE, ARJ.EXE, etc.) et leurs paramŠtres sont cod‚s en dur dans
Archive Viewer. 
:p.Cela signifie que si la syntaxe de commande venait … changer dans une
nouvelle version de l'un de ces programme, Archive Viewer pourrait ne
plus fonctionner correctement. Cela signifie aussi que Archive Viewer
doit ˆtre explicitement modifi‚ pour la prise en charge d'un nouveau
type d'archive. 
:li.Il n'est pas possible de s‚lectionner pour l'extraction des groupes de
fichiers ou des fichiers individuels dans les archives. Archive Viewer ne
prend en charge que l'extraction d'archives entiŠres. 
:li.Certaines versions de BZIP2.EXE sont incompatibles avec Archive Viewer
parcequ'elles ne prennent pas en charge correctement les tubes ("pipes"). 
Ce sont en particulier les versions li‚es ("link‚es") statiquement avec
les bibliothŠques EMX qui semblent pr‚senter ce problŠme. Les versions
li‚es dynamiquement … EMX devraient fonctionner, de mˆme que celles
compil‚es … l'aide du (des) compilateur(s) IBM. Cependant, il ne devrait
pas y avoir de problŠme avec les versions r‚centes de BZIP2.EXE. 
:li.L'indentification intelligente des archives ex‚cutables (EXE) n'a pas
‚t‚ impl‚ment‚e. Pour l'instant, tous les fichiers EXE ouvert dans
Archive Viewer sont consid‚r‚s comme des fichiers ZIP autoextractibles. 
:li.· l'extraction d'archives ARJ prot‚g‚es par mot de passe, si vous
entrez un mot de passe incorrect, il y aura un temps de latence certain
pendant lequel rien ne semble se produire. Cela est d– au fait qu'ARJ.EXE
tente de d‚chiffrer chaque fichier de l'archive … l'aide du mot de passe
erron‚ avant de retourner une erreur. 
:eul.
:p.
.* ----------------------------------------------------------------------------
:fn id=fn_archive.
:p.Un :hp2.fichier d'archive:ehp2. est une espŠce de fichiers
particuliŠre constituant un conteneur pour d'autres fichiers et inclut
une table des matiŠre d‚crivant les fichiers qu'il contient. 
:p.Les fichiers contenus dans l'archive peuvent ˆtre compress‚s ou non
selon le type d'archive consid‚r‚. 
:efn.
:euserdoc.

