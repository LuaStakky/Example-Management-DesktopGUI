unit MainForm;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, Spin, LoginDialog, LazLogger, DBConnector,

  Variants, uCEFChromiumWindow, uCEFTypes, TplCircleProgressUnit, TplShapeObjects;

type

  { TForm1 }

  TForm1 = class(TForm)
    ResultCurrencyEdit: TLabeledEdit;
    DefaultPaymentCurrencyEdit: TLabeledEdit;
    DefaultHoursPerIssueSpin: TFloatSpinEdit;
    DefaultHourlyPaymentSpin: TFloatSpinEdit;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    GenNewReportBtn: TBitBtn;
    UpdateUserPanel1: TPanel;
    procedure GenNewReportBtnClick(Sender: TObject);
  private
    MouseEvent:TCefMouseEvent;
    type
      TWorker=class abstract(TThread)
      private
        ErrText:String;
      public
        constructor Create();
        procedure InitGUI;virtual;  
        procedure Execute;override;   
        procedure ExecuteWithTry;virtual;abstract;
        procedure FinishGUI;virtual;
      end;

      TUpdateCredentialsWorker=class(TWorker)
      private
        CredentialList:TCreditalList;
      public
        procedure InitGUI;override;
        procedure ExecuteWithTry;override;
        procedure FinishGUI;override;
      end;

      TAddCredentialWorker=class(TWorker)
      private
        Cred:TCredentialInfo;
      public
        procedure ExecuteWithTry;override;
        procedure FinishGUI;override;
      end;

      TLoadCredWorker=class(TWorker)
      private
        CredInfo:TCredentialInfo;
      public
        constructor Create(ACredInfo:TCredentialInfo);
        procedure InitGUI;override;
        procedure ExecuteWithTry;override;
        procedure FinishGUI;override;
      end;

      TSyncProjectsWorker=class(TWorker)
      public
        procedure InitGUI;override;
        procedure ExecuteWithTry;override;   
        procedure FinishGUI;override;
      end;

      TSyncUsersWorker=class(TWorker)
      public
        procedure InitGUI;override;
        procedure ExecuteWithTry;override;
        procedure FinishGUI;override;
      end;     

      TCommitUserWorker=class(TWorker)
      private
        User:TUser;
      public        
        constructor Create(AUser:TUser);
        procedure InitGUI;override;
        procedure ExecuteWithTry;override;
      end;

      TShowReportWorker=class(TWorker)
      private
        Report:TReport;
        HTML:String;
      public
        constructor Create(AReport:TReport);
        procedure ExecuteWithTry;override; 
        procedure FinishGUI;override;
      end;

      TGenAndSaveReportWorker=class(TWorker)
      private
        Project:TProject;
        ResultCurrency,DefaultPaymentCurrency:TSalaryCurrency;
        DefaultHoursPerIssue,DefaultHourlyPayment:Double;
      public                      
        constructor Create(AProject:TProject);
        procedure InitGUI;override;
        procedure ExecuteWithTry;override;
        procedure FinishGUI;override;
      end;
  published            
    AddCredBtn: TBitBtn;
    Chromium: TChromiumWindow;
    Panel5: TGroupBox;
    ReportsListBox: TListBox;
    SalaryPerHourSpin: TFloatSpinEdit;
    StaticText1: TStaticText;
    ChromiumInitTimer: TTimer;
    UpdateUserBtn: TBitBtn;
    AddCredLogin: TLabeledEdit;
    SalaryPerHourCurrencyEdit: TLabeledEdit;
    AddCredPassword: TLabeledEdit;
    AddCredURL: TLabeledEdit;
    CredentialListBox: TListBox;
    ImageList1: TImageList;
    MainPanel: TPanel;
    Panel1: TGroupBox;
    Panel2: TPanel;
    Panel3: TGroupBox;
    Panel4: TGroupBox;
    UpdateUserPanel: TPanel;
    ProjectsListBox: TListBox;
    SyncProjBtn: TBitBtn;
    SyncUsersBtn: TBitBtn;
    UsersListBox: TListView;
    MainMenu: TMainMenu;
    DataBaseMenuItem: TMenuItem;
    LoginMenuItem: TMenuItem;
    Spiner: TplCircleProgress;
    Timer1: TTimer;
    CurrentWork: TWorker;
    procedure FormDestroy(Sender: TObject);
    procedure LoginMenuItemClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);        
    procedure DoParallelRequest(Request: TWorker);  
    procedure AddCredBtnClick(Sender: TObject);
    procedure ChromiumInitTimerTimer(Sender: TObject);
    procedure CredentialListBoxSelectionChange(Sender: TObject; User: boolean);
    procedure ProjectsListBoxSelectionChange(Sender: TObject; User: boolean);
    procedure ReportsListBoxSelectionChange(Sender: TObject; User: boolean);
    procedure SyncProjBtnClick(Sender: TObject);
    procedure SyncUsersBtnClick(Sender: TObject);
    procedure UpdateUserBtnClick(Sender: TObject);
    procedure UsersListBoxSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  public     
    Connector:TDBConnector;  
    CredentialList:TCreditalList;
    CurrCredential:TCredential;
  end;

var
  Form1: TForm1;

implementation

{$R *.frm}

//TForm1.TWorker       

constructor TForm1.TWorker.Create();
begin
  inherited Create(True);
end;

procedure TForm1.TWorker.InitGUI;
begin
  with Form1 do
  begin                      
    MainPanel.Enabled:=False;
    DataBaseMenuItem.Enabled:=False;
    Spiner.Visible:=True;
    Timer1.Enabled:=True;
    ErrText:=''
  end;
end;           

procedure TForm1.TWorker.Execute;
begin
  try
    ExecuteWithTry;
  except
    on E:Exception do
       ErrText:=E.Message;
  end;
end;

procedure TForm1.TWorker.FinishGUI;
begin
  with Form1 do
  begin            
    Timer1.Enabled:=False;
    if ErrText<>'' then
      ShowMessage(ErrText)
    else
      with Form1.Connector do
        if (LastResponseCode>=300) or (LastResponseCode<200) then
          ShowMessage('Http error. Code: '+IntToStr(LastResponseCode));
    MainPanel.Enabled:=True;
    DataBaseMenuItem.Enabled:=True;
    Spiner.Visible:=False;
  end;
end;
         
//TForm1.TUpdateCredentialsWorker
       
procedure TForm1.TUpdateCredentialsWorker.InitGUI;
begin
  inherited;
  Form1.CredentialListBox.Clear;
end;

procedure TForm1.TUpdateCredentialsWorker.ExecuteWithTry;
begin
  with Form1 do
  begin           
    FreeAndNil(CredentialList);
    CredentialList:=Connector.GetRedmineCredentialsList();
    Sleep(1000);
  end;
end;

procedure TForm1.TUpdateCredentialsWorker.FinishGUI;
var
  i:TCredentialInfo;
begin
  inherited;
  with Form1 do
    if Assigned(CredentialList) then
      for i in CredentialList do
        CredentialListBox.AddItem(i.Login,nil);
end;

//TForm1.TAddCredentialWorker

procedure TForm1.TAddCredentialWorker.ExecuteWithTry;
begin
  with Form1 do
    Cred:=Connector.AddRedmineCredentials(
      AddCredURL.Text,
      AddCredLogin.Text,
      AddCredPassword.Text);
end;

procedure TForm1.TAddCredentialWorker.FinishGUI;
begin
  inherited;
  with Form1 do
    if Assigned(Cred) then
    begin
      CredentialListBox.AddItem(Cred.Login,nil);
      CredentialList.Add(Cred);
    end;
end;

//TForm1.TLoadCredWorker

constructor TForm1.TLoadCredWorker.Create(ACredInfo:TCredentialInfo);
begin
  inherited Create();
  CredInfo:=ACredInfo;
end;

procedure TForm1.TLoadCredWorker.InitGUI;
begin
  inherited;
  with Form1 do
  begin
    ProjectsListBox.Clear;
    UsersListBox.Clear;
  end;
end;

procedure TForm1.TLoadCredWorker.ExecuteWithTry;
begin
  with Form1 do
    CurrCredential:=CredInfo.Credential;
end;

procedure TForm1.TLoadCredWorker.FinishGUI;
var
  ip:TProject;  
  iu:TUser;
begin
  inherited;
  with Form1 do
  begin
    if Assigned(CurrCredential.ProjectsList) then
      for ip in CurrCredential.ProjectsList do
        ProjectsListBox.AddItem(ip.Name,nil);
    ProjectsListBox.Enabled:=True;  
    if Assigned(CurrCredential.UsersList) then
      for iu in CurrCredential.UsersList do      
        with UsersListBox.Items.Add do
        begin                       
          Caption:=iu.Name;
          case iu.&Type of        
          UTUser:ImageIndex:=2;
          UTGroup:ImageIndex:=3;
          end;
        end;
    UsersListBox.Enabled:=True;
  end;
end;


//TForm1.TSyncProjectsWorker    

procedure TForm1.TSyncProjectsWorker.InitGUI;
begin
  inherited;
  Form1.ProjectsListBox.Clear;
end;

procedure TForm1.TSyncProjectsWorker.ExecuteWithTry;
begin            
  with Form1 do
    CurrCredential.SyncProjects();
end;        

procedure TForm1.TSyncProjectsWorker.FinishGUI;
var
  i:TProject;
begin
  inherited;
  with Form1 do
  begin
    if Assigned(CurrCredential.ProjectsList) then
      for i in CurrCredential.ProjectsList do
        ProjectsListBox.AddItem(i.Name,nil);
    ProjectsListBox.Enabled:=True;
  end;
end;

//TForm1.TSyncUsersWorker

procedure TForm1.TSyncUsersWorker.InitGUI;
begin
  inherited;
  Form1.UsersListBox.Clear;
end;

procedure TForm1.TSyncUsersWorker.ExecuteWithTry;
begin
  with Form1 do
    CurrCredential.SyncUsers();
end;

procedure TForm1.TSyncUsersWorker.FinishGUI;
var
  i:TUser;
begin
  inherited;
  with Form1 do
  begin
    if Assigned(CurrCredential.UsersList) then
      for i in CurrCredential.UsersList do
        with UsersListBox.Items.Add do
        begin
          Caption:=i.Name;
          case i.&Type of
          UTUser:ImageIndex:=2;
          UTGroup:ImageIndex:=3;
          end;
        end;
    UsersListBox.Enabled:=True;
  end;
end;

//TForm1.TCommitUserWorker           

constructor TForm1.TCommitUserWorker.Create(AUser:TUser);
begin                 
  inherited Create();
  User:=AUser;
end;

procedure TForm1.TCommitUserWorker.InitGUI;
begin             
  inherited;
  with Form1 do
  begin
    User.SalaryPerHour:=SalaryPerHourSpin.Value;
    User.SalaryPerHourCurrency:=SalaryPerHourCurrencyEdit.Text;
  end;
end;

procedure TForm1.TCommitUserWorker.ExecuteWithTry;
begin
  with Form1 do
    User.CommitChanges();
end;

//TForm1.TShowReportWorker
                             
constructor TForm1.TShowReportWorker.Create(AReport:TReport);
begin              
  inherited Create();
  Report:=AReport;
end;

procedure TForm1.TShowReportWorker.ExecuteWithTry;     
begin
  HTML:=Report.GetHTML;
end;

procedure TForm1.TShowReportWorker.FinishGUI;   
begin            
  inherited;
  Form1.Chromium.ChromiumBrowser.LoadString(HTML);
end;

//TForm1.TGenAndSaveReportWorker

constructor TForm1.TGenAndSaveReportWorker.Create(AProject:TProject);
begin
  inherited Create();
  Project:=AProject;
end;

procedure TForm1.TGenAndSaveReportWorker.InitGUI;
begin
  inherited;
  with Form1 do
  begin
    ResultCurrency:=ResultCurrencyEdit.Text;
    DefaultPaymentCurrency:=DefaultPaymentCurrencyEdit.Text;
    DefaultHoursPerIssue:=DefaultHoursPerIssueSpin.Value;
    DefaultHourlyPayment:=DefaultHourlyPaymentSpin.Value;
  end;
end;

procedure TForm1.TGenAndSaveReportWorker.ExecuteWithTry;
begin
  Project.GenAndSaveReport(ResultCurrency,DefaultHoursPerIssue,DefaultHourlyPayment,DefaultPaymentCurrency);
end;

procedure TForm1.TGenAndSaveReportWorker.FinishGUI;
begin
  inherited;
  with Form1 do
  begin
    ProjectsListBoxSelectionChange(nil,false);
    Chromium.ChromiumBrowser.LoadString('<!DOCTYPE html><html><head><title></title></head><body></body></html>');
  end;
end;

{ TForm1 }

procedure TForm1.AddCredBtnClick(Sender: TObject);
begin                         
  DoParallelRequest(TAddCredentialWorker.Create());
end;

procedure TForm1.ChromiumInitTimerTimer(Sender: TObject);
begin
  ChromiumInitTimer.Enabled:=not(Chromium.CreateBrowser or Chromium.Initialized);
end;

procedure TForm1.CredentialListBoxSelectionChange(Sender: TObject; User: boolean);
var
  i:Integer;
begin
  ReportsListBox.Clear;
  Chromium.ChromiumBrowser.LoadString('<!DOCTYPE html><html><head><title></title></head><body></body></html>');
  for i:=0 to CredentialListBox.Count-1 do
    if CredentialListBox.Selected[i] then
    begin
      DoParallelRequest(TLoadCredWorker.Create(CredentialList[i]));
      exit;
    end;
  ProjectsListBox.Clear;
  ProjectsListBox.Enabled:=False;       
  UsersListBox.Clear;
  UsersListBox.Enabled:=False;
end;

procedure TForm1.ProjectsListBoxSelectionChange(Sender: TObject; User: boolean);
var
  i,i0:integer;
begin
  ReportsListBox.Clear;
  for i:=0 to ProjectsListBox.Count-1 do
    if ProjectsListBox.Selected[i] then
    begin
      with CurrCredential.ProjectsList[i] do
        for i0:=0 to ReportsList.Count-1 do
          ReportsListBox.AddItem(FormatDateTime('DD:MM:YYYY hh/mm/ss',ReportsList[i0].Date),nil);
      ReportsListBox.Enabled:=True;
      exit();
    end;
  ReportsListBox.Enabled:=False;
end;

procedure TForm1.ReportsListBoxSelectionChange(Sender: TObject; User: boolean);   
var
  i,i0:integer;
begin
  for i:=0 to ProjectsListBox.Count-1 do
    if ProjectsListBox.Selected[i] then
    begin
      with CurrCredential.ProjectsList[i] do
        for i0:=0 to ReportsList.Count-1 do
          if ReportsListBox.Selected[i0] then
          begin
            DoParallelRequest(TShowReportWorker.Create(ReportsList[i0]));       
            exit();
          end;
      exit();
    end;
end;

procedure TForm1.SyncProjBtnClick(Sender: TObject);
begin           
  DoParallelRequest(TSyncProjectsWorker.Create());
end;

procedure TForm1.SyncUsersBtnClick(Sender: TObject);
begin
  DoParallelRequest(TSyncUsersWorker.Create());
end;

procedure TForm1.UpdateUserBtnClick(Sender: TObject);
begin               
  DoParallelRequest(TCommitUserWorker.Create(CurrCredential.UsersList[UsersListBox.Selected.Index]));
end;

procedure TForm1.UsersListBoxSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  UpdateUserPanel.Enabled:=Selected;
  if Selected then
  begin
    SalaryPerHourSpin.Value:=CurrCredential.UsersList[Item.Index].SalaryPerHour;
    SalaryPerHourCurrencyEdit.Text:=CurrCredential.UsersList[Item.Index].SalaryPerHourCurrency;   
  end;
end;

procedure TForm1.GenNewReportBtnClick(Sender: TObject);   
var
  i:integer;
begin               
  for i:=0 to ProjectsListBox.Count-1 do
    if ProjectsListBox.Selected[i] then
    begin
      DoParallelRequest(TGenAndSaveReportWorker.Create(CurrCredential.ProjectsList[i]));
      exit;
    end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Connector);    
  FreeAndNil(CurrentWork);
  FreeAndNil(CredentialList);
end;

procedure TForm1.LoginMenuItemClick(Sender: TObject);
begin
  CurrCredential:=nil;
  LoginForm.ShowModal;
  if LoginForm.Result=1 then
  begin
    FreeAndNil(Connector);
    Connector:=LoginForm.Connector;
    LoginForm.Connector:=nil;
  end;
  CredentialListBox.Enabled:=Assigned(Connector);
  if Assigned(Connector) then
    DoParallelRequest(TUpdateCredentialsWorker.Create());
  CredentialListBoxSelectionChange(nil,false);
end;

procedure TForm1.Timer1Timer(Sender: TObject);  
Var
  tmp:double;
  tmp2:integer;
begin
  with DateTimeToTimeStamp(Now)do
    tmp:=(Time+Date*1000*60*60*24)/2000;
  tmp2:=trunc((tmp-trunc(tmp)-0.5)*2*360);
  if tmp2>=0 then
  begin
     Spiner.StartAngle:=0;
     Spiner.Position:=tmp2;
  end
  else
  begin    
     Spiner.StartAngle:=360+tmp2;
     Spiner.Position:=-tmp2;
  end;
  if CurrentWork.Finished then
  begin
    CurrentWork.FinishGUI;
    FreeAndNil(CurrentWork);
  end;
end;

procedure TForm1.DoParallelRequest(Request: TWorker);
begin
  CurrentWork:=Request;    
  CurrentWork.InitGUI;
  CurrentWork.Start;
end;

end.

