;--------------------------------

Name "Guidua"
OutFile "setup_guidua_0.16.exe"

; The default installation directory
InstallDir "$PROGRAMFILES\Guidua 0.16"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM SOFTWARE\Guidua "Install_Dir"

; The text to prompt the user to enter a directory
DirText "Choose a directory to install in to:"

; The stuff to install
Section "Guidua (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "d:\stuff\oidua interface\guidua.exe"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\Guidua "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Guidua" "DisplayName" "Guidua (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Guidua" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Guidua 0.16"
  CreateShortCut "$SMPROGRAMS\Guidua 0.16\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\Guidua 0.16\Guidua.lnk" "$INSTDIR\guidua.exe" "" "$INSTDIR\guidua.exe" 0

SectionEnd

;--------------------------------

; register shit
Section "Register"
  SetOutPath "$INSTDIR\settings"
  File "d:\stuff\oidua interface\guidua.ini"

  SetOutPath "$INSTDIR\lib"
  File "d:\stuff\oidua interface\DXAnimatedGIF.ocx" 
  File "d:\stuff\oidua interface\gears.gif"

  SetOutPath $SYSDIR
  File "c:\windows\system32\tabctl32.ocx"
  file "c:\windows\system32\comdlg32.ocx"  
  RegDLL "$INSTDIR\lib\DXAnimatedGIF.ocx"
  RegDLL "$SYSDIR\tabctl32.ocx"
  RegDLL "$SYSDIR\comdlg32.ocx"

; Uninstaller
SectionEnd
UninstallText "This will uninstall Guidua. Hit next to continue."

; Uninstall section

Section "Uninstall"
  
  ; remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Example2"
  DeleteRegKey HKLM SOFTWARE\NSIS_Example2

  ; remove files and uninstaller
  Delete $INSTDIR\makensisw.exe
  Delete $INSTDIR\uninstall.exe

  ; remove shortcuts, if any
  Delete "$SMPROGRAMS\Guidua 0.16\*.*"
  Delete "$INSTDIR\*.*"

  ; remove directories used
  RMDir "$SMPROGRAMS\Guidua 0.16"
  RMDir "$INSTDIR"
SectionEnd