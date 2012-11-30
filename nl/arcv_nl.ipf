:userdoc.

.* ----------------------------------------------------------------------------
:h1 res=001 name=intro
    x=left y=bottom width=100% height=100%.Over de Archief Bekijker
:p.De Archief Bekijker is een simpel hulpprogramma voor het bekijken en uitpakken van
:link reftype=fn refid=fn_archive.archiefbestanden:elink. van verschillende types
(zie de onderstaande tabel).

:p.Het is niet ontworpen om archieven te maken. Er zijn verschillende
commerci‰le archiefbeheer programma's beschikbaar die dat kunnen, en de
Archief Bekijker is niet bedoeld om daarmee te concurreren.

:p.Ondersteunde archieftypes&colon.
:table cols='30 20 20'.
:row.
:c.TYPE
:c.BESTANDSNAAM EXTENSIE(S)
:c.BENODIGD ARCHIEF PROGRAMMA('S)
:row.
:c.ZIP archieven
:c.*.ZIP, *.EXE, *.JAR
:c.UNZIP.EXE
:row.
:c.RAR archieven
:c.*.RAR
:c.UNRAR.EXE, RAR32.EXE or RAR.EXE
:row.
:c.ARJ archieven
:c.*.ARJ
:c.ARJ.EXE
:row.
:c.Unix tape archieven
:c.*.TAR
:c.TAR.EXE
:row.
:c.Unix tape archieven gecomprimeerd met COMPRESS
:c.*.TAR.Z, *.TZ
:c.TAR.EXE en COMPRESS.EXE
:row.
:c.Unix tape archieven gecomprimeerd met GZIP
:c.*.TAR.GZ, *.TGZ
:c.TAR.EXE en GZIP.EXE
:row.
:c.Unix tape archieven gecomprimeerd met BZIP2
:c.*.TAR.BZ2, *.TBZ
:c.TAR.EXE en BZIP2.EXE
:etable.

:nt text='Belangrijk'.Om de bovenstaande archieftypen te kunnen verwerken met
de Archief Bekijker dienen de benodigde archiefprogramma's ge‹nstalleerd te zijn
op uw systeem en beschikbaar in het PATH.:ent.

:p.:ul.
:li.:link reftype=hd res=090.Bekende beperkingen:elink.
:li.:link reftype=hd res=002.License:elink.
:li.:link reftype=hd res=003.Waardering:elink.
:eul.
:p.

.* ............................................................................
:h2 res=002 name=license
    x=left y=bottom width=100% height=100%.License
.* :p.The final license of this product is still to be determined.  In the
.* meantime, the following license terms apply to this beta release.
.*
.* :p.
.* :p.:hp5.Beta License Terms:ehp5.
.*
.* :p.The following are free to use this software, with the understanding
.* that it is not recommended for use in production environments&colon.
.* :ul.
.* :li.Any employee of, or contractor working for, Serenity Systems International
.* or Mensys BV.
.* :li.Any member of the eComStation Development Group.
.* :li.Individuals who have been designated as beta testers by the program author
.* (Alex Taylor) or by one of the above parties.
.* :li.Any member of the eComStation :hp2.TestTeam:ehp2. mailing list.
.* :li.Any eComStation user with access to Software Subscription Services and the
.* BetaZone.
.* :eul.
.*
.* :p.The Program may not be distributed to any party without the express consent
.* of either the program author, Serenity Systems International, or Mensys BV.
:p.
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
    x=left y=bottom width=100% height=100%.Waardering
:p.De Archief Bekijker is geschreven door Alex Taylor (<alextaylor41@rogers.com>),
met gebruikmaking van :hp1.Watcom VX-REXX versie 2.1d:ehp1..
:p.Speciale dank gaat uit naar de leden van de eComStation ontwikkelgroep, met
name Nicky Morrow, Veit Kannegieser, en de verschillende vertalers.
De Nederlandse versie is vertaald door de: "Nederlandse eComStation Test- en Vertaalgroep".
:p.


.* ----------------------------------------------------------------------------
:h1 res=010 name=howto
    x=left y=bottom width=100% height=100%.Gebruik van de Archief Bekijker
:p.De gebruikersinterface van de Archief Bekijker bestaat uit drie delen. Deze zijn,
van boven naar beneden&colon. een menubalk, een overzichtsgebied, en een statusbalk.

:p.De menubalk bevat de :hp2.Bestand:ehp2., :hp2.Instellingen:ehp2. en
:hp2.Help:ehp2. menu's.

:p.Het overzichtsgebied is het hoofddeel van de interface. Dit is het weergave
gebied waar de inhoud van archiefbestanden getoond wordt, als ook verschillende
informatieve meldingen.

:p.De statusblak geeft context gevoelige status meldingen weer.

:p.:ul.
:li.:link reftype=hd res=011.Open een archief:elink.
:li.:link reftype=hd res=012.Uitpakken van een archief:elink.
:eul.
:p.

.* ............................................................................
:h2 res=011 name=view
    x=left y=bottom width=100% height=100%.Open een archief
:p.Er zijn twee manieren om een archief te openen&colon.
:ol.
:li.Door het meegeven van het archiefbestand aan de Archief Bekijker als parameter
bij het opstarten (bijvoorbeeld door het los laten van het bestandsobject op het
Archief Bekijker programma pictogram op de Werkplek).
:li.Door het gebruik van de :hp2.Open:ehp2. opdracht vanuit het :hp2.Bestand:ehp2. vervolgmenu. Dit
menu onderdeel kan ook gebruikt worden door het indrukken van &osq.Ctrl+O&csq..
:eol.

:p.Als u een archiefbestand opent, probeert de Archief Bekijker de inhoud te
lezen. Als het bestand foutloos is, zal de archiefinhoud getoond worden in het
overzichtsgebied.

:p.In sommige gevallen kan een wachtwoord benodigd zijn voor het bekijken
van de archiefinhoud. Als dit het geval is zal u :link reftype=hd refid=password_dlg.gevraagd:elink.
worden om het juiste wachtwoord op te geven.

:p.Als er zich een fout voordoet zal er een foutboodschap getoond worden. Als de
externe archiefverwerker een fout vindt, zal een foutmelding getoond worden
in het overzichtsgebied.
:p.

.* ............................................................................
:h2 res=012 name=extract
    x=left y=bottom width=100% height=100%.Uitpakken van een archief
:p.Als u een archief geopend heeft en de inhoud daarvan wordt getoond in het
belangrijkste overzichtsgebied, dan kunt u die inhoud uitpakken naar een locatie
van uw keuze.

:p.Om het huidige archief uit te pakken, kiest u ofwel :hp2.Bestand:ehp2.->:hp2.Uitpakken
archief:ehp2. vanuit de menubalk, ofwel u drukt op &osq.Ctrl+E&csq..

:p.Dit zal de :link reftype=hd refid=extract_dlg.Uitpakken dialoog:elink.
openen.

:p.Als het archief beveiligd is met een wachtwoord, zal u
:link reftype=hd refid=password_dlg.gevraagd:elink. worden naar het juiste
wachtwoord.


:h3 res=013 name=extract_dlg
    x=left y=bottom width=100% height=100%.Uitpakken dialoog
:p.De Uitpakken dialoog zal u vragen om een directory (map) op te geven waarin
de bestanden uit het huidige archief in uitgepakt moeten worden.

:p.Als u 'OK' selecteert zullen de bestanden in de boven in de dialoog opgegeven
directory uitgepakt worden. U kunt de onderliggende selectielijst gebruiken om een
andere directory te selecteren of u kunt handmatig een directorynaam opgeven
(als u dat doet, dient u de volledige padnaam op te geven, inclusief stationsletter).

:p.Als de Uitpakken dialoog initieel verschijnt, zal de selectielijst altijd de
huidige directory laten zien (degene waarin het archiefbestand zich bevindt).

:p.Het invoerveld wordt automatisch bijgewerkt om de momenteel geselecteerde
directory in de selectielijst weer te geven.  Als :hp2.Archiefnaam toevoegen aan
geselecteerd pad:ehp2. geselecteerd is, zal het invoerveld een subdirectory van die
directory weergeven, die dezelfde naam heeft als het archiefbestand (zonder de extensie).
Anders zal het de directory laten zien zoals getoond in de selectielijst.

:nt.Elke directory die u opgeeft zal, als die nog niet bestaat, gemaakt worden,
maar alleen als zijn bronmap bestaat.
:p.Bijvoorbeeld, als u :hp2.C&colon.\DOWNLOAD\STUFF:ehp2. opgeeft, dient de
:hp2.C&colon.\DOWNLOAD:ehp2. directory al te bestaan, maar de
:hp2.STUFF:ehp2. subdirectory hoeft nog niet te bestaan.:ent.

:nt.Als de Archief Bekijker bestanden uitpakt vanuit een archief, zal het
alle bestanden :hp8.overschrijven:ehp8. (vervangen) in de doelmap die dezelfde
naam hebben als een bestand in het archief.
:p.

:h3 res=014 name=password_dlg
    x=left y=bottom width=100% height=100%.Wachtwoord dialoog
:p.De wachtwoord dialoog verschijnt als (en alleen als) het archief is beveiligd    
met een wachtwoord. Het vraagt u om het juiste wachtwoord op te geven voor
het bekijken en/of uitpakken van de archiefinhoud.

:p.ZIP, ARJ en RAR archiefindelingen kunnen met een wachtwoord beveiligd zijn.
In de meeste gevallen kunt u vrijelijk de inhoud van een met wachtwoord beveiligd
archief bekijken, maar ze niet uitpakken zonder het juiste wachtwoord. Echter, sommige
RAR archieven kunnen gecodeerd zijn zodat zelfs een wachtwoord nodig is voor het
bekijken van de archiefinhoud.

:p.Het wachtwoord zal niet getoond worden bij het invoeren.


.* ----------------------------------------------------------------------------
:h1 res=020 name=custom
    x=left y=bottom width=100% height=100%.Aanpassen van de Archief Bekijker
:p.De volgende eigenschappen van de Archief Bekijker kunnen door de gebruiker worden aangepast&colon.
:ul.
:li.Het gebruikte lettertype in het overzichtsgebied.
:li.Het gebruikte lettertype in de statusbalk.
:li.De gebruikte achtergrond en tekst kleuren in het overzichtsgebied.
:li.De venster grootte en positie.
:li.Of het overzichtsgebied de weergave van lange regels laat overlopen of niet.
:eul.
:p.Om het lettertype aan te passen, kunt u de :hp2.Lettertype:ehp2. keuze gebruiken
in het :hp2.Instellingen:ehp2. menu, of u kunt een lettertype uit het Lettertype Palet
verslepen en los laten op het overzichtsgebied.

:p.Om de achtergrond en voorgrond kleuren aan te passen, kunt u elke
kleur verslepen en loslaten vanuit het Vaste Kleuren Palet of Gemengde Kleuren Palet
op het overzichtsgebied. (Slepen zal normaliter de achtergrond kleur aanpassen;
slepen met de &osq.Ctrl&csq. toets ingedrukt zal de voorgrond kleur aanpassen.)

:p.De Archief Bekijker venster grootte en positie kunnen net zo aangepast worden
als bij elk ander venster&colon. door het aanpassen van het vensterkader of het
verslepen van de venster titelbalk.

:p.Aanpassingen worden automatisch opgeslagen in het configuratie bestand
:hp2.ARCVIEW.INI:ehp2. als u het programma afsluit. Dit bestand bevindt zich in
de Archief Bekijker programma directory, en zal automatisch worden gemaakt
als het niet bestaat.
:p.


.* ----------------------------------------------------------------------------
:h1 res=090 name=bugs
    x=left y=bottom width=100% height=100%.Beperkingen
:p.De Archief Bekijker heeft de volgende bekende beperkingen&colon.
:ul.
:li.Bestanden met dezelfde naam die al bestaan in de doeldirectory worden zonder
waarschuwingen overschreven.
:p.
:li.De Archief Bekijker ondersteunt :hp1.alleen:ehp1. COMPRESS, GZIP en BZIP2 als zij gebruikt
zijn voor het comprimeren van TAR archieven. Gewone niet-archiefbestanden die
met welk programma dan ook gecomprimeerd zijn worden niet ondersteund.
:p.(De reden van deze beperking is dat geen van deze programma's een inhoudsopgave ondersteunt;
het zijn simpelweg compressie programma's, geen archiveringsprogramma's op zich.)
:p.
:li.De gebruikte programma's voor het bewerken van archieven (UNZIP.EXE, ARJ.EXE, etc.) en
hun parameters zijn hard-gecodeerd in de Archief Bekijker.
:p.Dit betekent dan als de opdracht syntax ooit wijzigt de Archief Bekijker wel eens
niet meer correct zou kunnen werken. Dit betekent ook dat als ‚‚n van deze programma's
niet aanwezig is op uw systeem, er voor u geen manier is om de ondersteuning voor dat
archieftype uit te schakelen. Ook kunt u geen ondersteuning voor nieuwe archieftypes
toevoegen.
:p.
:li.Individuele bestanden of groepen van bestanden binnen een archief kunnen niet
geselecteerd of uitgepakt worden. De Archief Bekijker ondersteunt alleen het
uitpakken van gehele archieven.
:p.
:li.Sommige versies van BZIP2.EXE zijn niet uitwisselbaar met de Archief Bekijker omdat
ze pipes niet correct ondersteunen. Specifiek versies die statisch gelinkt zijn met de
EMX bibliotheken lijken dit probleem te vertonen. Versies die dynamisch gelinkt zijn
tegen EMX zouden goed moeten gaan, aangezien die met de IBM compiler(s) gecompileerd
zijn.
:eul.
:p.


.* ----------------------------------------------------------------------------
:fn id=fn_archive.
:p.Een :hp2.archiefbestand:ehp2. is een speciaal bestandstype dat zich
gedraagt als een verzameling van andere bestanden, en een inhoudsopgave
bevat die de opgenomen bestanden beschrijft.
:p.De in het archief opgenomen bestanden kunnen eventueel gecomprimeerd zijn,
afhankelijk van het archieftype.
:efn.

:euserdoc.

