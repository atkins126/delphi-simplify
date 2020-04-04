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
  IdAntiFreeze:TIdAntiFreeze; //indyΪ����ʽ�������������ý��治�����

procedure ConnectToSMTPserver(Host:string;Port:Word;UserName,PassWord:string;MaxWaitTime:DWord = 300000);
procedure DisconnectToSMTPserver;  //�Ͽ����ŷ�����
procedure SendEMail(Subject,Body,RecipientsEMailAddresses:string);  //�����ʼ�
procedure AddAttachmentFile(FileAddress:string);  //��Ӹ����ļ�
procedure ClearAllAttachments;  //������и���

implementation

procedure ConnectToSMTPserver(Host:string;Port:Word;UserName,PassWord:string;MaxWaitTime:DWord = 300000);
var       //���ӷ��ŷ�����
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
    //������ȴ�ʱ���򱨴�
  except
    MessageBox(0,'���Զ��Ͽ����ӣ����������ӷ�������','���ӷ��ŷ�����ʧ�ܣ�',MB_OK + MB_ICONSTOP);
    idSMTP.Disconnect;
    IdSMTP.Free;
    IdMessage.Free;
    IdAntiFreeze.Free;
  end;
end;

procedure DisconnectToSMTPserver;  //�Ͽ����ŷ�����
begin
  IdSMTP.Disconnect();
  IdSMTP.Free;
  IdMessage.Free;
  IdAntiFreeze.Free;
end;

procedure SendEMail(Subject,Body,RecipientsEMailAddresses:string);  //�����ʼ�
begin
  try
    IdMessage.From.Address := IdSMTP.Username;                       //�����˵�ַ
    IdMessage.Recipients.EMailAddresses:= RecipientsEMailAddresses;  //�ռ��˵�ַ
    IdMessage.Subject:= Subject;                                     //�ʼ�����
    IdMessage.CharSet:= 'UTF-8';
    IdMessage.Body.Clear;
    IdMessage.Body.Add(Body);                                        //��������
    IdMessage.Priority:= mpHigh;                                     //���ȼ�
    IdSMTP.Send(IdMessage);                                          //�����ʼ�
    MessageBox(0, '������ѡ������һ���ʼ����߶Ͽ����ӡ�', '�����ʼ��ɹ���', MB_OK + MB_ICONINFORMATION);
  except
    on E:Exception do
    begin
      MessageBox(0, PWideChar('������Ϣ��' + E.Message), '�����ʼ�ʧ�ܣ�', MB_OK + MB_ICONSTOP);
    end;
  end;
end;

procedure AddAttachmentFile(FileAddress:string);  //��Ӹ����ļ�
begin
  try
    TIdAttachmentFile.Create(IdMessage.MessageParts,FileAddress);
  except
    on E:Exception do
    begin
      MessageBox(0, PWideChar('������Ϣ��' + E.Message), '��Ӹ���ʧ�ܣ�', MB_OK + MB_ICONSTOP);
    end;
  end;
end;

procedure ClearAllAttachments;  //������и���
begin
  IdMessage.MessageParts.Clear;
end;
end.
