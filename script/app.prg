function main
local nChoice,aitems
local layar
set color to "w+/b"
CLS
SET MESSAGE TO MaxRow() / 2 CENTER
SET WRAP ON
@ 0, 0  PROMPT "File"
@ 0, 10 PROMPT "Pembelian"
@ 0, 20 PROMPT "Transfer"
@ 0, 30 PROMPT "Laporan"
@ 0, 40 PROMPT "Retur"
@ 0, 50 PROMPT "Utility"
@ 0, 60 PROMPT "Keluar"
do while .t.
MENU TO nChoice
SWITCH nChoice
    case 1

aItems := { "Master Barang", "Penggerakan Stock", "Kartu Stock","Posting Penjualan","Penyesuaian stock","Supplier","Departement","group","Unit Stock","Promosi","Custumer" }
save screen to layar
nChoice := AChoice( 1, 1, 20, 20, aItems )
rest screen from layar
    case 2
        save screen to layar
aItems := { "Order Pembelian", "Automatis PO Entry" }
rest screen from layar
nChoice := AChoice( 1, 10, 20, 20, aItems )
    END
enddo
** SetPos( MaxRow() / 2, MaxCol() / 2 - 10 )
return nil