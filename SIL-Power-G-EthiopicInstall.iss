; -- Install the FreeKey keyboard.iss --

[Code]
var
  SourceName   : string;
  KeyingDoc    : string;
  InstallFont  : boolean;
  LicenseText  : string;

{ Some predefined variables, so that you dont need to mess with the code section below}
procedure InitializeVariables;
begin
  SourceName  := 'SIL-Power-G-Ethiopic';                // Folder name where the source code should be installed into   (only last subfolder)
  KeyingDoc   := 'SIL-Power-G-EthiopicKeyboardMap.pdf'; // Use the name of keying document
  InstallFont := True;                         // Should fonts be installed with the program?
  LicenseText := 'The MIT License (MIT)' + #13#10 + #13#10 +
    'Permission is hereby granted, free of charge, to any person obtaining a copy of this software ' +
    'and associated documentation files (the "Software"), to deal in the Software without ' +
    'restriction, including without limitation the rights to use, copy, modify, merge, publish, ' +
    'distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the ' +
    'Software is furnished to do so, subject to the following conditions: The above copyright notice ' +
    'and this permission notice shall be included in all copies or substantial portions of the Software. ' +
    'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT ' +
    'NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND ' +
    'NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, ' +
    'DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ' +
    'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.';
end;

[Setup]
OutputBaseFilename=FreeKey SIL Power-G Ethiopic Keyboard
AppName=SIL Power-G Ethiopic
AppVerName=SIL Power-G Ethiopic Version 1.1
DefaultDirName={pf}\FreeKey
DefaultGroupName=FreeKey
UninstallDisplayName=FreeKey SIL Power-G Ethiopic Keyboard
AppPublisher=SIL Ethiopia
AppPublisherURL=http://www.silethiopia.org/
DirExistsWarning=No

[Files]
; The program files themself:
Source: "SIL-Power-G-Ethiopic.exe";                DestDir: "{app}";
Source: "SIL-Power-G-EthiopicOn.ico";              DestDir: "{app}";
Source: "SIL-Power-G-EthiopicOff.ico";             DestDir: "{app}";
Source: "SIL-Power-G-EthiopicKeyboardMap.pdf";     DestDir: "{app}";
Source: "SIL-Power-G-EthiopicKeyboard.txt";        DestDir: "{app}"; Flags: onlyifdoesntexist

; Documentation:
Source: "The free keyboards.doc";                  DestDir: {code:GetDocFolder};
Source: "SIL-Power-G-EthiopicKeyboardMap.pdf";     DestDir: {code:GetDocFolder};

; Source Code:
Source: "SIL-Power-G-Ethiopic.ahk";                DestDir: {code:GetSourceFolder};  Check: Check2State;
Source: "BasicRoutines.ahk";                       DestDir: {code:GetSourceFolder};  Check: Check2State;
Source: "SIL-Power-G-EthiopicOn.ico";              DestDir: {code:GetSourceFolder};  Check: Check2State;
Source: "SIL-Power-G-EthiopicOff.ico";             DestDir: {code:GetSourceFolder};  Check: Check2State;
Source: "SIL-Power-G-EthiopicInstall.iss";         DestDir: {code:GetSourceFolder};  Check: Check2State;
Source: "SIL-Power-G-EthiopicKeyboard.txt";        DestDir: {code:GetSourceFolder};  Check: Check2State;
Source: "SIL-Power-G-EthiopicKeyboardMap.odt";     DestDir: {code:GetSourceFolder};  Check: Check2State;
Source: "How to prepare a keyboard.doc";           DestDir: {code:GetSourceFolder};  Check: Check2State;

; Install the font:
Source: "AbyssinicaSIL-R.TTF"; DestDir: "{fonts}"; FontInstall: "Abyssinica SIL"; Flags: uninsneveruninstall;  Check: Check4State;

[Icons]
Name: "{group}\SIL-Power-G-Ethiopic";                          Filename: "{app}\SIL-Power-G-Ethiopic.exe";   IconFilename: "{app}\SIL-Power-G-EthiopicOn.ico"
Name: "{group}\Documents\SIL-Power-G-EthiopicKeyboardMap.pdf"; Filename: "{app}\Documents\SIL-Power-G-EthiopicKeyboardMap.pdf"
Name: "{group}\Documents\The free keyboards.doc";              Filename: "{app}\Documents\The free keyboards.doc"
Name: "{commondesktop}\SIL-Power-G-Ethiopic.exe";              Filename: "{app}\SIL-Power-G-Ethiopic.exe";   IconFilename: "{app}\SIL-Power-G-EthiopicOn.ico"; WorkingDir: "{app}"; Check: Check3State;

[Registry]
; Start this program with Windows:
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "SIL-Power-G-Ethiopic.exe"; ValueData: "{app}\SIL-Power-G-Ethiopic.exe"; Check: Check1State;

[Run]
; Start the program when the installation finished
Filename: "{app}\SIL-Power-G-Ethiopic.exe"; Flags: postinstall nowait;

; ************************************************************************************************************************************

; ************************************************************************************************************************************


[Code]
var
  SelectInstallPage : TInputOptionWizardPage;
  BasicInstallPage  : TWizardPage;
  DocDirPage        : TInputDirWizardPage;
  SourceDirPage     : TInputDirWizardPage;
  InstallType       : integer;

  CB1     : TCheckBox;    // Start with windows
  CB2     : TCheckBox;    // Install source code
  CB3     : TCheckBox;    // create shortcut
  CB4     : TCheckBox;    // Install Font
  


function  CreateButton(const X, Y, Width: integer; Caption: string; Parent: TWinControl; ClickEvent: TNotifyEvent): TButton; forward;
function  CreateCheckBox(const X, Y, Width: integer; Caption: string; checked : boolean; Parent: TWinControl; ClickEvent: TNotifyEvent): TCheckBox; forward;

procedure Button1Click(Sender: TObject); forward;
procedure Button2Click(Sender: TObject); forward;

procedure CheckBox5Click(Sender: TObject); forward;
procedure CheckBox6Click(Sender: TObject); forward;

procedure CreateAboutButton(ParentForm: TSetupForm; CancelButton: TNewButton); forward;


procedure InitializeWizard;
var
button1 : TButton;
button2 : TButton;

But5     : TButton;    // Show user manual
But6     : TButton;    // Show keying manual

begin
  { Create the pages }
  
  InitializeVariables;
  CreateAboutButton(WizardForm, WizardForm.CancelButton);


  // --------------------------------------------------------------------------------
  SelectInstallPage := CreateInputOptionPage(wpWelcome, 'Select installation type', '',
    'Please select the way how you would like to do the installation',
    True, False);
    
    button1 := CreateButton(10, 30, 120, 'Default installation', SelectInstallPage.Surface, @Button1Click);
    button1.Height := 50;       // Enlarge button

    button2 := CreateButton(10, 90, 120, 'Custom installation',  SelectInstallPage.Surface, @Button2Click);
    button2.Height := 50;
  // --------------------------------------------------------------------------------

  BasicInstallPage := CreateCustomPage(SelectInstallPage.ID, 'Basic settings', '');
    
  cb1 := CreateCheckBox(10, 30, 180, 'Start program with windows', true, BasicInstallPage.Surface, nil);
  cb2 := CreateCheckBox(10, 80, 180, 'Install source code', true, BasicInstallPage.Surface, nil);
  cb3 := CreateCheckBox(10, 130, 180, 'Create shortcut on desktop', true, BasicInstallPage.Surface, nil);
                        
  if Installfont = True then
    cb4 := CreateCheckBox(10, 180, 180, 'Install font', true, BasicInstallPage.Surface, nil);

  // --------------------------------------------------------------------------------

  DocDirPage := CreateInputDirPage(wpSelectDir,
    'Install Documentation', 'Where should the documentation files be installed?',
    'Select the folder in which Setup should install documentation files' + #13#10#13#10 +
    'To continue, click Next. If you would like to select a different folder, click Browse.',
    False, 'Documents');
  DocDirPage.Add('');
  DocDirPage.Values[0] := ExpandConstant('{pf}\FreeKey\Documents');

  // --------------------------------------------------------------------------------

  SourceDirPage := CreateInputDirPage(DocDirPage.ID,
    'Install Source code', 'Where should the source code be installed?',
    'Select the folder in which Setup should install the source code' + #13#10#13#10 +
    'To continue, click Next. If you would like to select a different folder, click Browse.',
    False, 'Source code');
  SourceDirPage.Add('');
  SourceDirPage.Values[0] := ExpandConstant('{pf}\FreeKey\Source\' + SourceName );
  

  // --------------------------------------------------------------------------------

  // Add extra buttons on last page:
  But5 := CreateButton(200, 180, 180, 'Show user manual',   WizardForm.FinishedPage, @CheckBox5Click);
  But6 := CreateButton(200, 240, 180, 'Show keying manual', WizardForm.FinishedPage, @CheckBox6Click);
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  { Skip pages that shouldn't be shown }

  if PageID = SelectInstallPage.ID then result := False  // Always show this page

  //
  else if InstallType = 1 then  // Default installation
  begin
    if (PageID = wpReady) or (PageID = wpFinished) then result := False
                        else result := True
  end
  else                     // custom installation
  begin
    if (cb2.checked = false) and (PageID = SourceDirPage.ID) then result := true
                                                             else result := False;
  end;
end;

procedure CurPageChanged(CurrentPage: integer);
begin
  if CurrentPage = SelectInstallPage.ID then
  begin
      WizardForm.NextButton.Visible := False;
  end;
end;

function CreateButton(const X, Y, Width: integer; Caption: string;
Parent: TWinControl; ClickEvent: TNotifyEvent): TButton;
begin
  Result := TButton.Create(WizardForm);
  if Result <> nil then
  begin
    Result.Left := X;
    Result.Top := Y;
    Result.Width := Width;
    Result.Caption := Caption;
    Result.Parent := Parent;
    Result.OnClick := ClickEvent;
  end;
end;

function CreateCheckBox(const X, Y, Width: integer; Caption: string; checked : boolean;
Parent: TWinControl; ClickEvent: TNotifyEvent): TCheckBox;
begin
  Result := TCheckBox.Create(WizardForm);
  if Result <> nil then
  begin
    Result.Left := X;
    Result.Top := Y;
    Result.Width := Width;
    Result.Caption := Caption;
    Result.Checked := checked;
    Result.Parent := Parent;
    Result.OnClick := ClickEvent;
  end;
end;


procedure Button1Click(Sender: TObject);
begin
  InstallType := 1;
  WizardForm.NextButton.OnClick(nil);
end;

procedure Button2Click(Sender: TObject);
begin
  InstallType := 2;
  WizardForm.NextButton.OnClick(nil);
end;

procedure CheckBox5Click(Sender: TObject);
var
  ErrorCode: Integer;

begin
  if not ShellExec('', ExpandConstant(DocDirPage.Values[0] + '\The free keyboards.doc'),
     '', '', SW_SHOW, ewNoWait, ErrorCode) then
  begin
    // handle failure if necessary
  end;

end;

procedure CheckBox6Click(Sender: TObject);
var
  ErrorCode: Integer;

begin
  if not ShellExec('', ExpandConstant(DocDirPage.Values[0] + '\' + KeyingDoc),
     '', '', SW_SHOW, ewNoWait, ErrorCode) then
  begin
    // handle failure if necessary
  end;
end;

{Check parameter funktions}
function Check1State : boolean;       // Start with Windows
begin
  result := cb1.checked;
end;

function Check2State : boolean;       // Install Source Code
begin
  result := cb2.checked;
end;

function Check3State : boolean;       // Create desktop shortcut
begin
  result := cb3.checked;
end;

function Check4State : boolean;       // Create desktop shortcut
begin
  if InstallFont = True then result := cb4.checked
                        else result := False;
end;

{Functions used for selecting the correct directories for installation}
function GetSourceFolder(get: string) : string;
begin
  result := SourceDirPage.Values[0];
end;

function GetDocFolder(get: string) : string;
begin
  result := DocDirPage.Values[0];
end;

{Update the text in the "Ready page"}
function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var
  S: String;

begin
  // Fill the 'Ready Memo' with the normal settings and the custom settings
  If InstallType = 1 Then  // Default Installation
  begin
    S := 'Default installation: ' + NewLine + NewLine;
    S := S + MemoDirInfo + NewLine + NewLine;
    S := S + MemoGroupInfo + NewLine + NewLine;
    S := S + 'Documentation installed into:' + NewLine;
    S := S + '    ' + DocDirPage.Values[0]  + NewLine + NewLine;
    S := S + 'Source code installed into:' + NewLine;
    S := S + '    ' + SourceDirPage.Values[0]  + NewLine + NewLine;
    S := S + 'Program will start with Windows' + NewLine + NewLine;
    S := S + 'Program shortcut will be placed onto desktop' + NewLine + NewLine;
    if InstallFont = True then S := S + 'Font(s) will be installed'
  end
  else // Custom installation
  begin
    S := 'Custom installation:'  + NewLine + NewLine;
    S := S + MemoDirInfo + NewLine + NewLine;
    S := S + MemoGroupInfo + NewLine + NewLine;
    S := S + 'Documentation installed into:' + NewLine;
    S := S + '    ' + DocDirPage.Values[0]  + NewLine + NewLine;
    

    if cb1.checked = true then
                          begin
                            S := S + 'Source code installed into:' + NewLine;
                            S := S + '    ' + SourceDirPage.Values[0]  + NewLine + NewLine;
                          end
                          else
                            S := 'No source code installed' + NewLine;
      
    if cb1.Checked = true then S := S + 'Program will start with Windows' + NewLine + NewLine;
    if cb3.checked = True then S := S + 'Program shortcut will be placed onto desktop' + NewLine + NewLine;
    
    if InstallFont = True then
      S := S + 'Font(s) will be installed'
  end;
  Result := S;
end;

procedure AboutButtonOnClick(Sender: TObject);
begin
  MsgBox(LicenseText, mbInformation, mb_Ok);
end;

procedure CreateAboutButton(ParentForm: TSetupForm; CancelButton: TNewButton);
var
  AboutButton: TNewButton;
  URLLabel: TNewStaticText;
begin
  AboutButton := TNewButton.Create(ParentForm);
  AboutButton.Left := ParentForm.ClientWidth - CancelButton.Left - CancelButton.Width;
  AboutButton.Top := CancelButton.Top;
  AboutButton.Width := CancelButton.Width;
  AboutButton.Height := CancelButton.Height;
  AboutButton.Caption := '&License...';
  AboutButton.OnClick := @AboutButtonOnClick;
  AboutButton.Parent := ParentForm;
end;
