
SetCompressor /FINAL lzma
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
  CreateShortCut "$SMPROGRAMS\Beremiz\PlcopenEditor.lnk" "$INSTDIR\plcopen_editor.cmd" "" "$INSTDIR\beremiz\images\poe.ico" "" SW_SHOWMINIMIZED
  CreateShortCut "$SMPROGRAMS\Beremiz\Beremiz.lnk" "$INSTDIR\beremiz_ide.cmd" "" "$INSTDIR\beremiz\images\brz.ico" "" SW_SHOWMINIMIZED
  CreateShortCut "$SMPROGRAMS\Beremiz\Beremiz.lnk" "$INSTDIR\beremiz_select_sdk.cmd" "" "$INSTDIR\beremiz\images\brz.ico" "" SW_SHOWMINIMIZED
  CreateShortCut "$SMPROGRAMS\Beremiz\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
  SetRegView 64
  SetShellVarContext all
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$SMPROGRAMS\Beremiz\PlcopenEditor.lnk"
  Delete "$SMPROGRAMS\Beremiz\Beremiz.lnk"
  RMDir /R "$SMPROGRAMS\Beremiz"
  RMDir /R "$INSTDIR"
  DeleteRegKey /ifempty HKCU "Software\Beremiz"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Beremiz"
  SetShellVarContext current
SectionEnd
