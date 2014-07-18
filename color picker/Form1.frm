VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Color Picker   "
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   3090
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   151
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   206
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CmdCansel 
      Caption         =   "Cansel"
      Height          =   240
      Left            =   1680
      TabIndex        =   12
      Top             =   1950
      Width           =   1095
   End
   Begin VB.CommandButton Cmdok 
      Caption         =   "ok"
      Height          =   240
      Left            =   360
      TabIndex        =   11
      Top             =   1950
      Width           =   1110
   End
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      Height          =   1755
      Left            =   960
      Picture         =   "Form1.frx":0000
      ScaleHeight     =   113
      ScaleLeft       =   1
      ScaleMode       =   0  'User
      ScaleTop        =   1
      ScaleWidth      =   105
      TabIndex        =   10
      Top             =   120
      Width           =   1630
      Begin VB.Line Line2 
         BorderColor     =   &H00FFFFFF&
         X1              =   25
         X2              =   33
         Y1              =   9
         Y2              =   9
      End
      Begin VB.Line Line1 
         BorderColor     =   &H80000005&
         X1              =   1
         X2              =   9
         Y1              =   9
         Y2              =   9
      End
      Begin VB.Line Line3 
         BorderColor     =   &H80000005&
         X1              =   17
         X2              =   17
         Y1              =   1
         Y2              =   9
      End
      Begin VB.Line Line4 
         BorderColor     =   &H80000005&
         X1              =   17
         X2              =   17
         Y1              =   17
         Y2              =   25
      End
   End
   Begin VB.PictureBox Picture4 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   150
      Left            =   120
      Picture         =   "Form1.frx":8BBE
      ScaleHeight     =   11
      ScaleMode       =   0  'User
      ScaleWidth      =   7
      TabIndex        =   9
      Top             =   2040
      Visible         =   0   'False
      Width           =   105
   End
   Begin VB.PictureBox Picture5 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      DrawWidth       =   3
      ForeColor       =   &H80000008&
      Height          =   1845
      Left            =   2850
      ScaleHeight     =   55
      ScaleMode       =   0  'User
      ScaleWidth      =   12
      TabIndex        =   8
      Top             =   75
      Width           =   180
   End
   Begin VB.PictureBox Picture3 
      AutoRedraw      =   -1  'True
      Height          =   1755
      Left            =   2670
      ScaleHeight     =   51
      ScaleMode       =   0  'User
      ScaleWidth      =   8
      TabIndex        =   7
      Top             =   120
      Width           =   180
   End
   Begin VB.PictureBox Picture2 
      Height          =   600
      Left            =   150
      ScaleHeight     =   36
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   41
      TabIndex        =   6
      Top             =   1280
      Width           =   668
   End
   Begin VB.TextBox TR 
      Enabled         =   0   'False
      Height          =   285
      Left            =   360
      TabIndex        =   2
      Top             =   120
      Width           =   465
   End
   Begin VB.TextBox TG 
      Enabled         =   0   'False
      Height          =   285
      Left            =   360
      TabIndex        =   1
      Top             =   480
      Width           =   465
   End
   Begin VB.TextBox TB 
      Enabled         =   0   'False
      Height          =   285
      Left            =   360
      TabIndex        =   0
      Top             =   840
      Width           =   465
   End
   Begin VB.Label Lb10 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      Caption         =   "R"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   12
         Charset         =   161
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   180
   End
   Begin VB.Label Lb11 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      Caption         =   "G"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   12
         Charset         =   161
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Left            =   120
      TabIndex        =   4
      Top             =   480
      Width           =   180
   End
   Begin VB.Label Lb12 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      Caption         =   "B"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   12
         Charset         =   161
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   285
      Left            =   120
      TabIndex        =   3
      Top             =   840
      Width           =   165
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'email: takisfmf@yahoo.gr
'for more source code visit
'http://www.geocities.com/takisfmf/index.html




Dim Rout, Gout, Bout, FlagCansel
Dim yy, rm, gm, bm








Private Sub Form_Load()

  Picture3.ScaleHeight = -54        'αντιστρεψε συντεταγμενες του pictureBox που δινει τις διαβαθμισεις Luminance
  Picture3.ScaleTop = 54
 
  x = Picture1.ScaleWidth / 2
  y = Picture1.ScaleHeight / 2

  DrawCross x, y
  GetColorAndDrawLuminance x, y
  
  yy = Picture5.ScaleHeight / 2
  SetIndicatorAndAdjustLuminance
             
End Sub






                              'οση ωρα κινηται ο cursor μεσα στον επιλογεα χρωματος - παλετα , παρε τα rm, gm, bm και σχεδιασε διαβαθμισεις Luminance αναλογα με την τρεχουσα τιμη του yy που οριζεται απο τον δεικτη Luminance
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
                                       
  If Button = 1 And x > 0 And y > 0 Then
     
     LimitCursor Form1.Picture1
     
     Line1.Visible = False
     Line2.Visible = False
     Line3.Visible = False
     Line4.Visible = False

     GetColorAndDrawLuminance x, y
     SetIndicatorAndAdjustLuminance

  End If
End Sub








Sub GetColorAndDrawLuminance(x, y)

   colr = Picture1.POINT(x, y)            'παρε την τιμη χρωματος στην θεση x,y

   rm = colr Mod 256                     ' υπολογισε τα rm, gm, bm
   colr = colr \ 256
   gm = colr Mod 256
   colr = colr \ 256
   bm = colr Mod 256
                                      'σχεδιασε διαβαθμισεις Luminance βαση των τιμων rm, gm, bm
   For y = 0 To 51 Step 3
     If y < 25.5 Then
        rc = Int(rm * y / 25.5)
        gc = Int(gm * y / 25.5)
        bc = Int(bm * y / 25.5)
     Else
        rc = Int(rm + (255 - rm) * (y - 25.5) / 25.5)
        gc = Int(gm + (255 - gm) * (y - 25.5) / 25.5)
        bc = Int(bm + (255 - bm) * (y - 25.5) / 25.5)
     End If
     Picture3.Line (0, y)-(7, y + 2.6), RGB(rc, gc, bc), BF
   Next

End Sub







                                         'σχεδιαση σταυρου που δειχνει την θεση απο οπου επιλεχθηκαν τα rm, gm, bm

Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)

  ReleaseCursor
  If x >= Picture1.ScaleWidth - 2 Then x = Picture1.ScaleWidth - 2
  If y >= Picture1.ScaleHeight - 2 Then y = Picture1.ScaleHeight - 2
  If x <= 1 Then x = 1
  If y <= 1 Then y = 1

  DrawCross x, y

  Line1.Visible = True
  Line2.Visible = True
  Line3.Visible = True
  Line4.Visible = True

End Sub








                                  
Sub DrawCross(x, y)
  Line1.X1 = x - 9
  Line1.Y1 = y
  Line1.X2 = x - 4
  Line1.Y2 = y

  Line2.X1 = x + 4
  Line2.Y1 = y
  Line2.X2 = x + 9
  Line2.Y2 = y

  Line3.X1 = x
  Line3.Y1 = y - 9
  Line3.X2 = x
  Line3.Y2 = y - 4

  Line4.X1 = x
  Line4.Y1 = y + 4
  Line4.X2 = x
  Line4.Y2 = y + 9

End Sub






                                                            'υπολογισμος νεας θεσης (yy) δεικτη Luminace καθε φορα που αυτος κινηται
Private Sub picture5_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  
  If Button = 1 Then
          
     LimitCursor Form1.Picture5

     Picture5.Cls
     If y >= Picture5.ScaleHeight - 4 Then y = Picture5.ScaleHeight - 4
     If y <= 0 Then y = 0

     yy = Int(51 - y)
     SetIndicatorAndAdjustLuminance
  End If
  ReleaseCursor
End Sub







Sub SetIndicatorAndAdjustLuminance()
                                                  'θεσε δεικτη Luminance στην θεση yy
  Picture5.PaintPicture Picture4.Picture, 1, 51 - yy, 7, 11, 0, 0, 7, 11, vbSrcCopy

  If yy < 25.5 Then                               'Mετατρεψε τα επιλεγμενα rm, gm, bm αναλογα με την τιμη του δεικτη Luminance
     Rout = Int(rm * yy / 25.5)
     Gout = Int(gm * yy / 25.5)
     Bout = Int(bm * yy / 25.5)
  Else
     Rout = Int(rm + (255 - rm) * (yy - 25.5) / 25.5)
     Gout = Int(gm + (255 - gm) * (yy - 25.5) / 25.5)
     Bout = Int(bm + (255 - bm) * (yy - 25.5) / 25.5)
  End If
                                                 'βαλε χρωμα με νεο Luminance στα TextBoxes και στο pictureBox που δινει το επιλεγμενο χρωμα
  Picture2.BackColor = RGB(Rout, Gout, Bout)
  
  TR.Text = Str(Rout)
  TG.Text = Str(Gout)
  TB.Text = Str(Bout)

End Sub








Private Sub CmdCansel_Click()
  FlagCansel = 1                     'Αν FlagCansel=1 , μην παρεις τα Rout, Gout, Bout σαν νεο χρωμα
  Unload Me
End Sub




Private Sub Cmdok_Click()
  FlagCansel = 0                    ' Αν FlagCansel=0 , παρε τα Rout, Gout, Bout σαν νεο χρωμα
  Unload Me
End Sub



