@echo off
setlocal enabledelayedexpansion

REM Pfad zum Ordner, in dem die XML-Dateien gespeichert werden sollen
set "folderPath=%USERPROFILE%\WLANProfiles"

REM Erstellen des Ordners, falls er nicht existiert
if not exist "%folderPath%" mkdir "%folderPath%"

REM Exportieren der WLAN-Profile in den angegebenen Ordner
netsh wlan export profile folder="%folderPath%" key=clear

REM Durchsuchen Sie den angegebenen Ordner nach XML-Dateien
for %%f in ("%folderPath%\*.xml") do (
    REM Initialisieren einer Variable, um den keyMaterial-Wert zu speichern
    set "keyMaterial="

    REM Lesen der Datei zeilenweise
    for /f "tokens=*" %%l in ('type "%%f" ^| findstr /i "<keyMaterial>"') do (
        REM Extrahieren des Wertes zwischen den Tags
        set "line=%%l"
        set "line=!line:*<keyMaterial>=!"
        for /f "delims=<" %%t in ("!line!") do (
            set "keyMaterial=%%t"
        )
    )

    REM Anzeigen des extrahierten keyMaterial-Wertes
    if defined keyMaterial (
        echo keyMaterial in %%~nxf: !keyMaterial!
    )
)

endlocal
pause
