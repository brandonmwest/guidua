Attribute VB_Name = "Module1"

'email: takisfmf@yahoo.gr
'for more source code visit
'http://www.geocities.com/takisfmf/index.html









Private Type RECT
    left As Long
    top As Long
    right As Long
    bottom As Long
End Type
Private Type POINT
    x As Long
    y As Long
End Type
Private Declare Sub ClipCursor Lib "user32" (lpRect As Any)
Private Declare Sub GetClientRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT)
Private Declare Sub ClientToScreen Lib "user32" (ByVal hWnd As Long, lpPoint As POINT)
Private Declare Sub OffsetRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long)





 Sub LimitCursor(pic)
    'Limits the Cursor movement in to the pictureBox
    
    Dim client As RECT
    Dim upperleft As POINT
    
    'Get information about our wndow
    
    GetClientRect pic.hWnd, client
    upperleft.x = client.left
    upperleft.y = client.top
    
    
    'Convert window coordinates to screen coordinates
    ClientToScreen pic.hWnd, upperleft
    
    
    'move our rectangle
    OffsetRect client, upperleft.x, upperleft.y
    
    
    'limit the cursor movement
    ClipCursor client

End Sub


Sub ReleaseCursor()
    'Releases the cursor limits
    ClipCursor ByVal 0&
End Sub







