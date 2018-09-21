clipper r1 /m/n
if not errorlevel 1 blinker fi r1 lib nt250 bli inc off
if not errorlevel 1 pklite -a r1.exe upg.exe
if not errorlevel 1 del r1.exe
if not errorlevel 1 ren upg.exe r1.exe
