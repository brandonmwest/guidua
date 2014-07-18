Attribute VB_Name = "waitFunctions"
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwAcess _
  As Long, ByVal fInherit As Integer, ByVal hObject As Long) As Long


Public Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long

Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Public Const STILL_ACTIVE = &H103
