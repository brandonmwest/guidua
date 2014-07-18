Attribute VB_Name = "ExecuteApplication"
Option Explicit
      
Private Declare Function CreatePipe Lib "kernel32" ( _
    phReadPipe As Long, _
    phWritePipe As Long, _
    lpPipeAttributes As Any, _
    ByVal nSize As Long) As Long
      
Private Declare Function ReadFile Lib "kernel32" ( _
    ByVal hFile As Long, _
    ByVal lpBuffer As String, _
    ByVal nNumberOfBytesToRead As Long, _
    lpNumberOfBytesRead As Long, _
    ByVal lpOverlapped As Any) As Long
      
Private Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Long
End Type

Private Type STARTUPINFO
    cb As Long
    lpReserved As Long
    lpDesktop As Long
    lpTitle As Long
    dwX As Long
    dwY As Long
    dwXSize As Long
    dwYSize As Long
    dwXCountChars As Long
    dwYCountChars As Long
    dwFillAttribute As Long
    dwFlags As Long
    wShowWindow As Integer
    cbReserved2 As Integer
    lpReserved2 As Long
    hStdInput As Long
    hStdOutput As Long
    hStdError As Long
End Type
      
Private Type PROCESS_INFORMATION
    hProcess As Long
    hThread As Long
    dwProcessID As Long
    dwThreadID As Long
End Type

Public processId As Long

Private Declare Function CreateProcessA Lib "kernel32" (ByVal _
    lpApplicationName As Long, ByVal lpCommandLine As String, _
    lpProcessAttributes As Any, lpThreadAttributes As Any, _
    ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, _
    ByVal lpEnvironment As Long, ByVal lpCurrentDirectory As Long, _
    lpStartupInfo As Any, lpProcessInformation As Any) As Long
      
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Const PROCESS_QUERY_INFORMATION = &H400
Private Const NORMAL_PRIORITY_CLASS = &H20&
Private Const STARTF_USESTDHANDLES = &H100&
Private Const STARTF_USESHOWWINDOW = &H1

'Runs an ms-dos application and returns
'text print to stdOutput and stdErr.
'This text would usually be printed to the screen.
Public Sub ExecuteApp(sCmdline As String)
    Dim lngBytesRead As Long, sBuffer As String * 256
    Dim lastLine As String
    Dim lHandle As Long
    Dim exitCode As Long
    Dim ret As Long
    Dim i As Integer
   
    processId = Shell(sCmdline, vbHide)
    lHandle = OpenProcess(PROCESS_QUERY_INFORMATION, True, processId)
    
    Do
        Call GetExitCodeProcess(lHandle, exitCode)
        DoEvents
        If blnCancel Then
            '
            ' Enumerate all parent windows for the process.
            '
            Call fEnumWindows
            '
            ' Send a close command to each parent window.
            ' The app may issue a close confirmation dialog
            ' depending on how it handles the WM_CLOSE message.
            '
            For i = 1 To colHandle.Count
                lHandle = colHandle.Item(i)
                Call SendMessage(lHandle, WM_CLOSE, 0&, 0&)
            Next
            
            frmMain.cmdRun.Enabled = True
            frmMain.itmGen.Enabled = True
            frmMain.picGears.Visible = True
            frmMain.aniGears.Visible = False
            frmMain.cmdCancel.Enabled = False
            blnCancel = False
        End If
    Loop While (exitCode = STILL_ACTIVE)
End Sub

