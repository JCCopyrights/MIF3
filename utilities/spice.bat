REM This .bat will take one file and run it in LTSpice
cd C:\Program Files\LTC\LTspiceXVII
XVIIx64.exe -Run -b %1
REM This is legacy shit to access LTSpice when cmd didnt recognize spaces