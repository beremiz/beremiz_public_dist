
SetCompressor /SOLID /FINAL lzma
;SetCompress off
SetDatablockOptimize off

!include MUI2.nsh
;!include LogicLib.nsh
!include x64.nsh


; MUI Settings
!define MUI_ICON "installer\beremiz\images\brz.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\nsis.bmp" ; optional
!define MUI_ABORTWARNING

; Documentation
!insertmacro MUI_PAGE_WELCOME
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "installer/license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Name "Beremiz $BVERSION"
OutFile "Beremiz-nsis-installer.exe"
InstallDir "$PROGRAMFILES64\Beremiz"
!define PYTHONW_EXE "$INSTDIR\$MSYS_DIR\$MSYS_ENV_DIR\bin\pythonw.exe"
!define BEREMIZ_EXE '"$INSTDIR\beremiz\Beremiz.py" -e "$INSTDIR\winpaths.py"'

Section "Beremiz" 
  SetOutPath $INSTDIR
  ${If} ${IsNativeAMD64}
    File /r /x debian /x *.pyc "installer/*"
  ${Else}
    Abort "Unsupported CPU architecture!"
  ${EndIf}
SectionEnd

Section "Install"
  SetRegView 64
  ;Store installation folder
  WriteRegStr HKCU "Software\Beremiz" "" $INSTDIR
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Beremiz" "Contact" "contact@beremiz.fr"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Beremiz" "DisplayName" "Beremiz"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Beremiz" "Publisher" "Beremiz"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Beremiz" "URLInfoAbout" "http://www.beremiz.org"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Beremiz" "UninstallString" "$INSTDIR\uninstall.exe"
SectionEnd

Section "Shortcuts"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\Beremiz"
  SetOutPath "%HOMEDRIVE%%HOMEPATH%"
; CreateShortCut "$SMPROGRAMS\Beremiz\PlcopenEditor.lnk" "${PYTHONW_EXE}" '"$INSTDIR\beremiz\plcopeneditor.py"' "$INSTDIR\beremiz\images\poe.ico"
  CreateShortCut "$SMPROGRAMS\Beremiz\Beremiz.lnk" "${PYTHONW_EXE}" '${BEREMIZ_EXE}' "$INSTDIR\beremiz\images\brz.ico"
  CreateShortCut "$SMPROGRAMS\Beremiz\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
  SetRegView 64
  SetShellVarContext all
  Delete "$INSTDIR\Uninstall.exe"
;  Delete "$SMPROGRAMS\Beremiz\PlcopenEditor.lnk"
  Delete "$SMPROGRAMS\Beremiz\Beremiz.lnk"
  RMDir /R "$SMPROGRAMS\Beremiz"
  RMDir /R "$INSTDIR"
  DeleteRegKey /ifempty HKCU "Software\Beremiz"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Beremiz"
  SetShellVarContext current
  Delete "$DESKTOP\Beremiz.lnk"
SectionEnd
