object LoginForm: TLoginForm
  Left = 373
  Height = 186
  Top = 156
  Width = 230
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 186
  ClientWidth = 230
  OnDestroy = FormDestroy
  OnShow = FormShow
  Position = poMainFormCenter
  LCLVersion = '7.2'
  object URIEdit: TLabeledEdit
    Left = 8
    Height = 23
    Top = 24
    Width = 213
    EditLabel.Height = 15
    EditLabel.Width = 213
    EditLabel.Caption = 'Tarantool URI:'
    EditLabel.ParentColor = False
    TabOrder = 0
  end
  object EmailEdit: TLabeledEdit
    Left = 8
    Height = 23
    Top = 72
    Width = 213
    EditLabel.Height = 15
    EditLabel.Width = 213
    EditLabel.Caption = 'Email:'
    EditLabel.ParentColor = False
    TabOrder = 1
  end
  object OkBtn: TButton
    Left = 8
    Height = 25
    Top = 152
    Width = 104
    Caption = 'Ok'
    OnClick = OkBtnClick
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 117
    Height = 25
    Top = 152
    Width = 104
    Caption = 'Cancel'
    OnClick = CancelBtnClick
    TabOrder = 3
  end
  object PasswordEdit: TLabeledEdit
    Left = 8
    Height = 23
    Top = 120
    Width = 213
    EchoMode = emPassword
    EditLabel.Height = 15
    EditLabel.Width = 213
    EditLabel.Caption = 'Password:'
    EditLabel.ParentColor = False
    PasswordChar = '*'
    TabOrder = 4
  end
end
