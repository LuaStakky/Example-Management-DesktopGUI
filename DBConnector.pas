unit DBConnector;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, IdHTTP, IdStack, fpjson, fgl, IdGlobal, DateUtils, lazlogger;

type
  EDBCNoSession=class(Exception);

  TDBConnector=class;
  TProject=class;

  TUserType=(UTGroup,UTUser);
  TSalaryCurrency=String[3];

  TReport=class
    private       
      Connector:TDBConnector;    
      Project:TProject;
    public            
      ID:integer;
      Date:TDateTime;
      function GetHTML:String;
      constructor Create(AConnector:TDBConnector;AProject:TProject;JSON:TJSONData);
  end;

  TReportsList=TFPGObjectList<TReport>;

  TUser=class
    private
      Connector:TDBConnector;
    public
      ID:Integer;
      Name:String;
      &Type:TUserType;       
      SalaryPerHour:Double;
      SalaryPerHourCurrency:TSalaryCurrency;
      constructor Create(AConnector:TDBConnector;JSON:TJSONData);
      procedure CommitChanges();
  end;

  TUsersList=TFPGObjectList<TUser>;

  TProject=class  
    private
      Connector:TDBConnector;  
      procedure UpdateReportsList;
    public               
      ID,CredID:Integer;
      Name:String;
      ReportsList:TReportsList;
      constructor Create(AConnector:TDBConnector;ACredID:Integer;JSON:TJSONData);
      procedure GenAndSaveReport(ResultCurrency:TSalaryCurrency;DefaultHoursPerIssue,DefaultHourlyPayment:Double;
        DefaultPaymentCurrency:TSalaryCurrency);
      destructor Destroy; override;
  end;

  TProjectList=TFPGObjectList<TProject>;

  TCredential=class
    private
      Password:String;   
      Connector:TDBConnector;     
      procedure UpdateProjectsList();
      procedure UpdateUsersList();
    public
      ID:Integer;
      Url,Login:string;   
      ProjectsList:TProjectList;
      UsersList:TUsersList;
      constructor Create(AConnector:TDBConnector;AID:Integer;AUrl,ALogin,APassword:string);
      procedure SyncProjects();
      procedure SyncUsers();      
      destructor Destroy;override;
  end;

  TCredentialInfo=class
    private                  
      Password:String;
      Connector:TDBConnector;
      FCredential:TCredential;
      function GetCredential:TCredential;
    public              
      ID:Integer;
      Url,Login:string;
      constructor Create(AConnector:TDBConnector;JSON:TJSONData);overload;
      constructor Create(AConnector:TDBConnector;AID:Integer;AUrl,ALogin,APassword:string);
      property Credential:TCredential read GetCredential;
      destructor Destroy; override;
  end;

  TCreditalList=TFPGObjectList<TCredentialInfo>;

  TDBConnector=class
    private
      IdHTTP:TIdHTTP;
      BaseURI:string;
      FSession:string;
      function GetSession:string;    
      function GetLastResponseCode:Integer;
      function Request(name:string;Req:TJSONObject):String;
    public
      constructor Create(ABaseURI:string);

      function TestConnection():boolean;   
      function Login(Email,Password:string):boolean;

      function GetRedmineCredentialsList():TCreditalList;
      function AddRedmineCredentials(Url,Login,Password:string):TCredentialInfo;

      destructor Destroy; override;
      property Session:string read GetSession;    
      property LastResponseCode:Integer read GetLastResponseCode;
  end;

implementation

//TReport

constructor TReport.Create(AConnector:TDBConnector;AProject:TProject;JSON:TJSONData);
begin
  Connector:=AConnector;
  Project:=AProject;
  ID:=JSON.GetPath('ID').AsInteger;
  Date:=DateUtils.ISO8601ToDate(JSON.GetPath('Date').AsString,False);
end;

function TReport.GetHTML:String;
begin
  try
    Result:=Connector.Request('GetReport',TJSONObject.Create(['Session',Connector.Session,'ID',ID]));
  except
  end;
end;

//TUser

constructor TUser.Create(AConnector:TDBConnector;JSON:TJSONData);
begin
  Connector:=AConnector;
  ID:=JSON.GetPath('ID').AsInteger;
  if JSON.GetPath('Type').AsString='User' then
    &Type:=UTUser
  else
    &Type:=UTGroup;
  Name:=JSON.GetPath('Name').AsString;
  try
    SalaryPerHour:=JSON.GetPath('SalaryPerHour').AsFloat;
  except
    SalaryPerHour:=1;
  end;        
  try
    SalaryPerHourCurrency:=JSON.GetPath('SalaryPerHourCurrency').AsString;
  except                                         
    SalaryPerHourCurrency:='USD';
  end;
end;

procedure TUser.CommitChanges();
begin                      
  try
    Connector.Request('UpdateRedmineUser',TJSONObject.Create(['Session',Connector.Session,'ID',ID,
                      'SalaryPerHour',SalaryPerHour,
                      'SalaryPerHourCurrency',SalaryPerHourCurrency]));
  except
  end;
end;

//TProject

constructor TProject.Create(AConnector:TDBConnector;ACredID:Integer;JSON:TJSONData);
begin     
  Connector:=AConnector;         
  CredID:=ACredID;
  ID:=JSON.GetPath('ID').AsInteger;
  Name:=JSON.GetPath('Name').AsString;
  ReportsList:=TReportsList.Create();
  UpdateReportsList();
end;

procedure TProject.UpdateReportsList;     
var
  s:TJSONData;
  i:TJSONEnum;
begin
  ReportsList.Clear;
  try
    s:=GetJSON(Connector.Request('GetReportsList',TJSONObject.Create(['Session',Connector.Session,'CredID',CredID,'ProjectID',ID])));
    try
      if Connector.LastResponseCode=200 then
        for i in s do
          ReportsList.Add(TReport.Create(Connector,self,i.Value));
    finally
      FreeAndNil(s);
    end;
  except
  end;
end;

procedure TProject.GenAndSaveReport(ResultCurrency:TSalaryCurrency;DefaultHoursPerIssue,DefaultHourlyPayment:Double;
        DefaultPaymentCurrency:TSalaryCurrency);
var
  s:TJSONData;
begin
   try
    s:=GetJSON(Connector.Request('GenAndSaveReport',TJSONObject.Create(['Session',Connector.Session,'ProjectID',ID,
      'ResultCurrency',ResultCurrency,'DefaultHoursPerIssue',DefaultHoursPerIssue,
      'DefaultHourlyPayment',DefaultHourlyPayment,'DefaultPaymentCurrency',DefaultPaymentCurrency])));
    try
      if Connector.LastResponseCode=200 then
        ReportsList.Add(TReport.Create(Connector,self,s));
    finally
      FreeAndNil(s);
    end;
  except
  end;
end;

destructor TProject.Destroy();
begin
  FreeAndNil(ReportsList);
end;

//TCredital

constructor TCredential.Create(AConnector:TDBConnector;AID:Integer;AUrl,ALogin,APassword:string);
begin          
  Connector:=AConnector;
  ID:=AID;
  Url:=AUrl;   
  Login:=ALogin;
  Password:=APassword;
  ProjectsList:=TProjectList.Create();    
  UsersList:=TUsersList.Create();
  UpdateProjectsList();
  UpdateUsersList();
end;

procedure TCredential.UpdateProjectsList();
var
  s:TJSONData;
  i:TJSONEnum;
begin
  ProjectsList.Clear;
  try
    s:=GetJSON(Connector.Request('RedmineProjectsList',TJSONObject.Create(['Session',Connector.Session,'CredID',ID])));
    try
      if Connector.LastResponseCode=200 then
      begin
        for i in s do
          if not i.Value.GetPath('WasRemovedFromRedmine').AsBoolean then
            ProjectsList.Add(TProject.Create(Connector,ID,i.Value));
      end;
    finally
      FreeAndNil(s);
    end;
  except
  end;
end;

procedure TCredential.UpdateUsersList();      
var
  s:TJSONData;
  i:TJSONEnum;
begin    
  UsersList.Clear;
  try
    s:=GetJSON(Connector.Request('RedmineUsersList',TJSONObject.Create(['Session',Connector.Session,'CredID',ID])));
    try
      if Connector.LastResponseCode=200 then
      begin
        for i in s do
          if not i.Value.GetPath('WasRemovedFromRedmine').AsBoolean then
            UsersList.Add(TUser.Create(Connector,i.Value));
      end;
    finally
      FreeAndNil(s);
    end;
  except
  end;
end;

procedure TCredential.SyncProjects();
begin
  try
    Connector.Request('RedmineProjectsSync',TJSONObject.Create(['Session',Connector.Session,'CredID',ID]));
  except
  end;     
  UpdateProjectsList();
end;

procedure TCredential.SyncUsers();
begin
  try
    Connector.Request('RedmineUsersSync',TJSONObject.Create(['Session',Connector.Session,'CredID',ID]));
  except
  end;        
  UpdateUsersList();
end;

destructor TCredential.Destroy;
begin
  FreeAndNil(ProjectsList);
  FreeAndNil(UsersList);
end;

//TCredentialInfo
function TCredentialInfo.GetCredential:TCredential;
begin
  if not Assigned(FCredential) then
    FCredential:=TCredential.Create(Connector,ID,Url,Login,Password);
  Result:=FCredential;
end;

constructor TCredentialInfo.Create(AConnector:TDBConnector;JSON:TJSONData);   
begin        
  Connector:=AConnector;
  ID:=JSON.GetPath('ID').AsInteger;
  Url:=JSON.GetPath('Url').AsString;
  Login:=JSON.GetPath('Login').AsString;
  Password:=JSON.GetPath('Password').AsString;
end;

constructor TCredentialInfo.Create(AConnector:TDBConnector;AID:Integer;AUrl,ALogin,APassword:string);    
begin
  Connector:=AConnector;
  ID:=AID;
  Url:=AUrl;
  Login:=ALogin;
  Password:=APassword;
end;

destructor TCredentialInfo.Destroy;
begin
  FreeAndNil(FCredential);
end;

//TDBConnector

function TDBConnector.Request(name:string;Req:TJSONObject):String;
var
  ReqStream:TMemoryStream;
begin
  ReqStream:=TMemoryStream.Create();
  try                           
    Req.DumpJSON(ReqStream);
    Result:=IdHTTP.Post('http://'+BaseURI+'/api/'+name,ReqStream);
  finally   
    FreeAndNil(ReqStream);
    FreeAndNil(Req);
  end;
  DebugLn(Result);
end;

function TDBConnector.GetSession:string;
begin
  if FSession='' then
    raise EDBCNoSession.Create('Error: no session')
  else
    Result:=FSession;
end;

function TDBConnector.GetLastResponseCode:Integer;
begin
  Result:=IdHTTP.ResponseCode;
end;

constructor TDBConnector.Create(ABaseURI:string);
begin
  IdHTTP:=TIdHTTP.Create;
  IdHTTP.HTTPOptions:=IdHTTP.HTTPOptions+[hoNoProtocolErrorException,hoKeepOrigProtocol];
  IdHTTP.Request.Accept:='*/*';
  IdHTTP.ProtocolVersion:=pv1_1;
  BaseURI := ABaseURI;
end;  

function TDBConnector.TestConnection():boolean;
begin                     
  Result:=True;
  try
    IdHTTP.Get('http://'+BaseURI);
  except
    Result:=False;
  end;
end;       

function TDBConnector.Login(Email,Password:string):boolean;
var
  s:string;
begin
  Result:=True;
  try
    s:=Request('Login',TJSONObject.Create(['Email',Email,'Password',Password]));
    if IdHTTP.ResponseCode=200 then
      FSession:=s
    else
      Result:=False;
  except
    Result:=False;
  end;
end;

function TDBConnector.GetRedmineCredentialsList():TCreditalList;
var
  s:TJSONData;
  i:TJSONEnum;
begin
  Result:=nil;
  try
    s:=GetJSON(Request('GetRedmineCredentialsList',TJSONObject.Create(['Session',Session])));
    try
      if IdHTTP.ResponseCode=200 then
      begin
        Result:=TCreditalList.Create();
        for i in s do
          Result.Add(TCredentialInfo.Create(self,i.Value));
      end;
    finally
      FreeAndNil(s);
    end;
  except
  end;
end;

function TDBConnector.AddRedmineCredentials(Url,Login,Password:string):TCredentialInfo;
var
  s:TJSONData;
begin
  Result:=nil;
  try
    s:=GetJSON(Request('AddRedmineCredentials',TJSONObject.Create(['Session',Session,'Url',Url,'Login',Login,'Password',Password])));
    try
      if IdHTTP.ResponseCode=200 then
        Result:=TCredentialInfo.Create(self,s.GetPath('NewID').AsInteger,Url,Login,Password);
    finally
      FreeAndNil(s);
    end;
  except
  end;
end;

destructor TDBConnector.Destroy;
begin
  FreeAndNil(IdHTTP);
end;

initialization          
GIdDefaultTextEncoding := encUTF8;
end.

