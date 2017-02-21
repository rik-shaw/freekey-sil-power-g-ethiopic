;========================================================
;   Basic routines for  free SIL keyboards
;   Created 2009 by Johann Schaumberger, SIL 
;   Version 12.Feb.2010
;   E-mail Hans_Schaumberger@sil.org
;========================================================

; This file contains the wrapper for the keyboard
; you should not modify any part of this file

#NoEnv

; Basic variables:

; Special keys, which will break modifiers:
  sInternalKey1  = $Space
  sInternalKey2  = $Up
  sInternalKey3  = $Down
  sInternalKey4  = $Left
  sInternalKey5  = $Right
  sInternalKey6  = $Tab
  sInternalKey7  = $Enter
  sInternalKey8  = $Esc
  sInternalKey9  = $Home
  sInternalKey10 = $End
  sInternalKey11 = $PgUp
  sInternalKey12 = $PgDn
  sInternalKey13 = $+Space
  sInternalCount = 13

  HandleWhitespace := 1
  SequenceMarker   := "_"
  MatrixMarker     := "," 
  ElementMarker    := "|"

; Content of the "About dialog"
  sAbout1 := ""
  sAbout2 := "Free " %sName% " keyboard"
  sAbout3 := "Based on 'Auto Hotkey' script"
  sAbout4 := "Written by Johann Schaumberger (SIL)"
  sAbout5 := ""
  sAbout6 := "Errors and wishes please report to:"
  sAbout7 := "Hans_Schaumberger@sil.org"
  sAbout8 := "Version 2.0"
  sAbout9 := ""

  ; Default settings:
  iUseKeyboard   := 0     ; Is the Language keyboard used? 0= no 1 = yes
  iRecogLanguage := 0     ; Is Language switching on       0= no 1 = yes
  sKeyLangName   := ""    ; Name of language to switch language keyboard on    
  sDeflangName   := ""    ; Name of language to switch language keyboard off
  iKeyID         := -1    ; ID of language keyboard
  iDefID         := -1    ; ID of default language keyboard
  iHotShiftOn    := 0
  iHotALtOn      := 0
  iHotCtrlOn     := 0
  sHotKeyOnL     := ""
  sHotKeyOn      := ""    ; Shortcut key to switch keyboard on
  iHotShiftOff   := 0
  iHotALtOff     := 0
  iHotCtrlOff    := 0
  sHotKeyOffL    := ""
  sHotKeyOff     := ""  ; Shortcut key to switch keyboard off
  iOnlyOff       := -1    ; Does only the default language switch the keyboard off?
  iCompMode      := 0

  
; KEYBOARD DEFINITIONS
; Definitions for keys which should be used, add others if needed

; Basic keys: 
  x := "%"
  sKey      = abcdefghijklmnopqrstuvwxyz1234567890?!<>=-_.#*,|{}[]/\^%x%~@$+&:;'"()

; Keys together with {SHIFT} 
  sShiftKey = abcdefghijklmnopqrstuvwxyz

; Keys together with {ALT} (Needed for non-englisch keyboards!!!)
  sAltKey   = {}[]$@()~
  
; Special keys if wanted:
  sSpecialKey  := "" 
  
; Unique ID for identifying the keyboard, (a random number)
Random, iKeyboardID, 1, 0xfffffff
MSGNum := WM_COMMAND && 0x46c   
MouseNum := WM_COMMAND && 0x201
Debug := 0

InitUnicode()

KeyboardName()

PrepareValues()

sSettingFile = %sName%Keyboard.txt


sIconOn      = %sName%On.ico   ; Don't modify
sIconOff     = %sName%Off.ico  ; Don't modify
 

KeyingDocument = %A_WorkingDir%\%sName%KeyboardMap.pdf

IfNotExist, %sName%KeyboardMap.pdf
{
  FileAppend %sName% Keyboard `n No mapping available , %sName%KeyboardMap.pdf
}  
  
IfNotExist, %sSettingFile%
{
  WriteSettings()
}

CheckIfAutostart()  ; Autostart on 
CreateKeys()
CreateMenuAndDialog()
ReadSettings()


; Create the shortcut keys
if (sHotKeyOnL <> "" && sHotKeyOnL <> "(none)")
  Hotkey, %sHotKeyOnL%, DoHotkeyOn,UseErrorLevel
if (sHotKeyOffL <> "" && sHotKeyOffL <> "(none)" )
  Hotkey, %sHotKeyOffL%, DoHotkeyOff,UseErrorLevel
  
SetWorkingDir, %A_ScriptDir%

SwitchLanguage("Off")
    
SetTimer, Timer, 500 ; Set timer for dedecting language swithes

OnMessage(0x404,"AHK_NotifyTrayIcon") ; Check for left click on tray icon
OnMessage(%MSGNum%,"AHK_LanguageSwitch") ; Check for language changes through mouseclick

AHK_NotifyTrayIcon(wParam, lParam)
{
 global 
 If lParam = 0x201
  ShowTrayPopup()
 return
}

AHK_LanguageSwitch(wParam, lParam, msg)
{
  Global
  if (wParam == 5555) ; switch off other languages
  {
    if (lParam <> iKeyboardID)
      SwitchLanguage("Off")
  }
  else if (wParam == 5545)  ; Compatibility mode on or off?
  {
    iCompMode := lParam 
	if (iCompMode == 1)
      Menu, Menu1, Check, Compatibility mode  
    else
      Menu, Menu1, Uncheck, Compatibility mode
  	
	WriteSettings()
  }  
}


;========================================================
;                            Timer routine
;========================================================
Timer:
  SetFormat, Integer, H
  WinGet, WinID,, A
  ThreadID:=DllCall("GetWindowThreadProcessId", "Int", WinID, "Int", 0)
  InputLocaleID:=DllCall("GetKeyboardLayout", "Int", ThreadID)
  language := InputLocaleID & 0x0000ffff
  
  if (iRecogLanguage = 1)
  {
    if (Language <> lastLanguage)
    {
      if (language = iKeyID)
        SwitchLanguage("On")
	  else if (language = iDefID)
	    SwitchLanguage("Off")
	  else
        if (iOnlyOff = 1)
	      SwitchLanguage("Off") 
	}	  
  } 	 
  LastLanguage := Language  	 
return
  
  
~*LButton::
  LastKey    := ""
  LastOutput := ""
  MatrixKey  := ""
return 
   
SwitchTimer(mode)
{
  global
  if (mode = "1")
  {
    SetTimer, Timer, On
	iRecogLanguage := 1
  }	
  else
  {
    SetTimer, Timer, Off
	iRecogLanguage := 0
  }	
}
 
; ===============================================================================================
; Unicode sending routines:
; ===============================================================================================

; Prepare settings for single character Unicode sending routine
InitUnicode()
{
   Global 
   DllCall("LoadLibrary", "str", "ntoskrnl.exe")
   SendU4 := 4 << 16  ; KEYEVENTF_UNICODE
   SendU6 := 6 << 16  ; KEYEVENTF_KEYUP|KEYEVENTF_UNICODE
   VarSetCapacity( SendUbuf, 56, 0 )
   DllCall("RtlFillMemory", "uint",&SendUbuf,    "uint",1, "uint", 1)
   DllCall("RtlFillMemory", "uint",&SendUbuf+28, "uint",1, "uint", 1)

   VarSetCapacity(UText, 4, 0 )
   VarSetCapacity(AText, 4, 0 )
   
}

; Send a single character  
SendUnicode( p_uchar )     ; 3 DllCalls, needs one prior call to SendUinit()
{
    Global
   if (iCompMode = 0)
   {
     DllCall("ntoskrnl.exe\RtlFillMemoryUlong", "uint",&SendUbuf+6,  "uint",4, "uint", p_uchar | SendU4)
     DllCall("ntoskrnl.exe\RtlFillMemoryUlong", "uint",&SendUbuf+34, "uint",4, "uint", p_uchar | SendU6)
  
     Return DllCall( "SendInput", "uint", 2, "uint", &SendUbuf, "int", 28 )
	}
    else
    {
	NumPut(p_uchar, UText, 0, "UShort")

	DllCall("WideCharToMultiByte"
		, "UInt", 65001  ; CodePage: CP_ACP=0 (current Ansi), CP_UTF7=65000, CP_UTF8=65001
		, "UInt", 0      ; dwFlags
		, "Str",  UText  ; LPCWSTR lpWideCharStr
		, "Int",  -1     ; cchWideChar: size in WCHAR values: Len or -1 (= null terminated)
		, "Str",  AText  ; LPSTR lpMultiByteStr
		, "Int",  4      ; cbMultiByte: Len or 0 (= get required size / allocate!)
		, "UInt", 0      ; LPCSTR lpDefaultChar
		, "UInt", 0)     ; LPBOOL lpUsedDefaultChar
 
 
   Critical   
   Transform Clipboard, %AText%
   ClipWait 1
   SendInput ^v
   Sleep, 50

   Critical, Off

    }
}  
 
; Sends a whole unicode string 
SendUnicodeString( p_text ) 
{
  Global
  if (iCompMode = 0)
  {
    ;msgbox %p_text%
    event_count := ( StrLen(p_text)//4 )*2
    VarSetCapacity( events, 28*event_count, 0 )
    base = 0
    Loop % event_count//2 ;%
    {
      StringMid code, p_text, 4*A_Index-3, 4
      code = 0x4%code%

      DllCall("RtlFillMemory", "uint", &events + base, "uint",1, "uint", 1)
      DllCall("ntoskrnl.exe\RtlFillMemoryUlong", "uint",&events+base+6, "uint",4, "uint",code)
      base += 28

      DllCall("RtlFillMemory", "uint", &events + base, "uint",1, "uint", 1)
      DllCall("ntoskrnl.exe\RtlFillMemoryUlong", "uint",&events+base+6, "uint",4, "uint",code|(2<<16))
      base += 28
    }
    result := DllCall( "SendInput", "uint", event_count, "uint", &events, "int", 28 )
  }
  else
  {
  ;msgbox %p_text%
  count := strlen(p_text) //4 
  ;msgbox %count%
  out := ""
  loop %count%
  {
    value := substr(p_text, 4*A_Index -3, 4)
	value = 0x%value%
	;msgbox %value%
	NumPut(value, UText, 0, "UShort")

	DllCall("WideCharToMultiByte"
		, "UInt", 65001  ; CodePage: CP_ACP=0 (current Ansi), CP_UTF7=65000, CP_UTF8=65001
		, "UInt", 0      ; dwFlags
		, "Str",  UText  ; LPCWSTR lpWideCharStr
		, "Int",  -1     ; cchWideChar: size in WCHAR values: Len or -1 (= null terminated)
		, "Str",  AText  ; LPSTR lpMultiByteStr
		, "Int",  4      ; cbMultiByte: Len or 0 (= get required size / allocate!)
		, "UInt", 0      ; LPCSTR lpDefaultChar
		, "UInt", 0)     ; LPBOOL lpUsedDefaultChar
     out = %out%%Atext%
	  ;  msgbox %Atext%
 
   }
   Critical   
   Transform Clipboard, %out%
   ClipWait 1
   SendInput ^v
   Sleep, 50

   Critical, Off  
}
}

;========================================================
;Language routines 
;========================================================

SwitchLanguage(what)
{
  Global 
  if (what = "On")
  {
    TurnKeysOn()
	Menu, tray, icon, %sIconOn%, 1, 0
	;Menu, tray, icon, %sIconOn%
	iUseKeyboard := 0
	PostMessage, %MSGNum%,5555,iKeyboardID,, ahk_id 0xFFFF
  }
  else
  {
    TurnKeysOff()
	Menu, tray, icon, %sIconOff%, 1, 0
	;Menu, tray, icon, %sIconOff%
	iUseKeyboard := 1
  }
}


;========================================================
; Switching keyboards
;========================================================
SwitchKeyboard(which)
{
  Global 
  if (which = "On")
    TurnKeysOn()
  else 
	TurnKeysOff()
}  

;========================================================
; Keyboard on and off shortcut routine
;========================================================

DoHotkeyOn:
  SwitchLanguage("On")
return

DoHotkeyOff:	
  SwitchLanguage("Off")    
  PostMessage, %MSGNum%,5555,iKeyboardID,, ahk_id 0xFFFF
return  

;========================================================
; Creating, switching on and off keys
;========================================================

; -------------------------------------------------------
CreateKeys()
{
  Global
  
  a := 0  ; Single keystrokes
  StringLen, z, sKey
  loop, %z%  
  {
    a := a + 1
    x := SubStr(sKey,a,1)
	x = $%x% ; The $ must be to avoid an endless "receive-send key" loop
    Hotkey, %x%, KeyBasicDown,UseErrorLevel
  }  
 
  a := 0 ; Capital letters
  StringLen, z, sShiftKey
  loop, %z%  
  {
    a := a + 1
	x := SubStr(sShiftKey,a,1)
	x = $+%x%
    Hotkey, %x%, KeyShiftDown,UseErrorLevel 
  }  
 
  a := 0 ; Keystrokes which need {ALT} (on non-english keyboards)
  StringLen,z, sAltKey
  loop, %z%  
  {
    a := a + 1
    x := SubStr(sAltKey,a,1)
	x = <^>%x%
    Hotkey, %x%, KeyAltDown,UseErrorLevel 
  }   
  
  if (sSpecialKey <> "")
  {
    find := "|"
    start := 0
  
    myloopcreate1:
    StringGetPos, start, sSpecialKey, %find%,, start
    ende  := start + 1
    StringGetPos, ende, sSpecialKey, %find%,, ende
    if (ende <> -1)
    {
      length := ende - start  
      t := Substr(sSpecialKey, start + 2, length - 1)
      Hotkey, %t%, KeyBasicDown,UseErrorLevel
      start := start + 1
      goto myloopcreate1
    }
  }	

  if (HandleWhitespace <> 0)
  {
     loop %sInternalcount%
    {
	  hk := sInternalKey%A_Index%
      Hotkey %hk% , KeySpecialDown,UseErrorLevel
    }
  }	

}


; -------------------------------------------------------
TurnKeysOn()
{
  Global
  a := 0  ; Single keystrokes
  StringLen, z, sKey
  loop, %z%  
  {
    a := a + 1
    x := SubStr(sKey,a,1)
	x = $%x%
    Hotkey, %x%, on,UseErrorLevel
  }  

  a := 0 ; Capital letters
  StringLen, z, sShiftKey
  loop, %z%  
  {
    a := a + 1
    x := SubStr(sShiftKey,a,1)
	x = $+%x%
    Hotkey, %x%, on,UseErrorLevel 
  }  
 
  a := 0 ; Keystrokes which need {ALT}
  StringLen,z, sAltKey
  loop, %z%  
  {
    a := a + 1
    x := SubStr(sAltKey,a,1)
	x = <^>%x%
    Hotkey, %x%, on,UseErrorLevel 
  }   
  
  find := "|"
  start := 0
  
  if (sSpecialKey <> "")
  {
    myloopon1:
    StringGetPos, start, sSpecialKey, %find%,, start
    ende  := start + 1
    StringGetPos, ende, sSpecialKey, %find%,, ende
    if (ende <> -1)
    {
      length := ende - start  
      t := Substr(sSpecialKey, start + 2, length - 1)
      Hotkey, $%t%, on
      start := start + 1
      goto myloopon1
    }
  }
  
  if (HandleWhitespace <> 0)
  {
	Hotkey $Space, on
    Hotkey $Up, on
    Hotkey $Down, on
    Hotkey $Left, on
    Hotkey $Right, on
    Hotkey $Tab, on
    Hotkey $Enter, on
    Hotkey $Esc, on
    Hotkey $Home, on
    Hotkey $End, on
    Hotkey $PgUp, on
    Hotkey $PgDn, on
  }	  
}

; -------------------------------------------------------
TurnKeysOff()
{
  Global
  a := 0
  StringLen,z, sKey
  loop, %z%
  {
    a := a + 1
    x := SubStr(sKey,a,1)
	x = $%x%
    Hotkey, %x%, off,UseErrorLevel 
  }  
 
  a := 0
  StringLen, z, sShiftKey
  loop, %z%  
  {
    a := a + 1
    x := SubStr(sShiftKey,a,1)
	x = $+%x%
    Hotkey, %x%, off,UseErrorLevel 
  }  
  
  a := 0
  StringLen, z, sAltKey
  loop, %z%  
  {
    a := a + 1
	x := SubStr(sAltKey,a,1)
    x = <^>%x%
    Hotkey, %x%, off,UseErrorLevel
  }  
  
  find := "|"
  start := 0

  if (sSpecialKey <> "")
  {
    myloopoff1:
    StringGetPos, start, sSpecialKey, %find%,, start
    ende  := start + 1
    StringGetPos, ende, sSpecialKey, %find%,, ende
    if (ende <> -1)
    {
      length := ende - start  
      t := Substr(sSpecialKey, start + 2, length - 1)
      Hotkey, $%t%, off,UseErrorLevel
      start := start + 1
      goto myloopoff1
	}  
  }     

  if (HandleWhitespace <> 0)
  {
	Hotkey $Space, off
    Hotkey $Up, off
    Hotkey $Down, off
    Hotkey $Left, off
    Hotkey $Right, off
    Hotkey $Tab, off
    Hotkey $Enter, off
    Hotkey $Esc, off
    Hotkey $Home, off
    Hotkey $End, off
    Hotkey $PgUp, off
    Hotkey $PgDn, off
  }	
  }

KeyBasicDown:
  LastKey    := A_ThisHotkey
  KeyFired   := False
  KeyDown(A_ThisHotkey)
  DefaultKey()
return

KeyShiftDown:
  StringRight, t, A_ThisHotkey, 1
  StringUpper, t, t
  what = $%t% 
  LastKey    := what
  KeyFired   := False  
  KeyDown(what)
  DefaultKey()
return

KeyAltDown:
  StringRight, t, A_ThisHotkey, 1
  what = $%t% 
  LastKey    := what
  KeyFired   := False  
  KeyDown(what)
  DefaultKey()
return

KeySpecialDown:
  StringTrimLeft s,A_ThisHotkey,1
  Send {%s%}
  ;msgbox %s%
	
  if (debug == 0)
  {  
    LastKey    := ""
    LastOutput := ""
    MatrixKey  := ""
  }	
  AddOutputSequence(A_ThisHotkey)
return  

; ======================================================================================
;
;   Dialog routines and Tray menu items
;
; ======================================================================================

; Reads the keyboard settings from a textfile, 
; which is in the same folder as the program;
; The Registry is not used since it would give problems
; when running the program from a flashdrive
ReadSettings()
{
  Global
  
  
  FileReadLine,   iUseKeyboard,   %sSettingFile%,  1
  FileReadLine,   iRecogLanguage, %sSettingFile%,  2
  FileReadLine,   sKeyLangName,   %sSettingFile%,  3  
  FileReadLine,   sDefLangName,   %sSettingFile%,  4 
  FileReadLine,   iKeyID,         %sSettingFile%,  5
  FileReadLine,   iDefID,         %sSettingFile%,  6
  FileReadLine,   iHotShiftOn,    %sSettingFile%,  7
  FileReadLine,   iHotAltOn,      %sSettingFile%,  8
  FileReadLine,   iHotCtrlOn,     %sSettingFile%,  9
  FileReadLine,   sHotKeyOn,      %sSettingFile%,  10
  FileReadLine,   iHotShiftOff,   %sSettingFile%,  11
  FileReadLine,   iHotAltOff,     %sSettingFile%,  12
  FileReadLine,   iHotCtrlOff,    %sSettingFile%,  13
  FileReadLine,   sHotKeyOff,     %sSettingFile%,  14
  FileReadLine,   iOnlyOff,       %sSettingFile%,  15
  FileReadLine,   sHotKeyOnL,     %sSettingFile%,  16 
  FileReadLine,   sHotKeyOffL,    %sSettingFile%,  17
  FileReadLine,   iCompMode,      %sSettingFile%,  18
  
  if (sHotkeyOn = "")
    sHotKeyOn := "(none)"
  if (sHotkeyOff = "")
    sHotKeyOff := "(none)"
	
}


; Writes the keyboard settings to a textfile, 
; which is in the same folder as the program;
WriteSettings()
{
  Global
  FileDelete, %sSettingFile%
  FileAppend,
  (
%iUseKeyboard%
%iRecogLanguage% 
%sKeyLangName%     
%sDefLangName%   
%iKeyID%   
%iDefID%  
%iHotShiftOn%   
%iHotALtOn%     
%iHotCtrlOn%    
%sHotKeyOn%
%iHotShiftOff% 
%iHotALtOff%  
%iHotCtrlOff% 
%sHotKeyOff%
%iOnlyOff%
%sHotKeyOnL%
%sHotKeyOffL%
%iCompMode%
	), %sSettingFile%
}

CreateMenuAndDialog()
{
  Global
  
  ; ==============================================================
  ; Create the popup menu for the keyboard selection:
  ; ==============================================================

  Menu, tray, NoStandard                        ; Remove all standard options
  Menu, tray, add, Help ... ,   ShowHelp        ; 
  Menu, tray, add, Options... , OptionHandler   ; Option dialog item
  Menu, tray, add, About...   , AboutHandler    ; About dialog item
  Menu, tray, Add                               ; Creates a separator line.
  Menu, tray, Add, Suspend,     SuspendHandler  ; Add a suspend item
  Menu, tray, Add, Exit,        ExitHandler     ; Add the exit item
  
  
  ; ==============================================================
  ; Create Tray menu items
  ; ==============================================================

  Menu, Menu1, Add, %sName%,     KeyboardOn
  Menu, Menu1, Add, No keyboard, KeyboardOff
  MI_SetMenuItemIcon("Menu1", 1, sIconOn, 1, 16)
  Menu, Menu1, Add 
  Menu, Menu1, Add, Compatibility mode, CompMode       ; Compatibility mode
  Menu, Menu1, Add 
  Menu, Menu1, Add, Show keying document, ShowKeyboardDocument  ; Show the keyboarding document
  
  ; ==============================================================
  ; Option dialog box:
  ; ==============================================================
  shortcut = (none)|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|w|y|z
  
  Gui, Add, Tab2,x10 y10 w250 h350, Basic Settings | Language switches    ; Tab2 vs. Tab requires v1.0.47.05.
  
  Gui, Tab, 1
  Gui, Add, Text  
  Gui, Add, Checkbox, vdStartCheckboxVar     , Start keyboard with Windows  
  Gui, Add, Text
  Gui, Add, Checkbox, vdCompMode     , Compatibility mode  
  Gui, Add, Text
 
  Gui, Add, Text
  Gui, Add, Text,, Hotkey for %sName%
  Gui, Add, Checkbox, x20 y150 w50 h15 vdOnAlt, ALT
  Gui, Add, Checkbox, x90 y150 w50 h15 vdOnControl, CTRL
  Gui, Add, Checkbox, x160 y150 w50 h15 vdOnShift, SHIFT
  Gui, Add, DropDownlist, x20 y180 w150 h100 vdKeyOn, %shortcut%
            , 
  Gui, Add, Text
  Gui, Add, Text,, Hotkey for switching off keyboard
  Gui, Add, Checkbox, x20 y255 w50 h15 vdOffAlt, ALT
  Gui, Add, Checkbox, x90 y255 w50 h15 vdOffControl, CTRL
  Gui, Add, Checkbox, x160 y255 w50 h15 vdOffShift, SHIFT
  Gui, Add, DropDownlist, x20 y285 w150 h100 vdKeyOff, %shortcut%

  Gui, Tab, 2 
  Gui, Add, Text
  Gui, Add, Checkbox, vdRecogLanguage , Switch keyboard with language
  Gui, Add, Text
  Gui, Add, Text,, Select the switch language for %sName%
  Gui, Add, DropDownList, w200 vdKeyLangName      
  Gui, Add, Text
  Gui, Add, Text,, Default language to switch off keyboards
  Gui, Add, Radio,vdOnlyOff,  All languages switch off
  Gui, Add, Radio,vdOnlyThis, Only this language switches off:
  Gui, Add, DropDownList, w200 vdDefLangName     
 
 
  Gui, Tab  
  Gui, Add, Button, default xm, OK  
 

  ; =============================================================
  ; "About" dialog box
  ; ==============================================================

  Gui 2: Add, Text,, %sAbout1%
  Gui 2: Add, Text,, %sAbout2%
  Gui 2: Add, Text,, %sAbout3%
  Gui 2: Add, Text,, %sAbout4%
  Gui 2: Add, Text,, %sAbout5%
  Gui 2: Add, Text,, %sAbout6%
  Gui 2: Add, Text,, %sAbout7%
  Gui 2: Add, Text,, %sAbout8%
  Gui 2: Add, Text,, %sAbout9%
} 


ReadInstalledLanguages()
{
  Global
	
  GUIControl,,dKeyLangName, |  ; Clear content of Language listboxes
  GUIControl,,dDefLangName, |
	
  loop HKEY_CURRENT_USER, Keyboard Layout\Preload,0,0
     {
       RegRead Locale
	   StringRight, loc, locale, 3
       locale := "0x" locale
		   
       VarSetCapacity(name, 128, 32)	

       Lang := DllCall("GetLocaleInfoW"
               ,Uint,  Locale
		       ,Uint,  2 ; &H2 = 'localized name of language
		       ,Str,  name 
		       ,UInt,  128)
		
		;msgbox locale name:  %name%
	if (strlen(name) < 120)
	{
      GUIControl,,dKeyLangName,  %loc%    %name%
      GUIControl,,dDefLangName,  %loc%    %name%
	}  
  }
}

ExitHandler:
  ExitApp
return

SuspendHandler: 
  suspend toggle
return

KeyboardOn:
  SwitchLanguage("On")
return  
  
KeyboardOff:
  SwitchLanguage("Off")
return

CompMode:
  if (iCompMode == 0)
  {
    iCompMode := 1
	Menu, Menu1, Check, Compatibility mode  
  }	
  else
  {
    iCompMode := 0  
	Menu, Menu1, Uncheck, Compatibility mode
  }	
  PostMessage, %MSGNum%,5545,iCompMode,, ahk_id 0xFFFF ; Inform other scripts about the current mode
return
    

ShowKeyboardDocument:
  if (KeyingDocument <> A_WorkingDir)
  {
    ifExist %KeyingDocument% 
	{
      Run, open %KeyingDocument%
	}  
  }	
return


ShowHelp:
  {
    ifExist %A_WorkingDir%\freekey.chm 
	{
      Run, open %A_WorkingDir%\freekey.chm
	}
	else
	  Msgbox Sorry, no helpfile available
   }	
return
	
	
OptionHandler:
  ReadSettings()
  CheckIfAutostart()
  ReadInstalledLanguages()
  
  GuiControl,, dStartCheckboxVar,          %iAutostartOn%
  GuiControl,, dCompMode,                  %iCompMode%            
    
  GuiControl,, dOnAlt,                     %iHotALtOn% 
  GuiControl,, dOnControl,                 %iHotCtrlOn%
  GuiControl,, dOnShift,                   %iHotShiftOn%    
  GuiControl,  ChooseString, dKeyOn,       %sHotKeyOn%
  GuiControl,, dOffAlt,                    %iHotALtOff%
  GuiControl,, dOffControl,                %iHotCtrlOff% 
  GuiControl,, dOffShift,                  %iHotShiftOff% 
  GuiControl,  ChooseString, dKeyOff,      %sHotKeyOff%
  
  GuiControl,, dRecogLanguage,             %iRecogLanguage% 
  GuiControl,  ChooseString, dKeyLangName, %sKeyLangName% 
  GuiControl,  ChooseString, dDefLangName, %sDefLangName%
  if (iOnlyOff = 0)
    GuiControl,, dOnlyThis, 1
  else
    GuiControl,, dOnlyOff, 1

  Gui, Show
return

AboutHandler:
  Gui 2: Show
return

ButtonOK:
GuiClose:
GuiEscape:
  Gui, Submit  ; Save each control's contents to its associated variable.
  SetOptionDialogSettings()
return  


ShowTrayPopup()
{
  Menu, Menu1, Show  
}

  
SetOptionDialogSettings()
{
  Global  
  ; Basic setting:
  SwitchTimer(dRecogLanguage)
  Setautostart(dStartCheckboxVar)
  iOnlyOff := dOnlyOff  
  iCompMode := dCompMode
  PostMessage, %MSGNum%,5545,iCompMode,, ahk_id 0xFFFF ; Inform other scripts about the current mode
  
  if (dKeyLangName <> "")
  if (dKeyLangName <> sKeyLangName)
  {
    StringLeft, iKeyID, dKeyLangName, 3
	iKeyID := "0x"iKeyID
	sKeyLangName := dKeyLangName
  }
 
  if (dDefLangName <> "")  
  if (dDefLangName <> sDefLangName)
  {
    StringLeft iDefID, dDefLangName, 3
	iDefID := "0x"iDefID
    sDefLangName := dDefLangName    
  }
  CreateHotkeys()
  WriteSettings() ;    Save settings to file  
}  

CreateHotkeys()
{
  Global
  ; Destroy old hotkeys first 
  
  if (sHotKeyOnL <> "" && sHotKeyOnL <> "(none)")
    Hotkey, %sHotKeyOnL%, off,UseErrorLevel
  if (sHotKeyOffL <> "" && sHotKeyOffL <> "(none)" )
    Hotkey, %sHotKeyOffL%, off,UseErrorLevel
  
  iHotALtOn     := dOnAlt,          
  iHotCtrlOn    := dOnControl,     
  iHotShiftOn   := dOnShift,           
  sHotKeyOn     := dKeyOn,         
  iHotALtOff    := dOffAlt,        
  iHotCtrlOff   := dOffControl,     
  iHotShiftOff  := dOffShift,       
  sHotKeyOff    := dKeyOff,        
  
  if (dKeyOn <> "(none)")
  { 
    x := ""
    if (dOnAlt = 1)
	  x = !
	if (dOnControl = 1)
	  x = %x%^
	if (dOnShift = 1)
      x = %x%+
	  
    x = %x%%dKeyOn%	
	sHotKeyOnL := x
    Hotkey, %x%, DoHotkeyOn,UseErrorLevel	
	Hotkey, %x%, On
  }
  else
   	sHotKeyOnL := ""
  
  if (dKeyOff <> "(none)")
  {
    x := ""
    if (dOffAlt = 1)
	  x = !
	if (dOffControl = 1)
	  x = %x%^
	if (dOffShift = 1)
      x = %x%+
	  
    x = %x%%dKeyOff%
    sHotKeyOffL := x		
	
    Hotkey, %x%, DoHotkeyOff,UseErrorLevel	
	Hotkey, %x%, On,UseErrorLevel
  }
  else
    sHotKeyOffL := ""
}


SetAutostart(set)
{
  if (set = 1)
    RegWrite,REG_SZ,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Run,%A_ScriptName%,"%A_ScriptDir%\%A_ScriptName%"  	
  else
    RegDelete,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Run,%A_ScriptName% 
  iAutostartOn = %set%	
}

CheckIfAutostart()
{
  Global
   ;Check if autostart is active  
  RegRead, re, HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Run,%A_ScriptName%
  if (re <> "")
    iAutostartOn := 1
  else
    iAutostartOn := 0  
}

; ============================================================================
;
; The following part is included from the Autohotkey forum
; which allows to show bitmaps besides the menu
;
; ============================================================================
;
;
MI_SetMenuItemIcon(MenuNameOrHandle, ItemPos, FilenameOrHICON, IconNumber=1, IconSize=0, ByRef unused1="", ByRef unused2="")
{
    ; Set for compatibility with older scripts:
    unused1=0
    unused2=0
    
    if MenuNameOrHandle is integer
        h_menu := MenuNameOrHandle
    else
        h_menu := MI_GetMenuHandle(MenuNameOrHandle)
    
    if !h_menu
        return false
    
    if FilenameOrHICON is integer
    {
        ; May be 0 to remove icon.
        h_icon := FilenameOrHICON
        ; Copy and potentially resize the icon. Since the caller is probably "caching"
        ; icon handles or assigning them to multiple items, we don't want to delete
        ; it if/when a future call to this function re-sets this item's icon.
        if h_icon
            h_icon := DllCall("CopyImage","uint",h_icon,"uint",1
                                ,"int",IconSize,"int",IconSize,"uint",0)
        ; else caller wants to remove and delete existing icon.
    }
    else
    {
        ; Load icon from file. Remember to clean up this icon if we end up using a bitmap.
        ; Resizing is not necessary in this case since MI_ExtractIcon already does that.
        if !(loaded_icon := h_icon := MI_ExtractIcon(FilenameOrHICON, IconNumber, IconSize))
            return false
    }
    
    ; Windows Vista supports 32-bit alpha-blended bitmaps in menus. Note that
    ; A_OSVersion does not report WIN_VISTA when running in compatibility mode.
    ; To get nice icons on other versions of Windows, we need to owner-draw.
    ; DON'T TOUCH UNLESS YOU KNOW WHAT YOU'RE DOING:
    ;   use_bitmap MUST have the same value for each use on a given menu item.
    use_bitmap := (A_OSVersion="WIN_VISTA")
    
    ; Get the previous bitmap or icon handle.
    VarSetCapacity(mii,48,0), NumPut(48,mii), NumPut(0xA0,mii,4)
    if DllCall("GetMenuItemInfo","uint",h_menu,"uint",ItemPos-1,"uint",1,"uint",&mii)
        h_previous := use_bitmap ? NumGet(mii,44,"int") : NumGet(mii,32,"int")

    if use_bitmap
    {
        if h_icon
        {
            h_bitmap := MI_GetBitmapFromIcon32Bit(h_icon, IconSize, IconSize)
            
            if loaded_icon
            {
                ; The icon we loaded is no longer needed.
                DllCall("DestroyIcon","uint",loaded_icon)
                ; Don't try to destroy the now invalid handle again:
                loaded_icon := 0
            }
            
            if !h_bitmap
                return false
        }
        else
            ; Caller wants to remove and delete existing icon.
            h_bitmap := 0
        
        NumPut(0x80,mii,4) ; fMask: Set hbmpItem only, not dwItemData.
        , NumPut(h_bitmap,mii,44) ; hbmpItem = h_bitmap
    }
    else
    {
        ; Associate the icon with the menu item. Relies on the probable case that no other
        ; script or dll will use dwItemData. If other scripts need to associate data with
        ; an item, MI should be expanded to allow it.
        NumPut(h_icon,mii,32) ; dwItemData = h_icon
        , NumPut(-1,mii,44) ; hbmpItem = HBMMENU_CALLBACK
    }

    if DllCall("SetMenuItemInfo","uint",h_menu,"uint",ItemPos-1,"uint",1,"uint",&mii)
    {   
        ; Only now that we know it's a success, delete the previous icon or bitmap.
        if use_bitmap
        {   ; Exclude NULL and predefined HBMMENU_ values (-1, 1..11).
            if (h_previous < -1 || h_previous > 11)
                DllCall("DeleteObject","uint",h_previous)
        } else
            DllCall("DestroyIcon","uint",h_previous)
        
        return true
    }
    ; ELSE FAIL
    if loaded_icon
        DllCall("DestroyIcon","uint",loaded_icon)
    return false
}
MI_RemoveIcons(MenuNameOrHandle)
{
    if MenuNameOrHandle is integer
        h_menu := MenuNameOrHandle
    else
        h_menu := MI_GetMenuHandle(MenuNameOrHandle)
    
    if !h_menu
        return
    
    Loop % DllCall("GetMenuItemCount","uint",h_menu) ; %
        MI_SetMenuItemIcon(h_menu, A_Index, 0)
}
MI_SetMenuItemBitmap(MenuNameOrHandle, ItemPos, hBitmap)
{
    if MenuNameOrHandle is integer
        h_menu := MenuNameOrHandle
    else
        h_menu := MI_GetMenuHandle(MenuNameOrHandle)
    
    if !h_menu
        return false
    
    VarSetCapacity(mii,48,0), NumPut(48,mii), NumPut(0x80,mii,4), NumPut(hBitmap,mii,44)
    return DllCall("SetMenuItemInfo","uint",h_menu,"uint",ItemPos-1,"uint",1,"uint",&mii)
}

MI_GetMenuHandle(menu_name)
{
    static   h_menuDummy
    ; v2.2: Check for !h_menuDummy instead of h_menuDummy="" in case init failed last time.
    If !h_menuDummy
    {
        Menu, menuDummy, Add
        Menu, menuDummy, DeleteAll

        Gui, 99:Menu, menuDummy
        ; v2.2: Use LastFound method instead of window title. [Thanks animeaime.]
        Gui, 99:+LastFound

        h_menuDummy := DllCall("GetMenu", "uint", WinExist())

        Gui, 99:Menu
        Gui, 99:Destroy
        
        ; v2.2: Return only after cleaning up. [Thanks animeaime.]
        if !h_menuDummy
            return 0
    }

    Menu, menuDummy, Add, :%menu_name%
    h_menu := DllCall( "GetSubMenu", "uint", h_menuDummy, "int", 0 )
    DllCall( "RemoveMenu", "uint", h_menuDummy, "uint", 0, "uint", 0x846c )
    Menu, menuDummy, Delete, :%menu_name%
    
    return h_menu
}
MI_SetMenuStyle(MenuNameOrHandle, style)
{
    if MenuNameOrHandle is integer
        h_menu := MenuNameOrHandle
    else
        h_menu := MI_GetMenuHandle(MenuNameOrHandle)
    
    if !h_menu
        return
        
    VarSetCapacity(mi,28,0), NumPut(28,mi)
    NumPut(0x10,mi,4) ; fMask=MIM_STYLE
    NumPut(style,mi,8)
    DllCall("SetMenuInfo","uint",h_menu,"uint",&mi)
}
MI_ExtractIcon(Filename, IconNumber, IconSize)
{
    ; LoadImage is not used..
    ; ..with exe/dll files because:
    ;   it only works with modules loaded by the current process,
    ;   it needs the resource ordinal (which is not the same as an icon index), and
    ; ..with ico files because:
    ;   it can only load the first icon (of size %IconSize%) from an .ico file.
    
    ; If possible, use PrivateExtractIcons, which supports any size of icon.
    if A_OSVersion in WIN_VISTA,WIN_2003,WIN_XP,WIN_2000
    {
        r:=DllCall("PrivateExtractIcons"
            ,"str",Filename,"int",IconNumber-1,"int",IconSize,"int",IconSize
            ,"uint*",h_icon,"uint*",0,"uint",1,"uint",0,"int")
;         StdOut("icon: " h_icon ", size: " IconSize ", num: " IconNumber ", file: " Filename)
        if !ErrorLevel
        {
            if !h_icon || r>1
            {
                Clipboard:=Filename
                ListVars
                Pause
            }
            return h_icon
        }
    }
    ; Use ExtractIconEx, which only returns 16x16 or 32x32 icons.
    if DllCall("shell32.dll\ExtractIconExA","str",Filename,"int",IconNumber-1
                ,"uint*",h_icon,"uint*",h_icon_small,"uint",1)
    {
        SysGet, SmallIconSize, 49
        
        ; Use the best-fit size; delete the other. Defaults to small icon.
        if (IconSize <= SmallIconSize) {
            DllCall("DestroyIcon","uint",h_icon)
            h_icon := h_icon_small
        } else
            DllCall("DestroyIcon","uint",h_icon_small)
        
        ; I think PrivateExtractIcons resizes icons automatically,
        ; so resize icons returned by ExtractIconEx for consistency.
        if (h_icon && IconSize)
            h_icon := DllCall("CopyImage","uint",h_icon,"uint",1,"int",IconSize
                                ,"int",IconSize,"uint",4|8)
    }

    return h_icon ? h_icon : 0
}

MI_EnableOwnerDrawnMenus(hwnd="")
{

;
; Owner-Drawn Menu Functions
;

; Sub-classes a window from THIS process to owner-draw menu icons.
; This allows the menu to be shown by means other than MI_ShowMenu().
    if (hwnd="") {  ; Use the script's main window if hwnd was omitted.
        dhw := A_DetectHiddenWindows
        DetectHiddenWindows, On
        Process, Exist
        hwnd := WinExist("ahk_class AutoHotkey ahk_pid " ErrorLevel)
        DetectHiddenWindows, %dhw%
    }
    if !hwnd
        return
    wndProc := RegisterCallback("MI_OwnerDrawnMenuItemWndProc","",4
        ,DllCall("GetWindowLong","uint",hwnd,"uint",-4))
    return DllCall("SetWindowLong","uint",hwnd,"int",-4,"int",wndProc,"uint")
}


MI_ShowMenu(MenuNameOrHandle, x="", y="")
{
; Shows a menu, allowing owner-drawn icons to be drawn.
    static hInstance, hwnd, ClassName := "OwnerDrawnMenuMsgWin"

    if MenuNameOrHandle is integer
        h_menu := MenuNameOrHandle
    else
        h_menu := MI_GetMenuHandle(MenuNameOrHandle)
    
    if !h_menu
        return false
    
    if !hwnd
    {   ; Create a message window to receive owner-draw messages from the menu.
        ; Only one window is created per instance of the script.
    
        if !hInstance
            hInstance := DllCall("GetModuleHandle", "UInt", 0)

        ; Register a window class to associate OwnerDrawnMenuItemWndProc()
        ; with the window we will create.
        wndProc := RegisterCallback("MI_OwnerDrawnMenuItemWndProc","",4,0)
        if !wndProc {
            ErrorLevel = RegisterCallback
            return false
        }
    
        ; Create a new window class.
        VarSetCapacity(wc, 40, 0)   ; WNDCLASS wc
        NumPut(wndProc,   wc, 4)   ; lpfnWndProc
        NumPut(hInstance, wc,16)   ; hInstance
        NumPut(&ClassName,wc,36)   ; lpszClassname

        ; Register the class.        
        if !DllCall("RegisterClass","uint",&wc)
        {   ; failed, free the callback.
            DllCall("GlobalFree","uint",wndProc)
            ErrorLevel = RegisterClass
            return false
        }
        
        ;
        ; Create the message window.
        ;
        if A_OSVersion in WIN_XP,WIN_VISTA
            hwndParent = -3 ; HWND_MESSAGE (message-only window)
        else
            hwndParent = 0  ; un-owned
        
        hwnd := DllCall("CreateWindowExA","uint",0,"str",ClassName,"str",ClassName
                        ,"uint",0,"int",0,"int",0,"int",0,"int",0,"uint",hwndParent
                        ,"uint",0,"uint",hInstance,"uint",0)
        if !hwnd {
            ErrorLevel = CreateWindowEx
            return false
        }
    }

    prev_hwnd := DllCall("GetForegroundWindow")

    ; Required for the menu to initially have focus.
    ;DllCall("SetForegroundWindow","uint",hwnd)
    dhw := A_DetectHiddenWindows
    DetectHiddenWindows, On
    WinActivate, ahk_id %hwnd%
    DetectHiddenWindows, %dhw%
    
    if (x="" or y="") {
        CoordMode, Mouse, Screen
        MouseGetPos, x, y
    }

    ; returns non-zero on success.
    ret := DllCall("TrackPopupMenu","uint",h_menu,"uint",0,"int",x,"int",y
                    ,"int",0,"uint",hwnd,"uint",0)
    
    if WinExist("ahk_id " prev_hwnd)
        DllCall("SetForegroundWindow","uint",prev_hwnd)
    
    ; Required to let AutoHotkey process WM_COMMAND messages we may have
    ; sent as a result of clicking a menu item. (Without this, the item-click
    ; won't register if there is an 'ExitApp' after ShowOwnerDrawnMenu returns.)
    Sleep, 1
    
    return ret
}

MI_OwnerDrawnMenuItemWndProc(hwnd, Msg, wParam, lParam)
{
    static WM_DRAWITEM = 0x002B, WM_MEASUREITEM = 0x002C, WM_COMMAND = 0x846c
    static ScriptHwnd
    Critical 500

    if (Msg = WM_MEASUREITEM && wParam = 0)
    {   ; MSDN: wParam - If the value is zero, the message was sent by a menu.
        h_icon := NumGet(lParam+20)
        if !h_icon
            return false
        
        ; Measure icon and put results into lParam.
        VarSetCapacity(buf,24)
        if DllCall("GetIconInfo","uint",h_icon,"uint",&buf)
        {
            hbmColor := NumGet(buf,16)
            hbmMask  := NumGet(buf,12)
            x := DllCall("GetObject","uint",hbmColor,"int",24,"uint",&buf)
            DllCall("DeleteObject","uint",hbmColor)
            DllCall("DeleteObject","uint",hbmMask)
            if !x
                return false
            NumPut(NumGet(buf,4,"int")+2, lParam+12) ; width
            NumPut(NumGet(buf,8,"int")  , lParam+16) ; height
            return true
        }
        return false
    }
    else if (Msg = WM_DRAWITEM && wParam = 0)
    {
        hdcDest := NumGet(lParam+24)
        x       := NumGet(lParam+28)
        y       := NumGet(lParam+32)
        h_icon  := NumGet(lParam+44)
        if !(h_icon && hdcDest)
            return false

        return DllCall("DrawIconEx","uint",hdcDest,"int",x,"int",y,"uint",h_icon
                        ,"uint",0,"uint",0,"uint",0,"uint",0,"uint",3)
    }
    else if (Msg = WM_COMMAND && !(wParam>>16)) ; (clicked a menu item)
    {
        DetectHiddenWindows, On
        if !ScriptHwnd {
            Process, Exist
            ScriptHwnd := WinExist("ahk_class AutoHotkey ahk_pid " ErrorLevel)
        }
        if (hwnd != ScriptHwnd) {
            ; Forward this message to the AutoHotkey main window.
            PostMessage, Msg, wParam, lParam,, ahk_id %ScriptHwnd%
            return ErrorLevel
        }
    }
    if A_EventInfo  ; Let the "super-class" window procedure handle all other messages.
        return DllCall("CallWindowProc","uint",A_EventInfo,"uint",hwnd,"uint",Msg,"uint",wParam,"uint",lParam)
    else            ; Let the default window procedure handle all other messages.
        return DllCall("DefWindowProc","uint",hwnd,"uint",Msg,"uint",wParam,"uint",lParam)
}
MI_GetBitmapFromIcon32Bit(h_icon, width=0, height=0)
{

;
; Windows Vista Menu Icons
;

; Note: 32-bit alpha-blended menu item bitmaps are supported only on Windows Vista.
; Article on menu icons in Vista:
; http://shellrevealed.com/blogs/shellblog/archive/2007/02/06/Vista-Style-Menus_2C00_-Part-1-_2D00_-Adding-icons-to-standard-menus.aspx

    VarSetCapacity(buf,40) ; used as ICONINFO (20), BITMAP (24), BITMAPINFO (40)
    if DllCall("GetIconInfo","uint",h_icon,"uint",&buf) {
        hbmColor := NumGet(buf,16)  ; used to measure the icon
        hbmMask  := NumGet(buf,12)  ; used to generate alpha data (if necessary)
    }

    if !(width && height) {
        if !hbmColor or !DllCall("GetObject","uint",hbmColor,"int",24,"uint",&buf)
            return 0
        width := NumGet(buf,4,"int"),  height := NumGet(buf,8,"int")
    }

    ; Create a device context compatible with the screen.        
    if (hdcDest := DllCall("CreateCompatibleDC","uint",0))
    {
        ; Create a 32-bit bitmap to draw the icon onto.
        VarSetCapacity(buf,40,0), NumPut(40,buf), NumPut(1,buf,12,"ushort")
        NumPut(width,buf,4), NumPut(height,buf,8), NumPut(32,buf,14,"ushort")
        
        if (bm := DllCall("CreateDIBSection","uint",hdcDest,"uint",&buf,"uint",0
                            ,"uint*",pBits,"uint",0,"uint",0))
        {
            ; SelectObject -- use hdcDest to draw onto bm
            if (bmOld := DllCall("SelectObject","uint",hdcDest,"uint",bm))
            {
                ; Draw the icon onto the 32-bit bitmap.
                DllCall("DrawIconEx","uint",hdcDest,"int",0,"int",0,"uint",h_icon
                        ,"uint",width,"uint",height,"uint",0,"uint",0,"uint",3)

                DllCall("SelectObject","uint",hdcDest,"uint",bmOld)
            }
        
            ; Check for alpha data.
            has_alpha_data := false
            Loop, % height*width ; %
                if NumGet(pBits+0,(A_Index-1)*4) & 0xFF000000 {
                    has_alpha_data := true
                    break
                }
            if !has_alpha_data
            {
                ; Ensure the mask is the right size.
                hbmMask := DllCall("CopyImage","uint",hbmMask,"uint",0
                                    ,"int",width,"int",height,"uint",4|8)
                
                VarSetCapacity(mask_bits, width*height*4, 0)
                if DllCall("GetDIBits","uint",hdcDest,"uint",hbmMask,"uint",0
                            ,"uint",height,"uint",&mask_bits,"uint",&buf,"uint",0)
                {   ; Use icon mask to generate alpha data.
                    Loop, % height*width ; %
                        if (NumGet(mask_bits, (A_Index-1)*4))
                            NumPut(0, pBits+(A_Index-1)*4)
                        else
                            NumPut(NumGet(pBits+(A_Index-1)*4) | 0xFF000000, pBits+(A_Index-1)*4)
                } else {   ; Make the bitmap entirely opaque.
                    Loop, % height*width ; %
                        NumPut(NumGet(pBits+(A_Index-1)*4) | 0xFF000000, pBits+(A_Index-1)*4)
                }
            }
        }
    
        ; Done using the device context.
        DllCall("DeleteDC","uint",hdcDest)
    }

    if hbmColor
        DllCall("DeleteObject","uint",hbmColor)
    if hbmMask
        DllCall("DeleteObject","uint",hbmMask)
    return bm
}


; ============================================================================
;      Inbuilt functions:
; ============================================================================

; ====================================================
; Help routines for inbuilt functions
; ====================================================
GetOutputSequence(group, pos, marker)
{ 
  Global
  ;msgbox pos %pos%

  test := SubStr(Group, pos, 1)
  if (marker <> "")
    search := marker
  else if (test <> "'"  && test <> chr(0x22))
    search := A_Space
  else
    search := test  
	
  ende   := InStr(group, search ,false,pos + 1) 
  ;msgbox ende %ende%
  length := ende - pos	
  check  := SubStr(Group, pos , length)  

  StringRight, t, check, 1
  if (t == " ")
    StringTrimRight, check, check, 1
  	
  StringRight, t, check, 1
  if (t == "|")
    StringTrimRight, check, check, 1
	
  x := strlen(test)
  ;msgbox length %length%
  ;msgbox check %check%
  if (test == "'"  || test == chr(0x22))
  {
    StringTrimLeft, check,check,1
    StringTrimRight, check,check,1
    check = $%check%	
  }  
  else if (test == "0")
  {
    t := ""
    StringRight, t, check, 1
	if (t == "|")
      StringTrimRight, check,check,1	
	  
	check := PrepareUnicode(check, SequenceMarker) 
	    ;msgbox t %test%
	  	;msgbox newcheck %check%

  }
  else if (test == "$")
  {
    t := ""
    StringRight, t, check, 1
	StringReplace, check, check, SequenceMarker, %A_SPACE%, All

	if (t == "|")
	{
      StringRight, t, check, 2
	  if (t <> "$|")
	    StringTrimRight, check,check,1	
	}  
  }    
  return %check%
  }	

ReplaceValue(group, key, insert)
{
  global
  StringCaseSense, On
  StringGetPos, FoundAt, Group, %key%
  ;msgbox key %key%
  ;msgbox found %foundAt%
  if (FoundAt <> -1)
  {
	ReplaceAt := FoundAt + strLen(key) + 1
	; check if replace value follows
	k := SubStr(Group, ReplaceAt , 1)
	if (SubStr(Group, ReplaceAt , 1) == " ")
	{
	  t := GetOutputSequence(group, ReplaceAt + 1, " ")
	  ;msgbox output %t%
      SendKey(t, insert)
	  KeyFired := true
	  return true
	}
    else
	  return false	
  }	
  else
    return false
}  	

AddOutputSequence(sequ)
{
  Global
  OutputSequence = %OutputSequence%%Sequ%
  if (StrLen(OutputSequence) > 150)
    StringRight, OutputSequence, OutputSequence, 80
}

DefaultKey()
{
  global
  ; msgbox %keyFired% %LastKey%
  if (KeyFired = False)
    SendKey(LastKey,0)
}

; ===================================================================================
;
;   Routines for processing the language keyboard
;
; ===================================================================================

; Send ansi keystrokes or unicode numbers
SendKey(what, back)
{
  Global
  LastOutput := what      ; Store output value
  AddOutputSequence(what) ; Store all past output
  	
  if (back > 0)           ; Backspace character needed?
    Send {BS %back%}
	
  StringLeft, t, what, 1  ; Get first character to determine which type it is
  ;msgbox %what%
  ; ---------------------------------------------------------
  ; Single character or word:
  if (t == "$")       
  {
    StringTrimLeft, what, what, 1
	LastLength := StrLen(what)
    SendRaw %what%
	KeyFired   := True
  }	
  
  ; ----------------------------------------------------------
  ; Strings:
  else if (t == "'" || t == chr(0x22))  ; single or double quotes
  {
    StringTrimLeft,  what, what, 1
    StringTrimRight, what, what, 1	
	LastLength := StrLen(what)
    SendRaw %what%    
	KeyFired   := True
  }
  
  ; ----------------------------------------------------------
  ; Unicode character
  
  else  
    ; Single character:
    if (StrLen(what) == 6)  
	{
	   LastLength := 1
	   Send  {%what%}
	   ;SendUnicode(what)
	   KeyFired   := True
	}
	; Unicode string:
	;else  
	;{
  	;  StringTrimLeft, what, what, 2	                  ; remove hex prefix
	;  StringReplace, NewStr, string, A_SPACE,, All    ; remove spaces between 
	;  StringReplace, NewStr, string, SequenceMarker,, All
	;  LastLength := StrLen(what) / 4   
	;  SendUnicodeString(what)
	;  KeyFired   := True
	;}   
}

; Prepares a Unicode sequence for sending
PrepareUnicode(string, what)
{
  if (what == "")
    what := A_SPACE	
	
  StringReplace, NewStr, string, %what%,, All
  return NewStr
}

; ===========================================================================
; Exchange keys
; ===========================================================================

; Exchanges the key with another key or sequence:
ExchangeKey(Group) 
{
  Global
  if (KeyFired = false)

    return ReplaceValue(group, LastKey, 0)	
}  

; ===========================================================================
; Replace keys
; ===========================================================================

; Searches through a group variable and replaces the last put out key with a new character
ReplaceLastKey(Group) 
{
  Global 
  if (KeyFired = false)
  {
    if (LastOutput <> "")
      return ReplaceValue(group, LastOutput, LastLength)
  }	
  else
    return false
}  

ReplaceLastKeyDefault(Group, default) 
{
  Global 
  if (KeyFired = false)
  {
    if (LastOutput <> "")
      if ReplaceValue(group, LastOutput, LastLength) = false
	    Sendkey(default,0)
  }	
  else
    return false
}  

; Replaces the last character if the last output is followed by the right key
ReplaceDoubleKey(Group) 
{
  Global 
  if (KeyFired = false)
  {

    if (LastOutput <> "")
    {  
      ss = %LastOutput% %LastKey%

      return ReplaceValue(group, ss, LastLength)
    }	
	else
	  return false
  }	
} 


; Replaces the last character 
ReplaceKeyOpen(group, key)
{
  Global
  if (KeyFired = false)
  {
    return ReplaceValue(group, key, LastLength)
  }	
}  

; Replaces last character if the right key was sent
KeyReplace(key, group)
{
  Global
  If (KeyFired = false)
  {
    if (LastKey == key)
	  return ReplaceLastKey(group)
  }
}


; ===========================================================================
; Group information
; ===========================================================================

; Searches if a given key exists in a group variable
InGroup(Group, key)
{
  Global
  if (key == "")
    return false
  else
  {  
    StringGetPos, FoundAt, Group, %key%
    if (ErrorLevel == 1) 
      return false
    else 
      return true  
  }	  
}  

; Returns an element from a list
Element(group, number, marker)
{ 
  Global
  
  if (marker = "")
    marker := elementmarker
  StringGetPos, x, group, %marker%, L%number%,0
  x := x + strLen(marker)
  t := GetOutputSequence(group,x + 1, " ")
  return t
}

; Returns the number of an given element of a group
ElementNumber(group, name, marker)
{
  Global
  StringGetPos, x, group, %name%

  if (marker = "")
    marker := elementmarker

  if (x <> -1)
  {  
    a := 0
	c := 0
    loop
	{
	  StringGetPos, a, group, %marker%,L1,a
	  if (a == -1 || a > x)
	    break
	  a += 1
      c += 1	  
	}
    return c
  }
  else
    return -1  
}

; ===========================================================================
; Matrix function
; ===========================================================================

MatrixOut(Group, key, default, offset, new)
{
  Global
  StringCaseSense, On
  if (KeyFired = false)
  {

  if (key <> "")    ; New key provided?
    MatrixKey := key  
  	
 if (Matrixkey <> "")
 { 
    StringGetPos, MatPos, Group, %MatrixKey%	 ; search the location of the key
  
    if (MatPos <> -1) ; Key found?
    {
      StringGetPos, x, group, %MatrixMarker%, L%offset%, %MatPos% ; Find correct element
	  t := GetOutputSequence(group,x + 2, " " )                       ; Get element
	  if (new = false)
	    SendKey(t, 0)		; Put it out
      else
        SendKey(t, LastLength)
	    
	  return true
    }
    else
	{
      if (default <> "")
        SendKey(default, 0)
      return false
	}  
  }
  else 
  {
    if (default <> "")
      SendKey(default, 0)
    return false  
  }	
  }
}	

KeyMatrix(group, matrix, base)
{
  Global
  If (KeyFired = false)
  {
    if  (InGroup(group, LastKey) = true)   ; replacement key for matrix founc
	{
	  keynum := ElementNumber(group,LastKey,ElementMarker)
	  return MatrixOut(matrix,"","",keynum + 1, false)
	}
	else
	  return MatrixOut(matrix,"$"LastKey,"",base, true)
  }
}


; ===========================================================================
; Context function
; ===========================================================================

GetLeftContext(num, reset)
{  
  send +{Left %num%}  ; select left character 
  clipboard =   ; Empty the clipboard.
  send ^c     	      ; copy to clipboard
  x := clipboard      ; Copy clipboard into variable
  if (reset = True)   ; Remove selection?
    Send {Right}
  return x            ; Return variable 
}  

GetRightContext(num, reset)
{  
  send +{Right %num%}  ; select left character
  clipboard =   ; Empty the clipboard.
  send ^c     	       ; copy to clipboard
  x := clipboard
  if (reset = True)
    Send {Left}
  return x
}  
