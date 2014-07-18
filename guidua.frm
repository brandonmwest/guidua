VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{57A1F96E-5A81-4063-8193-6E7BB254EDBD}#1.0#0"; "DXAnimatedGIF.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Guidua"
   ClientHeight    =   2220
   ClientLeft      =   7140
   ClientTop       =   6975
   ClientWidth     =   5460
   Icon            =   "guidua.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2220
   ScaleWidth      =   5460
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdRun 
      Caption         =   "Generate List"
      Height          =   345
      Left            =   1080
      TabIndex        =   6
      Top             =   150
      Width           =   1185
   End
   Begin VB.Frame Frame1 
      Height          =   765
      Left            =   4110
      TabIndex        =   3
      Top             =   60
      Width           =   1305
      Begin DXAnimatedGIF.DXGif aniGears 
         Height          =   595
         Left            =   45
         TabIndex        =   5
         Top             =   135
         Visible         =   0   'False
         Width           =   1200
         _ExtentX        =   2117
         _ExtentY        =   1058
         BackColor       =   14737632
         DelayValue      =   1
      End
      Begin VB.PictureBox picGears 
         BackColor       =   &H00E0E0E0&
         BorderStyle     =   0  'None
         Height          =   585
         Left            =   45
         Picture         =   "guidua.frx":058A
         ScaleHeight     =   585
         ScaleWidth      =   1200
         TabIndex        =   4
         Top             =   135
         Width           =   1200
      End
   End
   Begin MSComDlg.CommonDialog cmnDlg1 
      Left            =   3105
      Top             =   225
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdConfigure 
      Caption         =   "Configure"
      Height          =   345
      Left            =   97
      TabIndex        =   2
      Top             =   150
      Width           =   915
   End
   Begin VB.TextBox txtString 
      BackColor       =   &H00808080&
      ForeColor       =   &H00FFFFFF&
      Height          =   1290
      Left            =   75
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   1
      Text            =   "guidua.frx":36C0
      Top             =   885
      Width           =   5340
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000011&
      X1              =   -1560
      X2              =   7185
      Y1              =   0
      Y2              =   0
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000016&
      X1              =   -1125
      X2              =   7620
      Y1              =   -45
      Y2              =   -45
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000016&
      X1              =   1680
      X2              =   10425
      Y1              =   -375
      Y2              =   -375
   End
   Begin VB.Label lblString 
      Caption         =   "Command string:"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   615
      Width           =   1215
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu itmGen 
         Caption         =   "&Generate List"
         Shortcut        =   ^G
      End
      Begin VB.Menu itmPrefs 
         Caption         =   "&Configuration"
      End
      Begin VB.Menu div 
         Caption         =   "-"
      End
      Begin VB.Menu itmExit 
         Caption         =   "E&xit"
         Shortcut        =   ^X
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Tools"
      Begin VB.Menu itmOutput 
         Caption         =   "Output Designer"
         Shortcut        =   ^O
      End
   End
   Begin VB.Menu mnuAbout 
      Caption         =   "&About"
      Begin VB.Menu itmAbout 
         Caption         =   "About Guidua"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Function validateDirs()
    Dim blnSuccess
    blnSuccess = True
    
    If txtBaseDir <> "" Then
        'If Not dirExists(txtBaseDir.Text) Then
            'MsgBox "You have not entered a valid base directory.", vbExclamation, "Invalid Directory"
            'blnSuccess = False
        'End If
        If txtExcludeDir <> "" Then
            'If Not dirExists(txtExcludeDir.Text) Then
             '   MsgBox "You have not entered a valid exclude directory.", vbExclamation, "Invalid Directory"
             '   blnSuccess = False
            'End If
        End If
    Else
        MsgBox "You have not entered a valid base directory.", vbExclamation, "Invalid Directory"
        blnSuccess = False
    End If
    validateDirs = blnSuccess
End Function
Public Function validatePath()

    strExecutable = sGetINI(strIni, "settings", "executable", "")
    
    While Not fileExists(strExecutable)
        With cmnDlg1
            .DialogTitle = "Oidua not found. Enter path to Oidua:"  'this sets the caption for the title bar on the dialog
            .InitDir = App.Path
            
            .FileName = "oidua.exe"
            
            .Filter = "executable files (*.exe)|*.exe|python files (*.py)|*.py"
        
            .ShowOpen
        End With
        
        strExecutable = cmnDlg1.FileName
                
        If strExecutable = "" Then
            validatePath = False
            Exit Function
        End If
    Wend

    writeINI strIni, "settings", "executable", strExecutable

    validatePath = True
End Function
Public Function dirExists(OrigFile As String)
    Dim FS
    Set FS = CreateObject("Scripting.FileSystemObject")
    dirExists = FS.folderexists(OrigFile)
End Function
Public Function fileExists(OrigFile As String)
    Dim FS
    Set FS = CreateObject("Scripting.FileSystemObject")
    fileExists = FS.fileExists(OrigFile)
End Function
Private Sub WriteTextFile(ByVal FileName As String, ByVal Text As String)
    Dim fso
    Dim ts
    Dim f1
    
    Set fso = CreateObject("Scripting.FileSystemObject")
    fso.CreateTextFile (FileName)
    
    Set f1 = fso.GetFile(FileName)
    Set ts = f1.OpenAsTextStream(2, True)
    
    ts.write (Text)
    ts.Close
    
    Set fso = Nothing
    Set ts = Nothing
    Set f1 = Nothing
    
End Sub
Private Function ReadTextFile(ByVal FileName As String)
    Dim fso
    Dim ts
    Dim f1
    
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    Set f1 = fso.GetFile(FileName)
    Set ts = f1.OpenAsTextStream(1, True)
        
    ReadTextFile = ts.ReadAll()
    ts.Close
    
    Set fso = Nothing
    Set ts = Nothing
    Set f1 = Nothing
End Function

Private Sub cmdAbout_Click()
    frmAbout.Show 1
End Sub

Private Sub cmdConfigure_Click()
    frmOptions.Show 1, Me
End Sub
Private Sub cmdRun_click()
    generateList
End Sub
Private Sub generateList()
    Dim strSwitches As String
    Dim strOuputFile As String
    
    If Not validatePath Then
        Exit Sub
    End If
    
    If Not validateDirs Then
        Exit Sub
    End If
    
    cmdRun.Enabled = False
    itmGen.Enabled = False
    aniGears.Visible = True
    picGears.Visible = False
    
    If chkWildcard = 1 Then
        strSwitches = strSwitches & "-w "
    End If
    If chkVersion = 1 Then
        strSwitches = strSwitches & "-V "
    End If
    If chkTimestamp = 1 Then
        strSwitches = strSwitches & "-t "
    End If
    If chkDatestamp = 1 Then
        strSwitches = strSwitches & "-D "
    End If
    
    If chkStrip = 1 Then
        strSwitches = strSwitches & "-s "
    End If
    If chkStats = 1 Then
        strSwitches = strSwitches & "-S "
    End If
    If chkCaseInsensitive = 1 Then
        strSwitches = strSwitches & "-i "
    End If
    If chkMerge = 1 Then
        strSwitches = strSwitches & "-m "
    End If
    If chkHtml = 1 Then
        strSwitches = strSwitches & "-H "
        strSwitches = strSwitches & "-T #" & txtColor & " "
        strSwitches = strSwitches & "-B #" & txtBG & " "
    End If
    
    strSwitches = strSwitches & "-q"
    strSwitches = strSwitches & " -o " & """" & txtOutput & """"
    
    If txtOutputFile <> "" Then
        strSwitches = strSwitches & " -f " & """" & txtOutputFile & """"
    Else
        strSwitches = strSwitches & " -f " & """" & App.Path & "\temp.txt" & """"
    End If
    If txtExcludeDir <> "" Then
        Dim arrExclude
        Dim i As Integer
        
        arrExclude = Split(txtExcludeDir, "%")
    
        For i = 0 To UBound(arrExclude)
            strSwitches = Trim(strSwitches) & " -e " & Trim(arrExclude(i))
        Next
        
    End If
    
    If txtBaseDir <> "" Then
        strSwitches = strSwitches & " " & txtBaseDir
    End If
    
    txtString.Text = Replace(strExecutable & " " & strSwitches, " -f " & """" & App.Path & "\temp.txt" & """", "")
    
    ExecuteApp (strAppPath & strExecutable & " " & strSwitches)
    
    If chkClipboard = 1 Then
        
        If txtOutputFile <> "" Then
            strList = ReadTextFile(txtOutputFile)
        Else
            strList = ReadTextFile(App.Path & "\temp.txt")
            Kill App.Path & "\temp.txt"
        End If
        
        Clipboard.Clear
        Clipboard.SetText strList
    End If
        
    If txtOutputFile <> "" Then
        writeINI strIni, "settings", "output_file", txtOutputFile
    End If
    
    cmdRun.Enabled = True
    itmGen.Enabled = True
    picGears.Visible = True
    aniGears.Visible = False
    
    If chkOpen = 1 Then
       ShellExecute Me.hwnd, "Open", txtOutputFile, vbNullString, vbNullString, vbNormalFocus
    End If
    
    Exit Sub
End Sub
Private Sub Form_Activate()
    readIni
End Sub
Private Sub Form_Load()
    readIni
    aniGears.FileName = App.Path & "\gears.gif"
End Sub
Private Sub readIni()
    'read from INI file
    txtBaseDir = sGetINI(strIni, "settings", "base_dir", "")
    txtExcludeDir = sGetINI(strIni, "settings", "exclude_dir", "")
    
    chkWildcard = CInt(sGetINI(strIni, "switches", "wildcard", 1))
    chkVersion = CInt(sGetINI(strIni, "switches", "display_version", 1))
    chkTimestamp = CInt(sGetINI(strIni, "switches", "display_timestamp", 1))
    chkDatestamp = CInt(sGetINI(strIni, "switches", "display_datestamp", 1))
    'chkClipboard = CInt(sGetINI(strIni, "settings", "copy_to_clipboard", 0))
    chkStats = CInt(sGetINI(strIni, "switches", "stats", 0))
    chkCaseInsensitive = CInt(sGetINI(strIni, "switches", "case_insensitive", 0))
    chkMerge = CInt(sGetINI(strIni, "switches", "merge", 0))
    chkHtml = CInt(sGetINI(strIni, "settings", "output_html", 0))
    chkStrip = CInt(sGetINI(strIni, "switches", "strip_empty", 0))
    chkOpen = CInt(sGetINI(strIni, "settings", "open_after_gen", 0))
    
    txtOutput = sGetINI(strIni, "settings", "output_string", "[n,-60] | [f,5] | [s,6,b] | [l,6] | [t,4] | [q,-7]")
    txtOutputFile = sGetINI(strIni, "settings", "output_file", App.Path & "\list.txt")
    txtColor = sGetINI(strIni, "settings", "html_color", "")
    txtBG = sGetINI(strIni, "settings", "html_bgcolor", "")
    
    blnScript = CBool(InStr(1, sGetINI(strIni, "settings", "executable", ""), ".py"))
    strExecutable = sGetINI(strIni, "settings", "executable", "")
End Sub
Private Sub itmAbout_Click()
    frmAbout.Show 1
End Sub
Private Sub itmExit_Click()
    Unload Me
End Sub
Private Sub itmGen_Click()
    generateList
End Sub
Private Sub itmOutput_Click()
    frmOutput.Show 1, Me
End Sub
Private Sub itmPrefs_Click()
    frmOptions.Show 1, Me
End Sub

