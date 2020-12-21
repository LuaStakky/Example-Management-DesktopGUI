object Form1: TForm1
  Left = 373
  Height = 498
  Top = 156
  Width = 836
  Caption = 'Managemnet'
  ClientHeight = 478
  ClientWidth = 836
  Color = clForm
  Menu = MainMenu
  OnDestroy = FormDestroy
  LCLVersion = '7.2'
  object MainPanel: TPanel
    Left = 0
    Height = 478
    Top = 0
    Width = 836
    Align = alClient
    ClientHeight = 478
    ClientWidth = 836
    Enabled = False
    TabOrder = 0
    object Spiner: TplCircleProgress
      Left = 394
      Height = 100
      Top = 185
      Width = 100
      ColorDoneMax = 16080685
      ColorRemain = clNone
      ColorInner = clNone
      StartAngle = 320
      Max = 360
      Position = 180
      ShowText = False
      Anchors = []
      Color = clNone
      ParentColor = False
      Visible = False
    end
    object Panel3: TGroupBox
      Left = 288
      Height = 476
      Top = 1
      Width = 149
      Align = alLeft
      Caption = 'Projects'
      ClientHeight = 456
      ClientWidth = 145
      TabOrder = 1
      object ProjectsListBox: TListBox
        Left = 0
        Height = 427
        Top = 0
        Width = 145
        Align = alClient
        Enabled = False
        ItemHeight = 0
        OnSelectionChange = ProjectsListBoxSelectionChange
        TabOrder = 0
      end
      object SyncProjBtn: TBitBtn
        Left = 0
        Height = 29
        Top = 427
        Width = 145
        Align = alBottom
        Caption = 'SyncProjects'
        Images = ImageList1
        ImageIndex = 1
        OnClick = SyncProjBtnClick
        TabOrder = 1
      end
    end
    object Panel1: TGroupBox
      Left = 1
      Height = 476
      Top = 1
      Width = 138
      Align = alLeft
      Caption = 'Credentials'
      ClientHeight = 456
      ClientWidth = 134
      TabOrder = 2
      object CredentialListBox: TListBox
        Left = 0
        Height = 284
        Top = 0
        Width = 134
        Align = alClient
        Enabled = False
        ItemHeight = 0
        OnSelectionChange = CredentialListBoxSelectionChange
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Height = 172
        Top = 284
        Width = 134
        Align = alBottom
        ClientHeight = 172
        ClientWidth = 134
        TabOrder = 1
        object AddCredBtn: TBitBtn
          Left = 1
          Height = 29
          Top = 142
          Width = 132
          Align = alBottom
          Caption = 'AddCreditails'
          Images = ImageList1
          ImageIndex = 0
          OnClick = AddCredBtnClick
          TabOrder = 0
        end
        object AddCredURL: TLabeledEdit
          Left = 8
          Height = 23
          Top = 24
          Width = 120
          EditLabel.Height = 15
          EditLabel.Width = 120
          EditLabel.Caption = 'URL:'
          EditLabel.ParentColor = False
          TabOrder = 1
        end
        object AddCredLogin: TLabeledEdit
          Left = 8
          Height = 23
          Top = 68
          Width = 120
          EditLabel.Height = 15
          EditLabel.Width = 120
          EditLabel.Caption = 'Login:'
          EditLabel.ParentColor = False
          TabOrder = 2
        end
        object AddCredPassword: TLabeledEdit
          Left = 8
          Height = 23
          Top = 112
          Width = 120
          EchoMode = emPassword
          EditLabel.Height = 15
          EditLabel.Width = 120
          EditLabel.Caption = 'Password'
          EditLabel.ParentColor = False
          PasswordChar = '*'
          TabOrder = 3
        end
      end
    end
    object Panel4: TGroupBox
      Left = 139
      Height = 476
      Top = 1
      Width = 149
      Align = alLeft
      Caption = 'Users and Groups'
      ClientHeight = 456
      ClientWidth = 145
      TabOrder = 3
      object SyncUsersBtn: TBitBtn
        Left = 0
        Height = 29
        Top = 298
        Width = 145
        Align = alBottom
        Caption = 'SyncUsers'
        Images = ImageList1
        ImageIndex = 1
        OnClick = SyncUsersBtnClick
        TabOrder = 0
      end
      object UsersListBox: TListView
        Left = 0
        Height = 298
        Top = 0
        Width = 145
        Align = alClient
        AutoSort = False
        AutoWidthLastColumn = True
        Columns = <>
        Enabled = False
        SmallImages = ImageList1
        SmallImagesWidth = 15
        TabOrder = 1
        OnSelectItem = UsersListBoxSelectItem
      end
      object UpdateUserPanel: TPanel
        Left = 0
        Height = 129
        Top = 327
        Width = 145
        Align = alBottom
        ClientHeight = 129
        ClientWidth = 145
        TabOrder = 2
        object UpdateUserBtn: TBitBtn
          Left = 1
          Height = 29
          Top = 99
          Width = 143
          Align = alBottom
          Caption = 'CommitChanges'
          Images = ImageList1
          ImageIndex = 0
          OnClick = UpdateUserBtnClick
          TabOrder = 0
        end
        object SalaryPerHourCurrencyEdit: TLabeledEdit
          Left = 8
          Height = 23
          Top = 69
          Width = 128
          EditLabel.Height = 15
          EditLabel.Width = 128
          EditLabel.Caption = 'SalaryPerHourCurrency:'
          EditLabel.ParentColor = False
          MaxLength = 3
          TabOrder = 1
        end
        object SalaryPerHourSpin: TFloatSpinEdit
          Left = 8
          Height = 23
          Top = 25
          Width = 128
          TabOrder = 2
        end
        object StaticText1: TStaticText
          Left = 8
          Height = 17
          Top = 7
          Width = 121
          Caption = 'SalaryPerHour:'
          TabOrder = 3
        end
      end
    end
    object Panel5: TGroupBox
      Left = 437
      Height = 476
      Top = 1
      Width = 149
      Align = alLeft
      Caption = 'Reports'
      ClientHeight = 456
      ClientWidth = 145
      TabOrder = 4
      object ReportsListBox: TListBox
        Left = 0
        Height = 240
        Top = 0
        Width = 145
        Align = alClient
        Enabled = False
        ItemHeight = 0
        OnSelectionChange = ReportsListBoxSelectionChange
        TabOrder = 0
      end
      object UpdateUserPanel1: TPanel
        Left = 0
        Height = 216
        Top = 240
        Width = 145
        Align = alBottom
        ClientHeight = 216
        ClientWidth = 145
        TabOrder = 1
        object GenNewReportBtn: TBitBtn
          Left = 1
          Height = 29
          Top = 186
          Width = 143
          Align = alBottom
          Caption = 'GenNewReport'
          Images = ImageList1
          ImageIndex = 0
          OnClick = GenNewReportBtnClick
          TabOrder = 0
        end
        object ResultCurrencyEdit: TLabeledEdit
          Left = 8
          Height = 23
          Top = 68
          Width = 128
          EditLabel.Height = 15
          EditLabel.Width = 128
          EditLabel.Caption = 'ResultCurrency:'
          EditLabel.ParentColor = False
          MaxLength = 3
          TabOrder = 1
          Text = 'USD'
        end
        object DefaultHoursPerIssueSpin: TFloatSpinEdit
          Left = 8
          Height = 23
          Top = 25
          Width = 128
          TabOrder = 2
          Value = 8
        end
        object StaticText2: TStaticText
          Left = 8
          Height = 17
          Top = 7
          Width = 128
          Caption = 'DefaultHoursPerIssue:'
          TabOrder = 3
        end
        object DefaultPaymentCurrencyEdit: TLabeledEdit
          Left = 8
          Height = 23
          Top = 156
          Width = 128
          EditLabel.Height = 15
          EditLabel.Width = 128
          EditLabel.Caption = 'SalaryPerHourCurrency:'
          EditLabel.ParentColor = False
          MaxLength = 3
          TabOrder = 4
          Text = 'USD'
        end
        object DefaultHourlyPaymentSpin: TFloatSpinEdit
          Left = 8
          Height = 23
          Top = 112
          Width = 128
          TabOrder = 5
          Value = 10
        end
        object StaticText3: TStaticText
          Left = 8
          Height = 17
          Top = 94
          Width = 128
          Caption = 'DefaultHourlyPayment:'
          TabOrder = 6
        end
      end
    end
    object Chromium: TChromiumWindow
      Left = 586
      Height = 476
      Top = 1
      Width = 249
      Align = alClient
      TabOrder = 5
    end
  end
  object MainMenu: TMainMenu
    Left = 32
    Top = 32
    object DataBaseMenuItem: TMenuItem
      Caption = 'DataBase'
      object LoginMenuItem: TMenuItem
        Caption = 'Login'
        OnClick = LoginMenuItemClick
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 30
    OnTimer = Timer1Timer
    Left = 32
    Top = 88
  end
  object ImageList1: TImageList
    Left = 32
    Top = 144
    Bitmap = {
      4C7A0400000010000000100000000D0400000000000078DAA5955D48935118C7
      75A4B9FCC8442D172C210D5A1729DE54D41051A420314DCC0FBA5904419AA597
      A18154EE224814CD4411A3C56A26D237A5D91223BD2A522B2F4271D6C4A6AD95
      51DB7B3AFFE591E3DBFBEE75DBE08FE73CCFF33BE739CF79CE6B48C8EADFB6D4
      0DE925A7B5D7EADA767DBC7A37ED3784316CF085C8FCC22354EAF233DAF6C6DE
      74818AC84828AFD4B62356CC9E33EEB0FAE056E96CC30E2BBFC6F2BEFFC57DFB
      61F34ACA5746F360E795CBD9F973D62BB9B368976B2597A7024F589D03E5EBDA
      74DE3BE2CFEBFC31BB2241707BC5DBF87AB0FB0D860F36FF60EB17ECFD79FBA7
      32A0FEB9CEF72F7A32D0FE656B94552ABF1FEC1BBE7E35CBFFB42BEF57C7BDDF
      7F75D64ABC5F4288ACB60E9399670B44EF2BC697D6BF2064E34BE25AEB1A4F1D
      24B3E01DB16C1926739415C04BAD81380F21A16CFE5B20EB4E7C206D2C5E4A9A
      6162436CDD277201F38A497295F186F7BE59B6FFE022D9CFDB9F2F9003C885B7
      158F11D35B17D9F94720A1E2DC052AEABFC5628F8E913B85F4BC6C7E6C9C9894
      EA8FB5593CADD3172A3B9BC3A754E3250F59C7E5EB5996770E9F122FDADF9E44
      7390DB1FB9E30CBC0D6764F1383B6AC0D5EE96C0B1A81DECA825D6466DF95AA3
      F6B803DE863BE25939E1CE594EE805D8D01B98A3577CB1E835F41CE3D18BC885
      48E4BE2C013D8DDEE6E37C895F23D0F72755FFB5686464245DAFD73F0B0B0BFB
      151919B9585C5C7CC366B36D5E0B3B3A3ABA5BAD56BBF069E1959C9C3CE97038
      362AF1D9D9D98FC42C536D6DED79253E2A2A6A518ECFC9C979A8C4C7C7C77F96
      E3F3F2F22C4ABCC1606895E33B3B3BCB95F8F9F9F94D3A9DEE8D982D2C2C3479
      3C9E505FACD3E9DC30303070606A6A4A63341ACFD27C7B8A8A8A6E7677771FB3
      DBED71D4B7DFE572A9A5D8FEFE7E7D6C6CEC3CF6A235F8D2DCDC7C727A7A3A09
      6B3536369E8A8B8B9B830F7F070707F7F12CD64C484898953BB7581A8D667A69
      69299CF12693A968AD2C93C562C95B79BF151557FCE56B6A6A2E33BEA0A0C0EC
      2F5F5252D2CD787A37B7FDE5F1A6188FFAFACBB7B6B61A18EF76BB55555555C6
      E8E8688712171313F3959EFDA2522F052BB3D97C242B2BEB3184B1BFAC386FA5
      35666666364F4C4C6C97FB86C0061F6210CBB32D2D2D06954AE5465C69696927
      FD4E3C90F8763C800F63C482617C6262A28D8FADAFAF3F27E6C536308C4F4D4D
      1D6376AC8DFC7A7A7A0EE7E6E6DE8730868DE5088161BCD56ADD9B9292328E37
      88BC3A3A3ACAF1EEF3F3F3CD10C6B0C18718C482617C5F5FDFC18686869AA1A1
      A13DE82B5F3D8718C482015B5D5D7D89F9E91EC769BEF7E478F810C3E6602322
      22BEB379575757696666E613391E3EC4B039CF06C28B15088FFF9181F2609B9A
      9A4E666464BC4A4B4B7BDDDBDB7B88D6E422C652820F311883011BEC3BFD0B6C
      0FB921
    }
  end
  object ChromiumInitTimer: TTimer
    Interval = 100
    OnTimer = ChromiumInitTimerTimer
    Left = 31
    Top = 203
  end
end
