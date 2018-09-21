#include 'kassa.ch'
#include 'inkey.ch'
*------------------------------------------------------------------------------
PROCEDURE VScreen1(lDemo)
LOCAL nCol,cD,dD                       &&___cJdl
                                       &&___cJdl:=CharXOr('v-?+xuedtg)2k',';lkj047-535fg')
PUBLIC cCsrCode,cCsrName
nCol    :=(81-Len('<< '+cJdl+' >>'))/2
nCol1   :=(81-Len(SATELITE->(AllTrim(DESC))))/2
dD      :=Date();CLEAR
cCsrCode:=CASHIER->CODE
cCsrName:=CASHIER->DESC

*------------------------------------------------------------------------------
@  0,0, 0,79 BOX '         ' COLOR 'n/w'           //'w/b'
@  1,00 SAY Space(80)        COLOR 'w/n'           //'n/w'
@  2,0,18,79 BOX '         ' COLOR 'bg+/n'         //'bg+/n'
@  2,00 TO 02,79 COLOR 'bg+'           //'b+/b'
//Box(02,00,2,79,'w+/n')
Box(21,00,23,79,'w+/w')
@ 22,66 SAY If(lGLan,'NETWORK ','LOCAL   ')+' / '+cGCP COLOR 'n/w'  //If(lGLan,'n/w','b/w')
@ 24,00 CLEAR TO 24,79
@ 22,01 SAY CASHIER->DESC       COLOR 'n/w'
IF !lDemo
   @ 22,nCol1 SAY SATELITE->(Alltrim(DESC))  COLOR 'b/w'
ELSE
   @ 22,(81-Len(cWin))/2 SAY cWin  COLOR 'b/w'
ENDIF
*------------------------------------------------------------------------------
cD:=AllTrim(Str(Day(dD)))+' '
cD+=Bulan(dD)+' '+AllTrim(Str(Year(dD)))
@ 0,nCol SAY '<< '+cJdl+' >>'   COLOR 'b/w'
@ 0,01 SAY cD                   COLOR 'n/w'
IF lGTimePr='Y' ;ShowTime(00,71,,'N/W')
ENDIF
RETURN

*-----------------------------------------------------------------------------
PROCEDURE SetTgl()
LOCAL d:=Date(),t:=Time()
LOCAL c:=SetColor()
SetColor('/gb,w+/gb')
Box(11,32,13,55,'w+/gb')
@ 11,35 SAY ' Tanggal     Jam '
@ 12,34 GET d
@ 12,46 GET t
READ
USEFILE()
SATELITE->CPDT:=d
SetColor(c)
SetDate(d)
SetTime(t)
BREAK
RETURN

*-----------------------------------------------------------------------------
FUNCTION BoxBgn(cD)
LOCAL cS:=SaveScreen(11,28,20,49),cCol:=SetColor()
SetColor('bg/n')
//@ 11,28,20,49 BOX 'ÛÛÛÛÛÛÛÛÛ'
Box(11,28,20,49,'bg/n')
@ 13,30,19,47 BOX SPACE(9)
@ 12,30 SAY cD COLOR '/bg'
SetColor(cCol)
RETURN cS

*-----------------------------------------------------------------------------
PROCEDURE BoxEnd(cD)
cS:=RestScreen(11,28,20,49,cD)
RETURN

*-----------------------------------------------------------------------------
PROCEDURE Scrolling(cD)
SCROLL(13,30,19,47,1)
@ 19,30 SAY cD
RETURN

*-----------------------------------------------------------------------------
STATIC PROCEDURE Brk()
KEYBOARD Chr(27)
InKey(0);BREAK
RETURN
*-----------------------------------------------------------------------------
FUNCTION MkMenu(aXS)
LOCAL aM1:={},aM2:={},aM3:={},aM4:={},aM5:={},aM6:={},aM7:={},cD:=''
LOCAL aM11:={},aM21:={},aM22:={},aM23:={},aM31:={}
aXS:={}
cD:=If(NNetLogged(),"! ","# ")
*-----------------------------------------------------------------------------
AAdd(aXS,{"File"    ,"Menu untuk merubah parameter.....",aM1})
aD:={}
AAdd(aM1,{"! File ^Local   "+Chr(16),"Setting Local harddisk..",aD})
AAdd(aD ,{"! ^Group         ","Merubah/menambah Data Grup........." ,{||Group(.F.)  }})
AAdd(aD ,{"! ^Departemen    ","Merubah/menambah Data Departemen..." ,{||Class(.F.)  }})
AAdd(aD ,{"! ^Produk        ","Merubah/menambah Data Barang......." ,{||Prdmf(.F.) }})
AAdd(aD ,{"! ^Kasir         ","Merubah/menambah Data Cashier......" ,{||Cashier(.F.)}})
AAdd(aD ,{"! ^Salesman      ","Merubah/menambah Data Salesman....." ,{||Sales(.F.)}})
AAdd(aD ,{"! Set ^Tombol    ","Menentukan Fungsi Tombol POS......." ,{||Sfkc(.F.)   }})
AAdd(aD ,{"! Term^inal      ","Merubah Data-data Terminal........." ,{||Stl(.F.)    }})
AAdd(aD ,{"! Para^meter     ","Merubah Data Parameter Peripheral.." ,{||Para(.F.)    }})
AAdd(aD ,{"! ^Customer Msg  ","Merubah Pesan di Customer Display.." ,{||Promosi(.F.)}})
AAdd(aD ,{"! Mem^ber        ","Merubah Tabel Data Member.........." ,{||Customer()}})
***d(aD ,{"! Tombo^l Kupon  ","Merubah Status Tender Kupon........" ,{||sfkcd(.F.)}})
AAdd(aD ,{"*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" ,                                       ,{||0           }})
AAdd(aD ,{"! ^Local Index   ","Mengindex file-file di HardDisk...." ,{||DIndex()    }})
AAdd(aD ,{"! Cop^y Produk   ","Meng-copy Data Barang dari Diskette...",{||Restore()   }})
AAdd(aD ,{"! ^B.O Restore   ","Merestore data Transfer (Back Office) dari disket..."  ,{||RestTrf(.f.) }})
IF _ICS#1
 aDD:={}
 AAdd(aD ,{"! ^Update Stok  ","Merubah STOCK Produk Server HardDisk ..." ,aDD})
 AAdd(aDD,{"! T^ambah Stok  ","Menambah STOCK Produk Local HardDisk ...." ,IF(lItmnPcs,{||UProdukXX(.F.,1)},{||UProduk(.F.,1)})})
 AAdd(aDD,{"! K^urang Stok  ","Mengurang STOCK Produk Local HardDisk ..." ,IF(lItmnPcs,{||UProdukXX(.F.,2)},{||UProduk(.F.,2)})}) //{||UProduk(.F.,2)}})
ENDIF
AAdd(aM1,{"*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" ,                                       ,{||0           }})
aD:={}
AAdd(aM1,{cD+"File ^Network "+Chr(16),"Setting LAN....................",aD})
AAdd(aD ,{"! ^Group          ","Merubah/menambah Data Group...........",{||Group(.T.)  }})
AAdd(aD ,{"! ^Departemen     ","Merubah/menambah Data Department......",{||Class(.T.)  }})
AAdd(aD ,{"! ^Produk         ","Merubah/menambah Data Barang..........",{||Prdmf(.T.) }})
AAdd(aD ,{"! ^Kasir          ","Merubah/menambah Data Cashier.........",{||Cashier(.T.)}})
AAdd(aD ,{"! ^Salesman       ","Merubah/menambah Data Salesman........" ,{||Sales(.T.)}})
AAdd(aD ,{"! Set ^Tombol     ","Menentukan Fungsi Tombol POS..........",{||Sfkc(.T.)   }})
AAdd(aD ,{"! Term^inal       ","Merubah configurasi satelite..........",{||Stl(.T.)    }})
AAdd(aD ,{"! Para^meter      ","Merubah Data Parameter Peripheral....." ,{||Para(.T.)    }})
AAdd(aD ,{"! ^Customer Msg   ","Merubah/pesan di Customer Disp........",{||Promosi(.T.)}})
AAdd(aD ,{"! Mem^ber         ","Merubah Tabel Data Member............." ,{||Customer()}})
***d(aD ,{"! Tombo^l Kupon   ","Merubah Status Tender Kupon...........",{||SFKCD(.T.)}})
AAdd(aD ,{"*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" ,                                       ,{||0           }})
AAdd(aD ,{"! ^Network Index  ","Mengindex file-file di NetWork........",{||NIndex()    }})
AAdd(aD ,{"! ^Restore Produk ","Mengambil Data Barang dari Diskette...",{||Restore()   }})
AAdd(aD ,{"! ^B.O Restore    ","Merestore data Transfer (Back Office) dari disket..."  ,{||RestTrf(.T.) }})
IF _ICS#1
 aDD:={}
 AAdd(aD ,{"! ^Update Stok  ","Menambah STOCK Produk Loacl HardDisk ..." ,aDD})
 AAdd(aDD,{"! T^ambah Stok  ","Menambah STOCK Produk Server HardDisk ..." ,IF(lItmnPcs,{||UProdukXX(.T.,1)},{||UProduk(.T.,1)})})
 AAdd(aDD,{"! K^urang Stok  ","Mengurang STOCK Produk Server HardDisk .." ,IF(lItmnPcs,{||UProdukXX(.T.,2)},{||UProduk(.T.,2)})}) //{||UProduk(.T.,2)}})
ENDIF
*-------------------------------------------------------------------------------------------
aD:={}
AAdd(aXS,{"Laporan","Laporan-laporan cashregister",aM2})
AAdd(aM2 ,{"! P^os Printer ","Laporan-laporan secara Reading" ,aM21})
AAdd(aM21,{"! ^Flash   ","Laporan-laporan secara Reading" ,aD})
AAdd(aD ,{"! ^1. Group      ","Membentuk laporan G r o u p  ",{||Menu1(01,'<GRP RPT>')}})
AAdd(aD ,{"! ^2. Department ","Membentuk laporan Department ",{||Menu1(02,'<DPT RPT>')}})
AAdd(aD ,{"! ^3. Financial  ","Membentuk laporan Financial  ",{||Menu1(03,'<FIN RPT>')}})
AAdd(aD ,{"! ^4. Cashier    ","Membentuk laporan Cashier    ",{||Menu1(04,'<CAS RPT>')}})
AAdd(aD ,{"! ^5. Salesman   ","Membentuk laporan Salesman   ",{||Menu1(19,'<SLM RPT>')}})
AAdd(aD ,{"! ^6. Hourly     ","Membentuk laporan Hourly     ",{||Menu1(05,'<HOU RPT>')}})
AAdd(aD ,{"! ^7. PLU        ","Membentuk laporan P.L.U.     ",{||Menu1(12,'<PLU RPT>')}})
IF _ICS#1
   AAdd(aD ,{"! ^8. Stock PLU  ","Membentuk laporan Stock Brg. ",{||RStoc()              }})
ENDIF
AAdd(aM21,{"*ÄÄÄÄÄÄÄÄÄÄ" ,                                  ,{||0}})
aD:={}
AAdd(aM21,{ "! ^Reset   ","Laporan-laporan setelah Reset "        ,aD})
AAdd(aD ,{"! ^1. Group      ","Membentuk laporan G r o u p  ",{||Menu1(06,'<DPT RPT>')}})
AAdd(aD ,{"! ^2. Department ","Membentuk laporan Department ",{||Menu1(07,'<CLS RPT>')}})
AAdd(aD ,{"! ^3. Financial  ","Membentuk laporan Financial  ",{||Menu1(08,'<FIN RPT>')}})
AAdd(aD ,{"! ^4. Cashier    ","Membentuk laporan Cashier    ",{||Menu1(09,'<CAS RPT>')}})
AAdd(aD ,{"! ^5. Salesman   ","Membentuk laporan Salesman   ",{||Menu1(20,'<SLM RPT>')}})
AAdd(aD ,{"! ^6. Hourly     ","Membentuk laporan Hourly     ",{||Menu1(10,'<HOU RPT>')}})
AAdd(aD ,{"! ^7. PLU Text   ","Membentuk Text File P.L.U.   ",{||Menu1(11,'<SKU TXT>')}})
AAdd(aD ,{"! ^8. PLU        ","Mencetak  laporan P.L.U.     ",{||Menu1(13,'<SKU RPT>')}})
aD:={}
AAdd(aM2 ,{"*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",                                     ,{||0}})
AAdd(aM2 ,{"! ^PC Printer  ","Laporan-laporan cashregister",aM22})
AAdd(aM22,{"! ^Flash   ","Laporan-laporan secara Reading" ,aD})
AAdd(aD ,{"!  ^1. Group      ","Membentuk laporan Group       ",{||Menu2(01,'<GRP RPT>')}})
AAdd(aD ,{"!  ^2. Department ","Membentuk laporan Department  ",{||Menu2(02,'<CLS RPT>')}})
AAdd(aD ,{"!  ^3. Financial  ","Membentuk laporan Financial   ",{||Menu2(03,'<FIN RPT>')}})
AAdd(aD ,{"!  ^4. Cashier    ","Membentuk laporan Cashier     ",{||Menu2(04,'<CAS RPT>')}})
AAdd(aD ,{"!  ^5. Salesman   ","Membentuk laporan Salesman    ",{||Menu2(19,'<SLM RPT>')}})
AAdd(aD ,{"!  ^6. Hourly     ","Membentuk laporan Hourly      ",{||Menu2(05,'<HOU RPT>')}})
AAdd(aD ,{"!  ^7. PLU        ","Membentuk laporan P.L.U.      ",{||Menu2(12,'<PLU RPT>')}})
AAdd(aD ,{"!  ^8. Infak      ","Melihat Perolehan Infak       ",{||JInfak('READ')}})
AAdd(aD ,{"!  ^9. Journal    ","Melihat Journal Transaksi ... ",{||Menu2(13,'<CAP RPT>')}})
AAdd(aD ,{"! ^10. Pengeluaran","Membentuk Laporan Pengeluaran ",{||Menu2(15,'<P/O RPT>')}})
AAdd(aM22,{"*ÄÄÄÄÄÄÄÄÄÄ" ,                                  ,{||0}})
aD:={}
AAdd(aM22,{"! ^Reset   ","Laporan-laporan setelah Reset "        ,aD})
AAdd(aD ,{"!  ^1. Group      ","Membentuk laporan Group       ",{||Menu2(06,'<GRP RPT>')}})
AAdd(aD ,{"!  ^2. Department ","Membentuk laporan Department  ",{||Menu2(07,'<CLS RPT>')}})
AAdd(aD ,{"!  ^3. Financial  ","Membentuk laporan Financial   ",{||Menu2(08,'<FIN RPT>')}})
AAdd(aD ,{"!  ^4. Cashier    ","Membentuk laporan Cashier     ",{||Menu2(09,'<CAS RPT>')}})
AAdd(aD ,{"!  ^5. Salesman   ","Membentuk laporan Salesman    ",{||Menu2(20,'<SLM RPT>')}})
AAdd(aD ,{"!  ^6. Hourly     ","Membentuk laporan Hourly      ",{||Menu2(10,'<HOU RPT>')}})
AAdd(aD ,{"!  ^7. PLU        ","Membentuk laporan P.L.U.      ",{||Menu2(11,'<SKU TXT>')}})
AAdd(aD ,{"!  ^8. Infak      ","Melihat Perolehan Infak ..... ",{||JInfak('RESET')}})
AAdd(aD ,{"!  ^9. Journal    ","Melihat Journal Transaksi ... ",{||Menu2(14,'<CAP RPT>')}})
AAdd(aD ,{"! ^10. Pengeluaran","Membentuk Laporan Pengeluaran ",{||Menu2(16,'<P/O TXT>')}})
AAdd(aM2 ,{"*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",                                     ,{||0}})
AAdd(aM2 ,{"! ^Bulanan     ","Laporan Bulanan ......... !"           ,aM23})
AAdd(aM23,{"! ^1. Group      ","Laporan Bulanan per Group ........" ,{||Menu3(06,'<GRP RPT>')}})
AAdd(aM23,{"! ^2. Department ","Laporan Bulanan per Department...." ,{||Menu3(07,'<DPT RPT>')}})
AAdd(aM23,{"! ^3. Financial  ","Laporan Bulanan per Financial....." ,{||Menu3(08,'<FIN RPT>')}})
AAdd(aM23,{"! ^4. Cashier    ","Laporan Bulanan per Cashier......." ,{||Menu3(09,'<CAS RPT>')}})
AAdd(aM23,{"! ^5. Salesman   ","Laporan Bulanan per Salesman......" ,{||Menu3(20,'<SLM RPT>')}})
AAdd(aM23,{"! ^6. Hourly     ","Laporan Bulanan per Hourly........" ,{||Menu3(10,'<HOU RPT>')}})
AAdd(aM23,{"! ^7. PLU        ","Laporan Bulanan per PLU..........." ,{||Menu3(11,'<PLU RPT>')}})

AAdd(aXS,{"Utility"      ,"Berisikan program-program penunjang "  ,aM3})
AAdd(aM3,{"! ^Set Tanggal ","Merubah tanggal system......"         ,{||SetTgl() }})
IF !NNETLOGGED()
   AAdd(aM3,{"! ^Ijin EOD    ","Memberikan ijin EOD untuk mesin yg belum di EOD ..."         ,{||ieod() }})
ENDIF
AAdd(aM3,{"*ÄÄÄÄÄÄÄÄÄÄÄÄÄ" ,                                       ,{||0        }})
AAdd(aM3,{"! ^EOD Copy    ","Pengcopyan data-data EOD ke Diskette ",{||CPCopy()}})
AAdd(aM3,{"! ^Back Up     ","Penyimpanan Data EOD ke Diskette     ",{||BackU()}})
AAdd(aM3,{"! ^Hapus       ","Hapus File-file Reset                ",{||Hapus()}})
AAdd(aM3,{"! ^Cetak Label ","Pencetakan label harga               ",{||LabelPrint()}})
AAdd(aM3,{"*ÄÄÄÄÄÄÄÄÄÄÄÄÄ",                                     ,{||0}})
AAdd(aM3,{"! Set ^Menu    ","Merubah tampilan menu program ...." ,{||ChgM()}})
AAdd(aM3,{"! Se^t Sandi   ","Merubah sandi LOG yang berjalan   " ,{||ChgS()}})
*-------------------------------------------------------------------------------------------

IF NNetLogged() .OR. lDemo
   AAdd(aXS,{"System","Memantau Seluruh Terminal ..."  ,aM4})
   AAdd(aM4,{"! ^Monitoring ","Proses maintenance T/M dari LAN",{||Dll()}})
ENDIF

AAdd(aXS,{"Keluar"      ,"Berisikan program-program penunjang "  ,aM5})
AAdd(aM5,{"! ^Kasir Login ","Kembali ke layar Login operator/spv."         ,{||Brk()    }})
*-------------------------------------------------------------------------------------------
RETURN aXS

*-------------------------------------------------------------------------------------------
STATIC PROCEDURE ChgM()
LOCAL  cD:='',cX:=''
LOCAL  aXS
IF Select('CASHIER')#0
   SELECT  CASHIER
   USE
ENDIF
IF !NetUse({{If(lGLan,NDATA,DDATA)+'CASHIER.DBF',.f.}})
   RETURN
ENDIF
DO WHILE .T.
   Box(10,33,14,64,'w+/w')
// @ 10,24 CLEAR TO 14,55
// @ 10,24 TO 14,55 DOUBLE
   @ 12,39 SAY 'Kode Kasir  : ' COLOR 'n/w'
   cD:=LogIn(12,53,.f.)
   CASHIER->(__DBLocate({||CODE==cD},,,,.f.))
   IF !CASHIER->(Found())
      Warning(' Kode Tidak Ada ... ! ')
      CASHIER->(DBCLOSEAREA())
      RETURN
   ENDIF
   EXIT
ENDDO
aXS:=MkMenu()
cD :=CASHIER->MENU;CLEAR
@ 0 ,00 SAY Space(80) COLOR '/w'
@ 0 ,32 SAY 'SET LEVEL MENU' COLOR '/w'
@ 1 ,00 SAY Space(80) COLOR '/n'
@ 2 ,00 TO 02,79 COLOR 'w+/w'           //'b+/b'
@ 23,00 TO 23,79 COLOR 'w+/w'           //'b+/b'
cD :=ChgMenus(aXS,cD)
CASHIER->MENU:=cD
CASHIER->(__DBLocate({||CODE==cGLCd},,,,.f.))
KeyBoard ' ';InKey(0)
CLOSE ALL   ;BREAK
RETURN

*------------------------------------------------------------------------------
STATIC PROCEDURE ChgP()
LOCAL  cD:='',cX:=''
IF Select('CASHIER')#0
   SELECT  CASHIER
   USE
ENDIF
IF !NetUse({{If(lGLan,NDATA,DDATA)+'CASHIER.DBF',.f.}})
   RETURN
ENDIF
DO WHILE .T.
   Box(8,15,18,46,'w+/w')
   @ 10,21 SAY 'Kode Kasir  : ' COLOR 'n/w'
   @ 12,21 SAY 'Sandi Lama  : ' COLOR 'n/w'
   @ 14,21 SAY 'Sandi Baru  : ' COLOR 'n/w'
   @ 16,21 SAY 'Sandi Verify: ' COLOR 'n/w'
   cD:=LogIn(10,35,.f.)
   CASHIER->(__DBLocate({||CODE==cD},,,,.f.))
   IF !CASHIER->(Found())
      Warning(' Kode Tidak Ada ... !')
      EXIT
   ENDIF
   cD:=LogIn(12,35,.t.)
   IF !CASHIER->(AllTrim(PASS)==cD)
      Warning(' PassWords Salah ... ! ')
      EXIT
   ENDIF
   cD:=LogIn(14,35,.t.)
   cX:=LogIn(16,35,.t.)
   IF !(cD==cX)
      Warning(' Penulisan ulang passWord salah ... ! ')
      EXIT
   ENDIF
   CASHIER->PASS:=cD
   EXIT
ENDDO
CLOSE ALL
RETURN

STATIC PROCEDURE ChgS()
LOCAL  cD:='',cX:=''
IF Select('CASHIER')#0
   SELECT  CASHIER
   USE
ENDIF
IF !NetUse({{If(lGLan,NDATA,DDATA)+'CASHIER.DBF',.f.}})
   RETURN
ENDIF
DO WHILE .T.
   Box(8,33,16,64,'w+/w')
   @ 10,39 SAY 'Kode Kasir  : ' COLOR 'n/w'
   @ 12,39 SAY 'Sandi Baru  : ' COLOR 'n/w'
   @ 14,39 SAY 'Sandi Verify: ' COLOR 'n/w'
   cD:=LogIn(10,53,.f.)
   CASHIER->(__DBLocate({||CODE==cD},,,,.f.))
   cD:=LogIn(12,53,.t.)
   cX:=LogIn(14,53,.t.)
   IF !(cD==cX)
      Warning(' Penulisan ulang PassWord salah ... ! ')
      EXIT
   ENDIF
   CASHIER->PASS:=cD
   EXIT
ENDDO
CLOSE ALL
RETURN

*-----------------------------------------------------------------------------
STATIC FUNCTION LogIn(nB,nC,lPass)
LOCAL nT,b,cKey,nLen:=6,cNum:=''
Do While .T.
   nT:=Len(cNum) 
   IF lPass ;@ nB,nC SAY Repl('þ',nT)+Space(nLen-nT) COLOR 'w/n'
      ELSE  ;@ nB,nC SAY cNum+Space(nLen-nT)         COLOR 'w/n'
   ENDIF
   nKey:=InKey(0)
   cKey:=Chr(nKey)
   If (b:=SetKey(nKey))<>NIL                      // check for SET KEY first
      Eval(b,ProcName(2),ProcLine(2),ReadVar())
      LOOP
   End
   DO CASE
   CASE nKey=K_BS .And. nT>0 ;cNum:=Left(cNum,nT-1)
   CASE nKey=32   ;cNum:=''
   CASE nKey=13   ;EXIT
   CASE cKey$'1234567890.'
      DO CASE
      CASE cKey='.' ;EXIT
      CASE nT>=nLen ;Tone(500,3)
      OTHERWISE     ;cNum+=cKey
      ENDCASE       
   ENDCASE
ENDDO
IF lPass ;@ nB,nC SAY Repl('þ',nT)+Space(nLen-nT)
   ELSE  ;@ nB,nC SAY cNum+Space(nLen-nT)
ENDIF
RETURN cNum

*-----------------------------------------------------------------------------
STATIC FUNCTION Restore()
LOCAL  aFile,nI,cO:=SetColor(),cPath,cM:=' '
LOCAL  cDrv,cFil,aD,cD,cS

*Path:=If(cStPRG='BAKERY',DDATA,NDATA)
cPath:=IF(NNetLogged(),NDATA,DDATA)

IF Select('PRODUK')#0
   SELECT  PRODUK
   USE
ENDIF
IF !NetUse({{cPath+'PRODUK.DBF',.t.}})             // .f.
   RETURN
ENDIF

IF  !File(cPath+"PRODUK_1.NTX")      ;
    .OR. !File(cPath+"PRODUK_2.NTX") ;
    .OR. !File(cPath+"PRODUK_3.NTX")
    INDEX ON CODE          TO (cPath+"PRODUK_1.NTX")
    INDEX ON Left(DESC,28) TO (cPath+"PRODUK_2.NTX")
    INDEX ON REF           TO (cPath+"PRODUK_3.NTX")
ENDIF
SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX"),(cPath+"PRODUK_3.NTX")
IF Select('CASHIER')#0
   SELECT  CASHIER
   USE
ENDIF

IF !NetUse({{If(lGLan,NDATA,DDATA)+'CASHIER.DBF',.f.}})
   RETURN
ENDIF

DO WHIL .T.
   STORE 'A'          TO cDrv
   STORE 'PRODUK.DBF' TO cFil
   @ 27,0  SAY " Restore dari Drive : _, Nama file ... ? [PRODUK.DBF  ]                          " COLOR "W/N"
   @ 27,22 GET cDrv PICT "!"             COLOR "W+/N"
   @ 27,42 GET cFil PICT "!!!!!!!!!!!!"  COLOR "W+/N"
   READ
   IF Upper(cDrv)$'AC'
      Exit
   ENDIF
ENDDO
DO CASE
   CASE Upper(cDrv)$'C' .AND. Upper(RIGHT(Alltrim(cFil),3))='DBF'
        aFile:=TDIR(cDrv+':\KASIR\'+'*.DBF')
   CASE Upper(cDrv)$'A' .AND. Upper(RIGHT(Alltrim(cFil),3))='DBF'
        aD:=Directory('A:\'+Alltrim(cFil))
        FOR nI:=1 TO Len(aD)
            FILECOPY('A:\'+aD[nI][1] ,'C:\KASIR\'+aD[nI][1])
        NEXT
        aFile:=TDIR(cDrv+':\'+'*.DBF')
   CASE Upper(cDrv)$'A' .AND. Upper(RIGHT(Alltrim(cFil),3))='ZIP'
        IF !FILE("PKZIP.EXE")
           Warning(' File PKZIP Tidak Ada ... ! ')
           RETURN
        ENDIF
        cS:=SaveScreen(0,0,24,79)
        aD:=Directory('A:\'+Alltrim(cFil))
        FOR nI:=1 TO Len(aD)
            FILECOPY('A:\'+aD[nI][1] ,'C:\KASIR\'+aD[nI][1])
        NEXT
        aD:=Directory('C:\KASIR\'+'*.ZIP')
        FOR nI:=1 TO Len(aD)
            cD:='Pkunzip '+'C:\KASIR\'+aD[nI][1]+' >Nul'
            !(cD)
        NEXT
        FOR nI:=1 TO Len(aD)
            FErase('C:\KASIR\'+aD[nI][1])
        NEXT
        RestScreen(0,0,24,79,cS)
        aFile:=TDIR('C:\KASIR\'+'*.DBF')
   OTHERWISE
        Warning(' Tidak Ada Data yang akan di Restore ... ! ')
        RETURN
ENDCASE

*--------------------------------------------------------------------------------
//_____________________________________________________aFile:=TDIR('*.DBF')
FOR nI:=1 TO Len(aFile)
    IF aFile[nI][6]='û' 
       IF aFile[nI][1]='PRODUK.DBF'  
	  SetColor("N/W,W+/N,,,R/B")
	  @ 24,0 CLEAR TO 24,79
	  @ 24,0  SAY "  Proses .......  ³ ³  Wait . . . !!!                                            " COLOR "N/W"
	  @ 24,19 SAY "*" COLOR "N*/W"
          IF Select('PD')#0
             SELECT  PD
             USE
          ENDIF
          USE (cDrv+':\'+aFile[nI][1]) NEW ALIAS PD
	  DO WHILE !Eof()
	     cD:=CODE
	     @ 24,19 SAY (cM:=Muter(cM)) COLOR "N/W"   &&__Buat Tampilan Sedang Proses OK
	     IF PRODUK->(DBSEEK(cD))
		IF  PRODUK->(RecLock())
		    PRODUK->CODE :=CODE
		    PRODUK->DESC :=DESC
		    PRODUK->PRICE:=PRICE
		ENDIF
	     ELSEIF PRODUK->(AddRec()) 
		    PRODUK->CODE :=CODE
		    PRODUK->DESC :=DESC
		    PRODUK->PRICE:=PRICE
	     ENDIF
	     PRODUK->(DBCOMMIT())
	     PRODUK->(DBUnlock())
	     SKIP 
	  ENDDO
       ENDIF
    ENDIF
NEXT
SetColor(cO)
CLOSE  ALL
RETURN NIL
*------------------------------------------------------------------------------
STATIC FUNCTION RStoc()                    &&___ReportStockPLU
LOCAL cO:=SetColor(),lS:=.f.
cPath:=IF(NNetLogged(),NDATA,DDATA)
cPath:=If(cStPRG='BAKERY',DDATA,cPath)
IF Select('PRODUK')#0
   SELECT  PRODUK
   USE
ENDIF
IF !NetUse({{cPath+'PRODUK.DBF' ,.t.}})
   RETURN
ENDIF
SELECT PRODUK
IF  !File(cPath+"PRODUK_1.NTX") .OR. ;
    !File(cPath+"PRODUK_2.NTX")            &&___.OR.;
                                           &&___!File(cPath+"PRODUK_3.NTX")
    INDEX ON CODE          TO (cPath+"PRODUK_1.NTX")
    INDEX ON Left(DESC,28) TO (cPath+"PRODUK_2.NTX")
    INDEX ON REF           TO (cPath+"PRODUK_3.NTX")
ENDIF
SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX"),(cPath+"PRODUK_3.NTX")

nT  := 7
nL  :=14
SetColor('w,/bg,,,w')
WOGrow(nT,nL,nT+03,nL+49,'w',.02)

DO WHILE .T.
   cCod1:=Space(08)
   cCod2:=Space(08)
   @ nT   ,nL+2  SAY ' STOCK REPORT ' COLOR 'W+'
   @ nT+01,nL+2  SAY ' Dari   [        ]  s/d  [        ]    '
   @ nT+02,nL+04 SAY '[SIGN ON] Kembali ke Menu              '
   @ nT+01,nL+11 GET cCOD1     PICT '@!'
   @ nT+01,nL+28 GET cCOD2     PICT '@!'
   READ
   SetColor(cO)
   IF LASTKEY()=K_ESC .OR. !RecLock()   ;RETURN
   ENDIF
   IF AllTrim(cCOD1)>AllTrim(cCOD2)     ;LOOP
   ELSE                                 ;EXIT
   ENDIF
ENDDO
SELECT PRODUK ;DBGoTop()
*FLock()
*REPLACE ALL FUPD WITH "*" FOR AllTrim(CODE)>=AllTrim(cCOD1) .AND. AllTrim(CODE)<=AllTrim(cCOD2)
*UNLock

GO TOP
SET DEVICE TO PRINT
@ PRow()+1 ,00 SAY '           ¯¯ STOCK REPORT ®®           '
@ PRow()+1 ,00 SAY  Replicate('-',40)
@ PRow()+1 ,00 SAY 'PLU      DESCRIPTION                Stok'
//                  12345678 12345678901234567890123 123,456
//                  01234567890123456789012345678901234567890
@ PRow()+1 ,00 SAY  Replicate('-',40)
DO WHILE !EOF()
   IF CODE>=AllTrim(cCOD1) .AND. CODE<=AllTrim(cCOD2)
      @ PRow()+1 ,00 SAY  CODE+' '+Left(Desc,23)+' '+TRAN(STOCK,'999,999')
   ENDIF
   SKIP
ENDDO
@ PRow()+1 ,00 SAY  Replicate('-',40)
@ PRow()+1 ,00 SAY 'Tanggal  : '+DtoC(Date())+IF(lGTimePr='Y',' Jam '+Time(),'')
@ PRow()+1 ,00 SAY CHR(13)
//FLock()
//REPLACE ALL FUPD WITH " "
//UNLock
USEFile()
PCutter()
SET DEVICE TO SCREEN
CLOSE ALL
RETURN

*------------------------------------------------------------------------------
PROCEDURE UPRODUK(lLan,nPlus)
LOCAL cO:=SetColor(),lS:=.f.,cINVCODE,lFOUND:=.F.,lADA:=.F.

cPath:=If(lLan,NDATA,DDATA)
IF Select('PRODUK')#0
   SELECT  PRODUK
   USE
ENDIF
IF !NetUse({{cPath+'PRODUK.DBF' ,.t.}})
   RETURN
ENDIF
SELECT PRODUK
IF !File(cPath+"PRODUK_1.NTX")      ;
   .OR. !File(cPath+"PRODUK_2.NTX") ;
   .OR. !File(cPath+"PRODUK_3.NTX")
   INDEX ON CODE          TO (cPath+"PRODUK_1.NTX")
   INDEX ON Left(DESC,28) TO (cPath+"PRODUK_2.NTX")
   INDEX ON REF           TO (cPath+"PRODUK_3.NTX")
ENDIF
SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX"),(cPath+"PRODUK_3.NTX")
FLock()
REPLACE ALL FUPD WITH " "
UNLock

IF Select('CASHIER')#0
   SELECT  CASHIER
   USE
ENDIF
IF !NetUse({{cPath+'CASHIER.DBF',.f.}})
   RETURN {}
ENDIF

nT:=7 ;nL:=14
nL:=8
aBox:=Box(4,00,21,79,'w+/bg')

@ 04,01 SAY IF(nPlus=1,' Penambahan STOCK ',' Pengurangan STOCK ')+'-> '+IF(lLan,'F:\WPI\DAT\PRODUK.DBF ','C:\KASIR\DAT\PRODUK.DBF ') COLOR 'w+/bg'
@ 06,01 SAY IF(nPlus=1,' Kode____   Diskripsi_____________________  StockLama TambahStock StockBaru',;
                       ' Kode____   Diskripsi_____________________  StockLama KurangStock StockBaru')        COLOR 'n/bg'
**@ 07,01 SAY '[        ] [                              ] [       ]  [       ]  [       ]'        COLOR 'n/bg'
**                     1         2         3         4         5         6         7         8
**             012345678901234567890123456789012345678901234567980123456789012345678901234567890
  @ 07,01 SAY '[             ] [                         ] [       ]  [       ]  [       ]'        COLOR 'n/bg'

DO WHILE .T.
   cCode:=Space(13)
   cDesc:=Space(25)
   nOQoh:=0 ;nAQoh:=0 ;nNQoh:=0
   @ 07,17 SAY cDESC     PICT        '@!'
   @ 07,46 SAY nOQoh     PICT   '999,999'
   @ 07,57 SAY nAQoh     PICT   '999,999'
   @ 07,68 SAY nNQoh     PICT   '999,999'
   @ 07,02 GET cCode     PICT        '@!'
   READ
   SetColor(cO)
   IF LASTKEY()=K_ESC .OR. !RecLock()
      EXIT
   ENDIF
   SELECT PRODUK
   DBSetOrder(3)
   IF DBSEEK(cCode)
      cINVCODE:=CODE
      cCODE   :=LEFT(CODE+SPACE(13),13)
      cDESC   :=LEFT(DESC,25)
      nOQoh   :=STOCK
      lS:=.t.
      @ 07,02 SAY cCODE     PICT       '@!'
      @ 07,17 SAY cDESC     PICT       '@!'
      @ 07,46 SAY nOQoh     PICT  '999,999'
      @ 07,57 GET nAQoh     PICT  '999,999'
      READ
      IF (nPlus=1,nNQoh:=nOQoh+nAQoh,nNQoh:=nOQoh-nAQoh)
      @ 07,68 SAY nNQoh     PICT '999,999'
      lFOUND:=.T.
   ENDIF

   IF !lFOUND
      DBSetOrder(1)
      SEEK cCode
      IF Found()
         cINVCODE:=CODE
         cCODE   :=LEFT(CODE+SPACE(13),13)
         cDESC   :=LEFT(DESC,25)
         nOQoh   :=STOCK
         lS:=.t.
         @ 07,02 SAY cCODE     PICT       '@!'
         @ 07,17 SAY cDESC     PICT       '@!'
         @ 07,46 SAY nOQoh     PICT  '999,999'
         @ 07,57 GET nAQoh     PICT  '999,999'
         READ
         IF (nPlus=1,nNQoh:=nOQoh+nAQoh,nNQoh:=nOQoh-nAQoh)
         @ 07,68 SAY nNQoh     PICT '999,999'
      ELSE;Wrong(' Data tidak ada - tekan [CLEAR] ... ! ') ;LOOP
      ENDIF
   ENDIF
   lFOUND:=.F.

   IF LASTKEY()=K_ESC .OR. !RecLock()
      EXIT
   ENDIF

   @ 20,02 SAY '[1]-Save atau [0]-Batal ... ! '                 COLOR '/bg'
   DO WHILE .T.
      @ 20,31 SAY '' ;i:=InKey(0)
      IF UPPER(CHR(i))$'10' ;EXIT
      ENDIF
   ENDDO
   IF UPPER(CHR(i))$'0'
      @ 20,01 SAY '                                       '     COLOR '/bg'
      LOOP
   ELSEIF UPPER(CHR(i))$'1'
      @ 20,01 SAY '                                       '     COLOR '/bg'
      RecLock()
      FIELD->DESC    :=cDESC
      FIELD->STOCKOLD:=nOQoh
      FIELD->STOCK   :=nNQoh  // STOK+TAMBAH STOK
      FIELD->FUPD    :='*'
      UNLOCK
      SetColor('n/bg')
      IF nL<=17 ;nL++
      ELSE
         Scroll(9,2,nL,78,1)
      ENDIF
      @ nL,02 SAY cCode     PICT        '@!'
      @ nL,13 SAY cDESC     PICT        '@!'
      @ nL,46 SAY nOQoh     PICT   '999,999'
      @ nL,57 SAY nAQoh     PICT   '999,999'
      @ nL,68 SAY nNQoh     PICT   '999,999'
      lADA:=.T.
   ENDIF
   lS:=.f.
ENDDO

SELECT PRODUK
GO TOP
IF lADA
   nCekPHead:=1
   DO WHILE !EOF()
      IF FUPD='*'
         IF nCekPHead=1 ;HEADSTK()
            nCekPHead:=2
         ENDIF
         *                 123456789012345678901234567890
         *                 12345678       1234567  1234567  1234567
         *                 01234567890123456789012345678901234567890
         @ PROW()+1,00 SAY DESC
         JPrint(PRow() ,40,DESC)
         @ PROW()+1,00 SAY CODE
         @ PROW()  ,15 SAY TRAN(STOCKOLD,      '999,999')
         @ PROW()  ,24 SAY TRAN(STOCK-STOCKOLD,'999,999')
         @ PROW()  ,33 SAY TRAN(STOCK,         '999,999')
         JPrint(PRow() ,40,CODE)
         JPrint(PRow() ,55,TRAN(STOCKOLD      ,'999,999'))
         JPrint(PRow() ,64,TRAN(STOCK-STOCKOLD,'999,999'))
         JPrint(PRow() ,73,TRAN(STOCK         ,'999,999'))
      ENDIF
      SKIP
   ENDDO
   IF nCekPHead=2
      @ PRow()+1 ,00 SAY REPLI('-',40)
      JPrint(PRow()  ,40,REPLI('Ä',40))
      @ PRow()+1 ,00 SAY DtoC(Date())+'þ'+LEFT(Time(),5)+'þ'+CASHIER->(AllTrim(CODE+' '+DESC))
      JPrint(PRow()  ,40,DtoC(Date())+'þ'+LEFT(Time(),5)+'þ'+CASHIER->(AllTrim(CODE+' '+DESC)))
      @ PRow()+1 ,00 SAY CHR(13)
   ENDIF
ENDIF

FLock()
REPLACE ALL FUPD WITH " "
UNLock
USEFile()
IF lADA;PCutter();ENDIF
SET DEVICE TO SCREEN
SetColor(cO)
RETURN

*------------------------------------------------------------------------------
PROCEDURE UPRODUKXX(lLan,nP)
LOCAL cO:=SetColor(),lS:=.f.,cINVCODE,lFOUND:=.F.,lADA:=.F.,aDBF:={},nTTALL:=0
LOCAL cT:=SubS(DTos(SATELITE->(CPDT)),5)
PRIVATE nNOREF,nNORTN,cNORCV:=SPACE(10),cNORTN:=SPACE(8),cKEYY,cNAME,;
        cTM:=SUBST(SATELITE->CPNO,3,2),nPAGE:=0,cPIL:='1',nPLUS:=nP,lFinish:=.F.
cNAME:=Space(20)

Box(10,15,12,56) ;SetCursor(1)
@ 11,16 SAY 'Dari / Untuk Toko :' GET cNAME        PICT '@!'
READ

SET CONFIRM ON

IF nPLUS=1
  nNOREF:=SATELITE->NOREF
  IF nNOREF=0;nNOREF++;ENDIF
ELSE
  nNORTN:=SATELITE->NORTN
  IF nNORTN=0;nNORTN++;ENDIF
ENDIF

cPath:=If(lLan,NDATA,DDATA)
IF Select('PRODUK')#0
   SELECT  PRODUK
   USE
ENDIF
IF !NetUse({{cPath+'PRODUK.DBF' ,.t.}})
   RETURN
ENDIF
SELECT PRODUK
IF !File(cPath+"PRODUK_1.NTX")      ;
   .OR. !File(cPath+"PRODUK_2.NTX") ;
   .OR. !File(cPath+"PRODUK_3.NTX")
   INDEX ON CODE          TO (cPath+"PRODUK_1.NTX")
   INDEX ON Left(DESC,28) TO (cPath+"PRODUK_2.NTX")
   INDEX ON REF           TO (cPath+"PRODUK_3.NTX")
ENDIF
SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX"),(cPath+"PRODUK_3.NTX")

IF !FILE('C:UPDTMP.DBF')
   aDBF:=DBSTRUCT()
   DBCREATE('C:UPDTMP',aDBF)
ENDIF

IF !NetUse({{'C:UPDTMP.DBF',.f.}})
   RETURN {}
ENDIF

IF UPDTMP->(LASTREC()=0)
   lFinish:=.T.
ENDIF

nT:=7 ;nL:=14
nL:=8
aBox:=Box(2,00,21,79,'w+/bg')

IF !lFinish
   SELECT UPDTMP
   nL:=7;DBGOTOP()
   DO WHILE !EOF()
      SetColor('n/bg')
      IF nL<=17 ;nL++
      ELSE
         Scroll(9,2,nL,78,1)
      ENDIF
      @ nL,01 SAY CODE             PICT          '@!'
      @ nL,14 SAY DESC             PICT          '@!'
      @ nL,35 SAY STOCKOLD         PICT     '999,999'
      @ nL,46 SAY STOCK            PICT     '999,999'
      @ nL,57 SAY STOCK+STOCKOLD   PICT     '999,999'
      @ nL,67 SAY CPRICE           PICT   '9,999,999'
      SKIP
   ENDDO
   lADA:=.T.
ENDIF

IF nPLUS=1
   cNORCV :=cTM+RIGHT('00000'+ALLTRIM(STR(nNOREF)),5)
ELSE
   cNORTN :=cTM+RIGHT('00000'+ALLTRIM(STR(nNORTN)),5)
ENDIF

cNOFORM:=IF(nPLUS=1,'No.Rcv:'+cNORCV,'No.Rtn:'+cNORTN)
@ 02,01 SAY IF(nPlus=1,' Penambahan STOCK ',' Pengurangan STOCK ')+'-> '+IF(lLan,'F:\WPI\DAT\PRODUK.DBF ','C:\KASIR\DAT\PRODUK.DBF ';
                         +cNOFORM+' ') COLOR 'w+/bg'
@ 03,01 SAY IF(nPlus=1,'                                 StockLama TambahStock StockBaru  Hrg Modal ',;
                       '                                 StockLama KurangStock StockBaru  Hrg Modal ')        COLOR 'n/bg'

**                    1         2         3         4         5         6         7         8
**          012345678901234567890123456789012345678901234567980123456789012345678901234567890
@ 04,01 SAY 'Kode :                Barcode : 1234567890123  H.Jual:'                              COLOR 'n/bg'
@ 05,01 SAY '[                              ] [       ]  [       ]  [       ] [         ]'        COLOR 'n/bg'
@ 07,01 SAY 'Kode         Nama Barang             Stok     Tambah  Stok Baru       Modal'         COLOR 'n/bg'

DO WHILE .T.
   cCode:=Space(13)   ;cBarcode:=Space(13)
   cDesc:=Space(30)
   nOQoh:=0 ;nAQoh:=0 ;nNQoh:=0 ;nHrgModal:=0 ;nHrgJual:=0

   SetKey(K_F3,{||PRODUK->(CariItem())})

   @ 04,33 SAY cBARCODE  PICT          '@!'
   @ 04,56 SAY nHrgJual  PICT   '9,999,999'
   @ 05,02 SAY cDESC     PICT          '@!'
   @ 05,35 SAY nOQoh     PICT     '999,999'
   @ 05,46 SAY nAQoh     PICT     '999,999'
   @ 05,57 SAY nNQoh     PICT     '999,999'
   @ 05,67 SAY nHrgModal PICT   '9,999,999'
   @ 04,08 GET cCode     PICT          '@!'
   READ
   SetColor(cO)
   IF LASTKEY()=K_ESC .OR. !RecLock()
      EXIT
   ENDIF
   IF EMPTY(cCODE);LOOP;ENDIF

   SELECT PRODUK
   DBSetOrder(3)
   IF DBSEEK(cCode)
      cBARCODE :=REF
      cCODE    :=LEFT(CODE+SPACE(13),13)
      cDESC    :=DESC
      nOQoh    :=STOCK
      nHrgModal:=CPRICE
      nHrgJual :=PRICE
      lS:=.t.
      @ 04,08 SAY cCODE     PICT         '@!'
      @ 04,33 SAY cBARCODE  PICT         '@!'
      @ 05,02 SAY cDESC     PICT         '@!'
      @ 05,35 SAY nOQoh     PICT    '999,999'
      @ 04,56 GET nHrgJual  PICT  '9,999,999'
      @ 05,46 GET nAQoh     PICT    '999,999'
      @ 05,67 GET nHrgModal PICT  '9,999,999'
      READ
      IF LastKey()=27;Loop;ENDIF
      IF (nPlus=1,nNQoh:=nOQoh+nAQoh,nNQoh:=nOQoh-nAQoh)
      @ 05,57 SAY nNQoh     PICT '999,999'
      lFOUND:=.T.
   ENDIF

   IF !lFOUND
      DBSetOrder(1)
      SEEK cCode
      IF Found()
         cBARCODE :=REF
         cCODE    :=LEFT(CODE+SPACE(13),13)
         cDESC    :=DESC
         nOQoh    :=STOCK
         nHrgModal:=CPRICE
         nHrgJual :=PRICE
         lS:=.t.
         @ 04,08 SAY cCODE     PICT         '@!'
         @ 04,33 SAY cBARCODE  PICT         '@!'
         @ 05,02 SAY cDESC     PICT         '@!'
         @ 05,35 SAY nOQoh     PICT    '999,999'
         @ 04,56 GET nHrgJual  PICT  '9,999,999'
         @ 05,46 GET nAQoh     PICT    '999,999'
         @ 05,67 GET nHrgModal PICT  '9,999,999'
         READ
         IF LastKey()=27;Loop;ENDIF
         IF (nPlus=1,nNQoh:=nOQoh+nAQoh,nNQoh:=nOQoh-nAQoh)
         @ 05,57 SAY nNQoh     PICT '999,999'
      ELSE;Wrong(' Data tidak ada - tekan [CLEAR] ... ! ') ;LOOP
      ENDIF
   ENDIF
   lFOUND:=.F.

   IF LASTKEY()=K_ESC .OR. !RecLock()
      EXIT
   ENDIF

   @ 20,02 SAY '[1]-Save atau [0]-Batal ... ! '                 COLOR '/bg'
   DO WHILE .T.
      @ 20,31 SAY '' ;i:=InKey(0)
      IF UPPER(CHR(i))$'10' ;EXIT
      ENDIF
   ENDDO
   IF UPPER(CHR(i))$'0'
      @ 20,01 SAY '                                       '     COLOR '/bg'
      LOOP
   ELSEIF UPPER(CHR(i))$'1'
      @ 20,01 SAY '                                       '     COLOR '/bg'
      RecLock()
      FIELD->CODE    :=cCODE
      FIELD->DESC    :=cDESC
      FIELD->STOCKOLD:=nOQoh
      FIELD->STOCK   :=nNQoh        // STOK+TAMBAH STOK
      FIELD->CPRICE  :=nHrgModal
      FIELD->PRICE   :=nHrgJual
      FIELD->LASTORD :=DATE()
      UNLOCK

      UPDTMP->(DBAPPEND())
      UPDTMP->CODE    :=cCODE
      UPDTMP->DESC    :=cDESC
      UPDTMP->STOCK   :=nAQoh       // STOK+TAMBAH STOK
      UPDTMP->STOCKOLD:=nOQoh       // STOK+TAMBAH STOK
      UPDTMP->CPRICE  :=nHrgModal
      UPDTMP->PRICE   :=nHrgJual
      UPDTMP->MTS     :=cNAME
      UPDTMP->TGL     :=DATE()

      SetColor('n/bg')
      IF nL<=17 ;nL++
      ELSE
         Scroll(9,2,nL,78,1)
      ENDIF
      @ nL,01 SAY cCode     PICT          '@!'
      @ nL,14 SAY cDESC     PICT          '@!'
      @ nL,35 SAY nOQoh     PICT     '999,999'
      @ nL,46 SAY nAQoh     PICT     '999,999'
      @ nL,57 SAY nNQoh     PICT     '999,999'
      @ nL,67 SAY nHrgModal PICT   '9,999,999'
      lADA:=.T.
   ENDIF
   lS:=.f.
ENDDO


IF lADA
   SELECT UPDTMP
   GO TOP
   UPDPRINT()
   IF lLAN
      IF nPLUS=1
         COPY TO (NDATA+'\R'+cNORCV)
      ELSE
         COPY TO (NDATA+'\N'+cNORTN)
      ENDIF
   ENDIF
   IF nPLUS=1
      COPY TO ('DAT\R'+cNORCV)
   ELSE
      COPY TO ('DAT\N'+cNORTN)
   ENDIF
   __DBZAP()
ELSE
   IF nPLUS=1
      @ 20,02 SAY '[1]-RePrint Form Receive ? atau [0]-Exit '   COLOR '/bg'
   ELSE
      @ 20,02 SAY '[1]-RePrint Form Return ? atau [0]-Exit  '   COLOR '/bg'
   ENDIF
   DO WHILE .T.
      @ 20,45 SAY '' ;i:=InKey(0)
      IF UPPER(CHR(i))$'10' ;EXIT
      ENDIF
   ENDDO

   IF UPPER(CHR(i))$'0'
      @ 20,01 SAY '                                           '     COLOR '/bg'
   ELSEIF UPPER(CHR(i))$'1'
      @ 20,01 SAY '                                           '     COLOR '/bg'
      IF nPLUS=1
         cNORCV:=SPACE(08)
         @ 20,01 SAY 'Masukkan No.Receive : ' GET cNORCV            COLOR '/bg'
      ELSE
         cNORTN:=SPACE(08)
         @ 20,01 SAY 'Masukkan No.Return  : ' GET cNORTN            COLOR '/bg'
      ENDIF
      READ
      IF EMPTY(cNORCV) .OR. EMPTY(cNORTN)
         DispNoForm()
         IF nPLUS=1
            cNORCV:=cKEYY
            @20,23 SAY cNORCV
         ELSE
            cNORTN:=cKEYY
            @20,23 SAY cNORTN
         ENDIF
      ENDIF

      cPATH:=IF(lLAN,NDATA,'DAT\')
      IF nPLUS=1
         IF cNORCV=NIL;cNORCV:='0';ENDIF
         cNORCV:=ALLTRIM(cNORCV)
         IF !EMPTY(cNORCV) .AND. FILE(cPATH+'R'+cNORCV+'.DBF')
            cFI  :='R'+cNORCV
            IF !NetUse({{cPATH+cFI,.f.}})
               RETURN {}
            ENDIF
            SELECT &cFI
            DBGOTOP()
            UPDPRINT()
         ENDIF
      ELSE
         IF cNORTN=NIL;cNORTN:='0';ENDIF
         cNORTN:=ALLTRIM(cNORTN)
         IF !EMPTY(cNORTN) .AND. FILE(cPATH+'N'+cNORTN+'.DBF')
            cFI  :='N'+cNORTN
            IF !NetUse({{cPATH+cFI,.f.}})
               RETURN {}
            ENDIF
            SELECT &cFI
            DBGOTOP()
            UPDPRINT()
         ENDIF
      ENDIF
      @ 20,01 SAY '                                            '     COLOR '/bg'
   ENDIF
ENDIF

USEFile()
IF lADA
   IF nPLUS=1
      nNOREF++
      SATELITE->NOREF:=nNOREF
   ELSE
      nNORTN++
      SATELITE->NORTN:=nNORTN
   ENDIF
ENDIF
SET DEVICE TO SCREEN
SET CONFIRM OFF
SET KEY K_F3 TO
SetColor(cO)
RETURN
*------------------------------------------------------------------------------
STATIC PROCEDURE CariItem()
 LOCAL nChoice,cSvScreen, cColor:=SetColor()
 DBSetOrder(2)
 aF:={{'NAME'   ,'DESC' };
     ,{'CODE'   ,'CODE' };
     ,{'BARCODE','REF'  }}
 cSvScreen:=SaveScreen(0,0,27,79)
 TBLook(aF,{|xD|DBSeek(xD)},'[Item List]',{12,0,27,45})
 DBSetOrder(1)
 RestScreen(0,0,27,79,cSvScreen)
 IF LastKey()=K_ENTER
    cCODE  :=CODE
 ENDIF
RETURN
*-----------------------------------------------------------------------------
STATIC PROCEDURE DispNoForm()
LOCAL aDir:={}      //DIRECTORY(DDATA+"???_HOLD.DBF")
LOCAL aFile:={},aPilih:={},nX:=0,cS:='',cOld:=SETCOLOR(),nD

IF nPLUS=1
   aDir:=DIRECTORY(CPATH+"R0??????.DBF")
ELSE
   aDir:=DIRECTORY(CPATH+"N0??????.DBF")
ENDIF

FOR nX:=1 TO LEN(aDir)
    AADD(aFile,aDir[nX][1])
NEXT nX

nBanyak:=LEN(aFile)
cS:=SAVESCREEN(09,65,21,78)
SETCOLOR('W/N')                            &&___('N/W')
@ 09,65 CLEAR TO 21,78
@ 09,65 TO 21,78
@ 10,65 SAY '³ FORM LIST  ³'
@ 11,65 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄ´'
IF LEN(aFile)<1
   RESTSCREEN(09,65,21,78,cS)
   nGK:=28
   RETURN
ENDIF
nD    :=AT('.',aFile[1])
FOR nX:=1 TO LEN(aDir)
    AADD(aPilih,LEFT(aDir[nX][1],nD-1))
NEXT nX
nGK:=0
//Set Key 28 TO Keluar
//Set Key 19 TO Keluar
//Set Key  4 TO Keluar
nPilih:=aChoice(12,66,20,77,aPilih)
//Set Key 28 TO
//Set Key 19 TO
//Set Key  4 TO
IF LastKey()=27 .OR. nGK=28
   RESTSCREEN(09,65,21,78,cS)
   cKEYY:='0'
   RETURN
ENDIF
SETCOLOR(cOld)
cKeyy:=SUBST(aPilih[nPilih],2,7)
RESTSCREEN(09,65,21,78,cS)
RETURN

*------------------------------------------------------------------------------
FUNCTION UPDPRINT()

 cPIL:="1"

 @ 20,01 SAY " Pilihan [1]Layar [2]PrinterRcpt [3]Printer80Col ?                                      " COLOR '/bg'

 @ 20,11 SAY "1"                   COLOR '/bg'
 @ 20,20 SAY "2"                   COLOR '/bg'
 @ 20,35 SAY "3"                   COLOR '/bg'
 @ 20,54 GET cPil Valid cPil$"123" COLOR '/bg'
 READ

 SET DEVICE TO PRINTER
 IF cPil="1"
    SET PRINTER TO $PRDUPD.TXT
 ENDIF
 IF cPil='3' .OR. cPil='1'
    CTKUPD80()
 ELSE
    CETAKUPD()
 ENDIF
 @ 20,01 SAY "                                                                                        " COLOR '/bg'

RETURN
*------------------------------------------------------------------------------
FUNCTION CETAKUPD()
   nCekPHead:=1
   nTTALL   :=0
   DO WHILE !EOF()
      IF nCekPHead=1 ;HEADSTKXX()
         nCekPHead:=2
      ENDIF
      *                 123456789012345678901234567890
      *                 0123456789012345678901234567890123456789
      *                 12345678 123456   123456789  12345678901
      @ PROW()+1,00 SAY DESC
      JPrint(PRow() ,40,DESC)
      @ PROW()+1,00 SAY CODE
      @ PROW()  ,09 SAY TRAN(STOCK,            '999,999')
      @ PROW()  ,18 SAY TRAN(CPRICE,         '9,999,999')
      @ PROW()  ,29 SAY TRAN(STOCK*CPRICE, '999,999,999')
      JPrint(PRow() ,40,CODE)
      JPrint(PRow() ,49,TRAN(STOCK,           '999,999'))
      JPrint(PRow() ,58,TRAN(CPRICE,        '9,999,999'))
      JPrint(PRow() ,69,TRAN(STOCK*CPRICE,'999,999,999'))
      nTTALL+=STOCK*CPRICE
      SKIP
   ENDDO
   IF nCekPHead=2
      @ PRow()+1 ,00 SAY REPLI('-',40)
      JPrint(PRow()  ,40,REPLI('Ä',40))
      @ PRow()+1 ,00 SAY 'TOTAL '
      @ PRow()   ,27 SAY TRAN(nTTALL,'9,999,999,999')
      JPrint(PRow()  ,40,'TOTAL ')
      JPrint(PRow()  ,67,TRAN(nTTALL,'9,999,999,999'))
      @ PRow()+1 ,00 SAY REPLI('-',40)
      JPrint(PRow()  ,40,REPLI('Ä',40))
      @ PRow()+1 ,00 SAY DtoC(Date())+'þ'+LEFT(Time(),5)+'þ'+cCsrCode+' '+cCsrName
      JPrint(PRow()  ,40,DtoC(Date())+'þ'+LEFT(Time(),5)+'þ'+cCsrCode+' '+cCsrName)
      @ PRow()+1 ,00 SAY CHR(13)
   ENDIF
   PCUTTER()
RETURN
*------------------------------------------------------------------------------
FUNCTION CTKUPD80()
   nTTALL   :=0
   nQTYALL  :=0
   SETPRC(0,0)
   HEADSTK80()
   DO WHILE !EOF()
    *                   01234567890123456789012345678901234567890123456789012345678901234567890
    *                   12345678 123456789012345678901234567890 1234567  123456789  12345678901
      @ PROW()+1,00 SAY CODE
      @ PROW()  ,09 SAY DESC
      @ PROW()  ,40 SAY TRAN(STOCK,            '999,999')
      @ PROW()  ,49 SAY TRAN(CPRICE,         '9,999,999')
      @ PROW()  ,60 SAY TRAN(STOCK*CPRICE, '999,999,999')
      nTTALL+=STOCK*CPRICE
      nQTYALL+=STOCK
      SKIP
      IF PROW()>60
         IF cPil='3' .OR. cPil='1'
            @PRow()+1,00 SAY '-----------------------------------------------------------------------'
            @PROW()+1,00 SAY Chr(12)   //EJECT
            SETPRC(0,0)
            HEADSTK80()
         ENDIF
      ENDIF
   ENDDO
   @ PRow()+1 ,00 SAY REPLI('-',71)
   @ PRow()+1 ,00 SAY 'TOTAL '
   @ PRow()   ,40 SAY TRAN(nQTYALL,'999,999')
   @ PRow()   ,58 SAY TRAN(nTTALL,'9,999,999,999')
   @ PRow()+1 ,00 SAY REPLI('-',71)
   //IF nPLUS=1
   //   @ PRow()+1 ,00 SAY 'Tgl.Receive  : '+dFORM+'þ'+LEFT(Time(),5)
   //ELSE
   //   @ PRow()+1 ,00 SAY 'Tgl.Return   : '+dFORM+'þ'+LEFT(Time(),5)
   //ENDIF
   @ PRow()+1 ,06 SAY '  Menyerahkan : '
   @ PRow()   ,45 SAY '   Menerima    : '
   @ PRow()+4 ,05 SAY '(     '+cCsrName+'     )'
   @ PRow()   ,45 SAY '(                  )'
   @ PRow()+1 ,00 SAY CHR(12)

   SET PRINTER TO
   SET DEVI TO SCREEN
   IF cPil="1"
      SAVE SCREEN TO cSCR01
      DISPREPR(1,'$PRDUPD.TXT')
      FILEDELETE('$PRDUPD.TXT')
      RESTORE SCREEN FROM cSCR01
   ENDIF
RETURN
*------------------------------------------------------------------------------
STATIC PROCEDURE HEADSTKXX()
 IF nPLUS=1
    @ PRow()+1 ,00 SAY '          ®® UPDATE STOCK ¯¯            '
    JPrint(PRow()  ,40,'          ®® UPDATE STOCK ¯¯            ')
    @ PRow()+2 ,00 SAY  'No.Receive : '+cNORCV
    JPrint(PRow()  ,40, 'No.Receive : '+cNORCV)
 ELSE
    @ PRow()+1 ,00 SAY '          ®® KURANG STOCK ¯¯            '
    JPrint(PRow()  ,40,'          ®® KURANG STOCK ¯¯            ')
    @ PRow()+2 ,00 SAY  'No.Return  : '+cNORTN
    JPrint(PRow()  ,40, 'No.Return  : '+cNORTN)
 ENDIF
 @ PRow()+1 ,00 SAY  Replicate('-',40)
 JPrint(PRow()  ,40, Replicate('-',40))
 @ PRow()+1 ,00 SAY 'NAMA BARANG                             '
 JPrint(PRow()  ,40,'NAMA BARANG                             ')
 *                   0123456789012345678901234567890123456789
 *                   12345678 1234567  123456789   1234567890
 IF nPLUS=1
    @ PRow()+1 ,00 SAY 'KODE      QTY.IN    H.MODAL        TOTAL'
    JPrint(PRow()  ,40,'KODE      QTY.IN    H.MODAL        TOTAL')
 ELSE
    @ PRow()+1 ,00 SAY 'KODE      QTYOUT    H.MODAL        TOTAL'
    JPrint(PRow()  ,40,'KODE      QTYOUT    H.MODAL        TOTAL')
 ENDIF
 @ PRow()+1 ,00 SAY  Replicate('=',40)
 JPrint(PRow()  ,40, Replicate('=',40))
RETURN
*------------------------------------------------------------------------------
STATIC PROCEDURE HEADSTK80()
 IF nPLUS=1
    @ PRow()+1 ,00 SAY '®®  TAMBAH STOK  ¯¯'
    @ PRow()+1 ,00 SAY 'DARI : '+cNAME
    @ PRow()+1 ,00 SAY 'UNTUK: '+SATELITE->DESC
    @ PRow()+1 ,00 SAY 'No.Mutasi Masuk : '+cNORCV
    @ PRow()+1 ,00 SAY 'Tgl.Mutasi      : '+TransDate(TGL)
 ELSE
    @ PRow()+1 ,00 SAY '®®  KURANG STOK  ¯¯'
    @ PRow()+1 ,00 SAY 'DARI : '+SATELITE->DESC
    @ PRow()+1 ,00 SAY 'UNTUK: '+cNAME
    @ PRow()+1 ,00 SAY 'No.Return  : '+cNORTN
    @ PRow()+1 ,00 SAY 'Tgl.Mutasi : '+TransDate(TGL)
 ENDIF
 @ PROW()   ,62 SAY 'Hal:'+Tran(++nPage,'9,999')
 @ PRow()+1 ,00 SAY '-----------------------------------------------------------------------'
 IF nPLUS=1
    @ PRow()+1 ,00 SAY 'KODE     NAMA BARANG                     QTY.IN    H.MODAL        TOTAL'
 ELSE
    @ PRow()+1 ,00 SAY 'KODE     NAMA BARANG                     QTYOUT    H.MODAL        TOTAL'
 ENDIF
 @ PRow()+1 ,00 SAY '-----------------------------------------------------------------------'
 *                   01234567890123456789012345678901234567890123456789012345678901234567890
 *                   12345678 123456789012345678901234567890 1234567  123456789   1234567890
RETUR
*------------------------------------------------------------------------------
STATIC PROCEDURE HEADSTK()
SET DEVICE TO PRINT
@ PRow()+1 ,00 SAY '          ®® UPDATE STOCK ¯¯            '
JPrint(PRow()  ,40,'          ®® UPDATE STOCK ¯¯            ')
@ PRow()+1 ,00 SAY  Replicate('-',40)
JPrint(PRow()  ,40, Replicate('-',40))
@ PRow()+1 ,00 SAY 'NAMA BARANG                             '
JPrint(PRow()  ,40,'NAMA BARANG                             ')
@ PRow()+1 ,00 SAY 'KODE              LAMA   TAMBAH     BARU'
JPrint(PRow()  ,40,'KODE              LAMA   TAMBAH     BARU')
@ PRow()+1 ,00 SAY  Replicate('=',40)
JPrint(PRow()  ,40, Replicate('=',40))
RETURN
*------------------------------------------------------------------------------
STATIC PROCEDURE HEADST2()
SET DEVICE TO PRINT
@ PRow()+1 ,00 SAY '           ¯¯ KURANG STOCK ®®           '
@ PRow()+1 ,00 SAY  Replicate('-',40)
@ PRow()+1 ,00 SAY 'PLU      DESC         LAMA KURANG  STOCK'
@ PRow()+1 ,00 SAY  Replicate('=',40)
RETURN
*------------------------------------------------------------------------------
PROCEDURE MINPROD(lLan)
LOCAL cO:=SetColor(),lS:=.f.

cPath:=If(lLan,NDATA,DDATA)
IF Select('PRODUK')#0
   SELECT  PRODUK
   USE
ENDIF
IF !NetUse({{cPath+'PRODUK.DBF' ,.t.}})
   RETURN
ENDIF
SELECT PRODUK
IF  !File(cPath+"PRODUK_1.NTX") .OR. ;
    !File(cPath+"PRODUK_2.NTX")            &&___.OR.;
                                           &&___!File(cPath+"PRODUK_3.NTX")
    INDEX ON CODE          TO (cPath+"PRODUK_1.NTX")
    INDEX ON Left(DESC,28) TO (cPath+"PRODUK_2.NTX")
                                           &&___INDEX ON REF           TO (cPath+"PRODUK_3.NTX")
ENDIF
SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX")         &&___,(cPath+"PRODUK_3.NTX")

nT:= 7
nL:=14

SetColor('w,/bg,,,w')
WOGrow(nT,nL,nT+08,nL+49,'w',.01)
DO WHILE .T.
   cCode:=Space(08)
   cDESC:=Space(25)
   nOQoh:=0
   nRQoh:=0
   @ nT   ,nL+2  SAY ' MIN STOCK ' COLOR 'W+'
   @ nT+01,nL+2  SAY ' Kode PLU     [        ]'
   @ nT+02,nL+2  SAY ' Diskripsi    [                              ]'
   @ nT+03,nL+2  SAY ' Stock Lama   [       ]'
   @ nT+04,nL+2  SAY ' Kurang Stock [       ]'
   @ nT+05,nL+2  SAY ' Stock akhir  [       ]'
   @ nT+07,nL+04 SAY '[SIGN ON] Kembali ke Menu              '
   @ nT+02,nL+17 SAY cDESC     PICT '@!'
   @ nT+03,nL+17 SAY nOQoh     PICT '999,999'
   @ nT+04,nL+17 SAY nRQoh     PICT '999,999'
   @ nT+01,nL+17 GET cCODE     PICT '99999999'
   READ
   SetColor(cO)
   IF LASTKEY()=K_ESC .OR. !RecLock()
      EXIT //RETURN
   ENDIF
   SELECT PRODUK
   Seek cCode
   IF Found()
      cCODE:=CODE
      cDESC:=DESC
      nOQoh:=STOCK
      lS:=.t.
      @ nT+01,nL+17 SAY cCODE     PICT '99999999'
      @ nT+02,nL+17 SAY cDESC     PICT '@!'
      @ nT+03,nL+17 SAY nOQoh     PICT '999,999'
      @ nT+04,nL+17 GET nRQoh     PICT '999,999'
      READ
      nRRQoh=nOQoh-nRQoh
      @ nT+05,nL+17 SAY nRRQoh     PICT '999,999'
   ELSE
      WARNING(' DATA TIDAK ADA.................')
      LOOP
   ENDIF
   IF LASTKEY()=K_ESC .OR. !RecLock()
      EXIT
   ENDIF
   @ nT+07,nL+04 SAY '[1]Simpan  [2]Batal  [3]Kembali ke Menu'
   DO WHILE .T.
      @ nT+06,nL+37 SAY ''
      i:=InKey(0)
      IF UPPER(CHR(i))$'123'
         EXIT
      ENDIF
   ENDDO
   IF UPPER(CHR(i))$'3'
      EXIT
   ELSEIF UPPER(CHR(i))$'2'
      @ nT+06,nL+04 SAY '                                       '
      LOOP
   ELSEIF UPPER(CHR(i))$'1'
      @ nT+06,nL+04 SAY '                                       '
      IF lS
         RecLock()
         FIELD->DESC    :=cDESC
         FIELD->STOCKOLD:=nOQoh
         FIELD->STOCK   :=nRRQoh  // STOK-RETUR
         FIELD->FUPD    :='*'
      ENDIF
      UNLOCK
   ENDIF
   lS:=.f.
 ENDDO
GO TOP
nCekPHead:=1
DO WHILE !EOF()
   IF FUPD='*'
      IF nCekPHead=1
         HEADST2()
         nCekPHead:=2
      ENDIF
      @ PRow()+1 ,00 SAY  CODE+' '+Left(Desc,10) +' '+TRAN(STOCKOLD,'9999') +' '+;
                           TRAN(STOCK-STOCKOLD,'9999')+' '+TRAN(STOCK,'9999')
   ENDIF
   SKIP
ENDDO
IF nCekPHead=2
   @ PRow()+1 ,00 SAY  Replicate('-',40)
   @ PRow()+1 ,00 SAY 'Tanggal  : '+DtoC(Date())+IF(lGTimePr='Y',' Jam '+Time(),'')
   @ PRow()+1 ,00 SAY CHR(13)
ENDIF
FLock()
REPLACE ALL FUPD WITH " "
UNLock
USEFile()
PCutter()
SET DEVICE TO SCREEN
CLOSE ALL
RETURN
*------------------------------------------------------------------------------
STATIC FUNCTION RestTrans(l)
LOCA cFile,cDrv:=Space(30),cPath,cHst
IF l ;cPath:=NDATA
   cHst:='F:\WPI\HST\'
ELSE ;cPath:=DDATA
   cHst:='C:\KASIR\HST\'
ENDIF
@ 24,00 SAY Space(80)
@ 24,00 SAY 'Ketikan Nama File Transfer : '
ColorSelect(1) ;@ 24,Col() SAY 'A:\TRF' ;ColorSelec(0)
@ 24,Col() GET cDrv VALID CekExt(cDrv,cHst)
READ
IF Empty(cDrv) .OR. LastKey()=K_ESC ;RETURN
ENDIF
cFile:='TRF'+AllTrim(cDrv)                    //+'Trans.'+SATELITE->CODE
IF File('A:\'+cFile)
   IF Select('PRODUK')#0
      PRODUK->(DBCloseArea())
   ENDIF
   IF !NetUse({{cPath+'PRODUK.DBF',.t.}})             // .f.
      RETURN
   ENDIF
   IF  !File(cPath+"PRODUK_1.NTX") .OR. !File(cPath+"PRODUK_2.NTX") ;
       .OR. !File(cPath+"PRODUK_3.NTX")
       INDEX ON CODE           TO (cPath+"PRODUK_1.NTX")
       INDEX ON Left(DESC,28)  TO (cPath+"PRODUK_2.NTX")
       INDEX ON REF            TO (cPath+"PRODUK_3.NTX")
   ENDIF
   SET INDEX TO (cPath+"PRODUK_1.NTX"),(cPath+"PRODUK_2.NTX"),(cPath+"PRODUK_3.NTX")
   USE ('A:\'+cFile) NEW ALIAS TO
   DO WHILE !Eof()
      IF PRODUK->(DBSeek(TO->INVCODE))
         PRODUK->(RecLock())
         PRODUK->PRICE:=TO->PRICE        //Baru ditambah 07092000
         PRODUK->STOCK+=TO->QTY
      ELSEIF PRODUK->(AddRec())
         PRODUK->(RecLock())
         PRODUK->CODE    :=INVCODE
         PRODUK->REF     :=ALTCODE
         PRODUK->DESC    :=DESC1
         PRODUK->DEPT    :=DEPNO
         PRODUK->GROUP   :=GRPCODE
         PRODUK->PRICE   :=PRICE
         PRODUK->STOCK   :=QTY
      ENDIF
      PRODUK->(DBCOMMIT())
      PRODUK->(DBUnlock())
      TO->(DBSKip())
   ENDDO
   TO->(DBCloseArea()) ;cTgl:=DToS(Date())
   ? 'A:\',cFile,cHst+cFile ;INKEY(0)
   FileCopy('A:\'+cFile,cHst+cFile)
// RenameFile('C:\KASIR\HST\TRANS.'+SATELITE->CODE,'C:\KASIR\HST\TRAN'+SubS(cTgl,5,2)+SubS(cTgl,7,2)+'.DBF')
   PRODUK->(DBCloseArea())
   cPath:=IF(NNetLogged(),NDATA,DDATA)
   IF !NetUse({{cPath+'PRODUK.DBF',.t.}})             // .f.
      RETURN
   ENDIF
ELSEIF !File(cFile)
   Warning(' File '+Upper(cFile)+' Tidak ada... ')
ENDIF
RETURN


STATIC FUNCTION CekExt(cDrv,cHst)
LOCAL cFile:='TRF'+AllTrim(cDrv)
IF AT('.',cDrv)=0
   Warning(' Harus ada extention kode toko... ')
   RETURN .F.
ELSEIF !File('A:\'+cFile)
   Warning(' File A:\'+Upper(cFile)+' Tidak ada... ')
   RETURN .F.
ELSEIF File(cHst+cFile)
   Warning(' File Transfer tersebut sudah pernah diRestore... ')
   RETURN .F.
ELSEIF Right(cFile,3)#SATELITE->CODE
   Warning(' File Transfer tersebut bukan untuk toko ini... ')
   RETURN .F.
ENDIF
RETURN .T.

*---------------------------------------------------------
FUNCTION IEOD()
LOCAL lEODSA:=SATELITE->EOD
LOCAL c:=SetColor()
SetColor('/gb,w+/gb')
//@ 06,25,08,46 BOX 'ÉÍ»º¼ÍÈº '
Box(06,25,08,46,'w+/gb')
@ 06,27 SAY ' Y->Ya  N->Tidak '
@ 07,27 SAY 'Ijin EOD ->'
@ 07,39 GET lEODSA PICT 'Y'
READ
SATELITE->(RecLock())
SATELITE->EOD:=lEODSA
SATELITE->(DBUNLOCK())
USEFILE()
SetColor(c)
BREAK
RETURN

*---------------------------------------------------------
function WMENUMIX(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11
   Local6:= ""
   Local10:= Len(Arg3)
   Local11:= .F.
   DevPos(Arg1, Arg2)
   DevOut("")
   //DevOut(Space(80-Arg2),'/w')
   Local8:= array(Local10)
   Local9:= array(Local10)
   for Local4:= 1 to Local10
      Local9[Local4]:= 1
      Local8[Local4]:= Col()+1
      Local2:= " " + Arg3[Local4][1] + " "
      Local6:= Local6 + Left(LTrim(Local2), 1)
      DevPos(Arg1, Local8[Local4])
      DevOut(Local2,'w/n')
   next
   Local6:= Upper(Local6)
   Arg4:= iif(Arg4 = Nil, 1, Arg4)
   Local9[Arg4]:= iif(Arg5 = Nil, 1, Arg5)
   Local7:= SaveScreen(Arg1, 0, Arg1, 79)
   if (Arg5 != Nil)
      __Keyboard("")
   endif
   while (.T.)
      Local2:= " " + Arg3[Arg4][1] + " "
      DevPos(Arg1, Local8[Arg4])
      DevOut(Local2, "n/w")
      Scroll(24, 0, 24)
      SetPos(24, 0)
      DevPos(24, 0)
      DevOut(Arg3[Arg4][2],'w/n')
      Local4:= InKey(0)
      DevPos(Arg1, Local8[Arg4])
      DevOut(Local2,'w/n')
      if ((Local5:= SetKey(Local4)) != Nil)
         eval(Local5, alltrim(Local2), procline(), readvar())
         loop
      endif
      Local3:= Upper(Chr(Local4))
      do case
      case Local4 = 24
         DevPos(Arg1, Local8[Arg4])
//       DevOut(Local2, "gr+/g")
         DevOut(Local2, 'n/bg')         //"w/n")
         if (ValType(Arg3[Arg4][3]) != "A")
            loop
         endif
         Arg5:= Local9[Arg4]
         Arg5:= wmenupdn(Arg1 + 1, Local8[Arg4] + 1, Arg3[Arg4][3], ;
            @Arg5, @Local6)
         Local9[Arg4]:= Arg5
         Local11:= .T.
         Local4:= LastKey()
         do case
         case Local4 = 13
            exit
         case Local4 = 4
            __Keyboard("")
         case Local4 = 19
            __Keyboard("")
         case Local4 = 27
            Local11:= .F.
         endcase
      case Local4 = 13
         Local2:= ValType(Arg3[Arg4][3])
         if (Local2 = "A")
            __Keyboard("")
         elseif (Local2 = "B")
            Local3:= SetColor()
            eval(Arg3[Arg4][3], Arg4)
            SetColor(Local3)
         else
            warning("Sub 3 harus Array/Kode Block...!")
            __Quit()
         endif
      case Local4 = 4
         Arg4++
         if (Arg4 > Local10)
            Arg4:= 1
         endif
         if (Local11)
            __Keyboard("")
         endif
      case Local4 = 19
         Arg4--
         if (Arg4 < 1)
            Arg4:= Local10
         endif
         if (Local11)
            __Keyboard("")
         endif
      case Local3 $ Local6 .OR. (Local3:= Chr(altkey(Local4) + 64)) ;
            $ Local6
         Local2:= SubStr(Local6, Arg4 + 1)
         if (!(Local3 $ Local2))
            Arg4:= At(Local3, Local6)
         else
            Arg4:= Arg4 + At(Local3, Local2)
         endif
         __Keyboard(Chr(13))
      case Local4 = 27
         exit
      endcase
   end
   return Arg4 * 100 + Local9[Arg4]

****************************************************************
static function WMENUPDN(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11, Local12, Local13, Local14:= ;
      "", Local15:= 0, Local16:= .F., Local17, Local18, Local19
   Local18:= SetColor()
   Local19:= Len(Arg3)
   dispbegin()
   Local13:= SaveScreen(0, 0, MaxRow(), MaxCol())
   Arg4:= iif(Arg4 = Nil, 1, Arg4)
   Local18:= SubStr(Local18, At("/", Local18))
   for Local6:= 1 to Local19
      Local4:= SubStr(strtran(Arg3[Local6][1], "^", ""), 2)
      if (Arg3[Arg4][1] != "!")
         Arg4:= iif(Arg4 < Local19, Arg4 + 1, 1)
      endif
      if (Local15 < Len(Local4))
         Local15:= Len(Local4)
      endif
      if (Arg3[Local6][1] = "!")
         Local16:= .T.
         DevPos(Arg1 + Local6, Arg2)
         DevOut(Local4,"W" + Local18)   ///////
         if ((Local2:= At("^", Arg3[Local6][1])) > 0)
            Local5:= SubStr(Local4, Local2 - 1, 1)
            DevPos(Arg1 + Local6, Arg2 + Local2 - 2)
//////////  DevOut(Local5, "GR+" + Local18)
            DevOut(Local5, "GR+" + Local18)
            Local14:= Local14 + Local5
         else
            Local14:= Local14 + "ÿ"
         endif
      else
         Local14:= Local14 + "ÿ"
         DevPos(Arg1 + Local6, Arg2)
         DevOut(Local4, "W" + Local18)
      endif
   next
   Local11:= Arg1 + Local6
   Local12:= Arg2 + Local15
   Local10:= Arg2 - 1
   Local9:= Arg1
   Local14:= Upper(Local14)
   DispBox(Local9, Local10, Local11, Local12, 1)        //2)
   dispend()
   while (.T.)
      Local3:= Arg1 + Arg4
      Local4:= Arg3[Arg4][1]
      Local2:= At("^", Local4)
      Local4:= SubStr(strtran(Local4, "^", ""), 2)
      Scroll(24, 0, 24)
      SetPos(24, 0)
      DevPos(24, 0)
      DevOut(Arg3[Arg4][2])
      if (Arg3[Arg4][1] = "!")
         Local8:= "W" + Local18         //////////
//////// Local7:= "GR+" + Local18
         Local7:= "GR+" + Local18
         DevPos(Local3, Arg2)
         DevOut(Local4, "/w")           //1077
      else
         Local8:= "W" + Local18
         Local7:= "W" + Local18
      endif
      Local6:= InKey(0)
      DevPos(Local3, Arg2)
      DevOut(Local4, Local8)
      if (Local2 > 0)
         DevPos(Local3, Arg2 + Local2 - 2)
         DevOut(SubStr(Local4, Local2 - 1, 1), Local7)
      endif
      if ((Local1:= SetKey(Local6)) != Nil)
         eval(Local1, alltrim(Local4), procline(), readvar())
         loop
      endif
      do case
      case Local6 > 256 .AND. Arg5 != Nil
         Local3:= 0
         if ((Local5:= Chr(altkey(Local6) + 64)) $ Arg5)
            while (procname(Local3) = "WMENUPDN")
               Local5:= "" + Local5
               Local3++
            end
            __Keyboard(Local5)
         endif
      case ascan({27, 4, 19}, Local6) != 0
         exit
      case !Local16
         if (Local6 == 5)
            exit
         else
            loop
         endif
      case Local6 = 5
         Arg4--
         if (Arg4 < 1)
            Arg4:= Local19
         endif
         if (Arg3[Arg4][1] != "!")
            __Keyboard("")
         endif
      case Local6 = 24
         Arg4++
         if (Arg4 > Local19)
            Arg4:= 1
         endif
         if (Arg3[Arg4][1] != "!")
            __Keyboard("")
         endif
      case (Local5:= Upper(Chr(Local6))) $ Local14
         Local3:= Arg4
         Local4:= SubStr(Local14, Arg4 + 1)
         if (Local5 $ Local4)
            Arg4:= Arg4 + At(Local5, Local4)
         else
            Arg4:= At(Local5, Local14)
         endif
         if (Arg3[Arg4][1] != "!")
            Arg4:= Local3
         else
            __Keyboard(Chr(13))
            loop
         endif
      case Local6 = 13
         DevPos(Local3, Arg2)
         DevOut(Local4, "/W")           //1143
         Local8:= SaveScreen(Local9, Local10, Local11, Local12)
         Local5:= ValType(Arg3[Arg4][3])
         DispBox(Local9, Local10, Local11, Local12, 1)
         if (Local5 = "A")
            Local17:= Arg3[Arg4][3]
            if (At(Chr(16), Local4) != 0)
               Local3--
               Local6:= Local12 + 1
            elseif (At(Chr(17), Local4) != 0)
               Local6:= 0
               for Local2:= 1 to Len(Local17)
                  Local5:= SubStr(strtran(Local17[Local2][1], "^", ;
                     ""), 2)
                  if (Local6 < Len(Local5))
                     Local6:= Len(Local5)
                  endif
               next
               Local3--
               Local6:= Local10 - Local6
            else
               Local6:= Local10 + 1
               Local3++
            endif
            if (Len(Arg3[Arg4]) < 4)
               AAdd(Arg3[Arg4], 1)
            endif
            Arg3[Arg4][4]:= wmenupdn(Local3, Local6, Local17, ;
               Arg3[Arg4][4], @Arg5)
         elseif (Local5 = "B")
            Local4:= SetColor()
            eval(Arg3[Arg4][3], Arg4)
            SetColor(Local4)
         else
            warning("Sub 3 harus Array/Kode Block...!")
            __Quit()
         endif
         RestScreen(0, 0, MaxRow(), MaxCol(), Local13)
         RestScreen(Local9, Local10, Local11, Local12, Local8)
      endcase
   end
   RestScreen(0, 0, MaxRow(), MaxCol(), Local13)
   return Arg4

********************************
FUNCTION NDispBox(nR1,nC1,nR2,nC2,nD,cC)
//LOCAL nD:=2
nD:=IF(nD=NIL,1,nD)
cC:=IF(cC=NIL,SetColor(),cC)
//SetColor(cC)
//Box(nR1,nC1,nR2,nC2,SetColor())
/*
IF nD=1 ;@ nR1,nC1 TO nR2,nC2
ELSE  ;@ nR1,nC1 TO nR2,nC2 DOUBLE
ENDIF
*/
RETURN

