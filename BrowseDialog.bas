Attribute VB_Name = "BrowseDialog"
Option Explicit
Declare Function SHBrowseForFolder Lib "shell32.dll" Alias _
        "SHBrowseForFolderA" (lpBrowseInfo As BROWSEINFO) As Long

Declare Function SHGetPathFromIDList Lib "shell32.dll" Alias _
        "SHGetPathFromIDListA" (ByVal pidl As Long, _
        ByVal pszPath As String) As Long

Const BIF_RETURNONLYFSDIRS = &H1

Type BROWSEINFO
   hOwner As Long
   pidlRoot As Long
   pszDisplayName  As String
   lpszTitle As String
   ulFlags As Long
   lpfn As Long
   lParam As Long
   iImage As Long
End Type

Type SHITEMID
   cb As Long
   abID As Byte
End Type

Type ITEMIDLIST
   mkid As SHITEMID
End Type

Function GetBrowseDirectory(Owner As Form) As String
   Dim bi As BROWSEINFO
   Dim IDL As ITEMIDLIST
   Dim r As Long
   Dim pidl As Long
   Dim tmpPath As String
   Dim pos As Integer
   Dim BIF_RETURNONLYFSDIRS

   bi.hOwner = Owner.hWnd
   bi.pidlRoot = 0&
   bi.lpszTitle = "Choose a directory from the list."
   bi.ulFlags = BIF_RETURNONLYFSDIRS
   pidl = SHBrowseForFolder(bi)

   tmpPath = Space$(512)
   r = SHGetPathFromIDList(ByVal pidl, ByVal tmpPath)

   If r Then
      pos = InStr(tmpPath, Chr$(0))
      tmpPath = Left(tmpPath, pos - 1)

      If Right(tmpPath, 1) <> "\" Then tmpPath = tmpPath & "\"
         GetBrowseDirectory = tmpPath
      Else
         GetBrowseDirectory = ""
      End If

End Function
