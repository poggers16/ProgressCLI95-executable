;--------------------------------
; Includes

  !include "MUI2.nsh"
  !include "logiclib.nsh"

;--------------------------------
; Custom defines
  !define NAME "ProgressCLI95"
  !define APPFILE "ProgressCLI95.exe"
  !define VERSION "0.2.2a"
  !define SLUG "${NAME} v${VERSION}"

;--------------------------------
; General

  Name "${NAME}"
  OutFile "${SLUG} Setup.exe"
  InstallDir "$PROGRAMFILES\${NAME}"
  InstallDirRegKey HKCU "Software\${NAME}" ""
  RequestExecutionLevel admin

;--------------------------------
; UI
  
  !define MUI_ICON "assets\pbcli95.ico"
  !define MUI_HEADERIMAGE
  !define MUI_WELCOMEFINISHPAGE_BITMAP "assets\banner.bmp"
  !define MUI_HEADERIMAGE_BITMAP "assets\head.bmp"
  !define MUI_ABORTWARNING
  !define MUI_WELCOMEPAGE_TITLE "${NAME} Setup"

;--------------------------------
; Pages
  
  ; Installer pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  ; Uninstaller pages
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
  ; Set UI language
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Section - Install App

  Section "-hidden app"
    SectionIn RO
    SetOutPath "$INSTDIR"
    File /r "app\*.*" 
    WriteRegStr HKCU "Software\${NAME}" "" $INSTDIR
    WriteUninstaller "$INSTDIR\Uninstall.exe"
  SectionEnd

;--------------------------------
; Section - Shortcut

  Section "Desktop Shortcut" DeskShort
    CreateShortCut "$DESKTOP\${NAME}.lnk" "$INSTDIR\${APPFILE}"
  SectionEnd

;--------------------------------
; Descriptions

  ;Language strings
  LangString DESC_DeskShort ${LANG_ENGLISH} "Create Desktop shortcuts for ProgressCLI95."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${DeskShort} $(DESC_DeskShort)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Remove empty parent directories

  Function un.RMDirUP
    !define RMDirUP '!insertmacro RMDirUPCall'

    !macro RMDirUPCall _PATH
          push '${_PATH}'
          Call un.RMDirUP
    !macroend

    ; $0 - current folder
    ClearErrors

    Exch $0
    ;DetailPrint "ASDF - $0\.."
    RMDir "$0\.."

    IfErrors Skip
    ${RMDirUP} "$0\.."
    Skip:

    Pop $0

  FunctionEnd

;--------------------------------
; Section - Uninstaller

Section "Uninstall"

  ;Delete Shortcut
  Delete "$DESKTOP\${NAME}.lnk"

  ;Delete Folder
  RMDir /r "$INSTDIR"
  ${RMDirUP} "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\${NAME}"

  ;Delete Uninstall
  Delete "$INSTDIR\Uninstall.exe"

SectionEnd
