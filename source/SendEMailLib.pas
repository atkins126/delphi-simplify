unit SendEMailLib;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  IdMessage,
  IdSMTP,
  IdAttachmentFile,
  IdAntiFreeze;

var
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdAntiFreeze:TIdAntiFreeze; //indy为堵塞式，加上这个组件让界面不会假死

procedure ConnectToSMTPserver(Host:string;Port:Word;UserName,PassWord:string;MaxWaitTime:DWord = 300000);
procedure DisconnectToSMTPserver;  //断开发信服务器
procedure SendEMail(Subject,Body,RecipientsEMailAddresses:string);  //发送邮件
procedure AddAttachmentFile(FileAddress:string);  //添加附件文件
procedure ClearAllAttachments;  //清除所有附件

implementation

procedure ConnectToSMTPserver(Host:string;Port:Word;UserName,PassWord:string;MaxWaitTime:DWord = 300000);
var       //连接发信服务器
  OldGetTickCount:DWORD;
begin
  IdSMTP := TIdSMTP.Create();
  IdMessage := TIdMessage.Create();
  IdAntiFreeze := TIdAntiFreeze.Create();
  IdAntiFreeze.OnlyWhenIdle := False;
  OldGetTickCount := GetTickCount;
  IdSMTP.Host:= Host;
  IdSMTP.Port:= Port;
  IdSMTP.Username:= UserName;
  IdSMTP.Password:= PassWord;
  try
    IdSMTP.Connect;
    idSMTP.Authenticate;
    if (GetTickCount - OldGetTickCount > MaxWaitTime) then raise Exception.Create('Error Message');
    //超过最长等待时间则报错
  except
    MessageBox(0,'已自动断开连接，请重新连接服务器！','连接发信服务器失败！',MB_OK + MB_ICONSTOP);
    idSMTP.Disconnect;
    IdSMTP.Free;
    IdMessage.Free;
    IdAntiFreeze.Free;
  end;
end;

procedure DisconnectToSMTPserver;  //断开发信服务器
begin
  IdSMTP.Disconnect();
  IdSMTP.Free;
  IdMessage.Free;
  IdAntiFreeze.Free;
end;

procedure SendEMail(Subject,Body,RecipientsEMailAddresses:string);  //发送邮件
begin
  try
    IdMessage.From.Address := IdSMTP.Username;                       //发件人地址
    IdMessage.Recipients.EMailAddresses:= RecipientsEMailAddresses;  //收件人地址
    IdMessage.Subject:= Subject;                                     //邮件标题
    IdMessage.CharSet:= 'UTF-8';
    IdMessage.Body.Clear;
    IdMessage.Body.Add(Body);                                        //发送内容
    IdMessage.Priority:= mpHigh;                                     //优先级
    IdSMTP.Send(IdMessage);                                          //发送邮件
    MessageBox(0, '您可以选择发送下一封邮件或者断开连接。', '发送邮件成功！', MB_OK + MB_ICONINFORMATION);
  except
    on E:Exception do
    begin
      MessageBox(0, PWideChar('错误信息：' + E.Message), '发送邮件失败！', MB_OK + MB_ICONSTOP);
    end;
  end;
end;

procedure AddAttachmentFile(FileAddress:string);  //添加附件文件
begin
  try
    TIdAttachmentFile.Create(IdMessage.MessageParts,FileAddress);
  except
    on E:Exception do
    begin
      MessageBox(0, PWideChar('错误信息：' + E.Message), '添加附件失败！', MB_OK + MB_ICONSTOP);
    end;
  end;
end;

procedure ClearAllAttachments;  //清除所有附件
begin
  IdMessage.MessageParts.Clear;
end;
end.
