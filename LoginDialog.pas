unit LoginDialog;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, DBConnector;

type

  { TLoginForm }

  TLoginForm = class(TForm)  
  published
    OkBtn: TButton;
    CancelBtn: TButton;
    URIEdit: TLabeledEdit;
    EmailEdit: TLabeledEdit;
    PasswordEdit: TLabeledEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private

  public
    Connector:TDBConnector;
    Result:Integer;
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.frm}

{ TLoginForm }

procedure TLoginForm.OkBtnClick(Sender: TObject);
begin
  Connector:=TDBConnector.Create(URIEdit.Text);
  if Connector.TestConnection() then
    if Connector.Login(EmailEdit.Text,PasswordEdit.Text) then
    begin
      Result:=1;
      Close;
    end
    else
    begin
      FreeAndNil(Connector);
      ShowMessage('Login Failed');
    end
  else 
  begin
    FreeAndNil(Connector);
    ShowMessage('Connetion Failed(Maybe origin down?)');
  end;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin        
  URIEdit.Text:='';
  EmailEdit.Text:='';
  PasswordEdit.Text:='';
  Result:=0;
end;

procedure TLoginForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Connector);
end;

procedure TLoginForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

end.

