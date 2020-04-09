unit nethttpDemo;
 {

 ˵�� ��
 1.����Ԫ��ʾ�� nethhtp�ؼ������ҳ����
 2.nethhtp��delphi XE֮���Ƴ��Ļ���winhttp����ҳ���ʿؼ�
 3. ��ҳ������Ҫ
 3.1 ��ַ url
 3.2 ����Э��ͷ headers
 3.3 ���� �ض��� cookies��
 3.3 �������
 3.4 ��ȡ��������

 }
interface
uses
System.SysUtils,System.Classes,System.Net.URLClient,System.Net.HttpClient, System.Net.HttpClientComponent;
//��Щ�� nethttp����Ҫ�����õ�Ԫ
var

obj:TNetHTTPClient; //������������Ҫ�Ķ���
url:string;         //�����ַ
Manager:TCookieManager;//���ʵ�cookies����

resheader:TNetHeaders;//ͷ��Ϣ
ReqData:TStringStream;//�����������
str:string;         //�������������
ResData:TStringStream;//�������ݵ�������
str2:string;//���ص��ı���Ϣ

resmsg:IHTTPResponse;//���������ķ�������;
Hname:string;//Э��ͷ��name
Hvalue:string;//Э��ͷ��value
cookiesarr:TCookies; //���ص�cookies
I:Integer;//��ȡ����cookies������



implementation
procedure initialize(); //˳��1 �ڷ���֮ǰ����
begin
//1. ����������� ��cookies������
  obj:=TNetHTTPClient.Create(nil);
  Manager:=TCookieManager.Create;
  obj.CookieManager:= Manager;
//2. obj���ض���cookies����,����ģʽ
  //2.1 �Ƿ�����cookies
  obj.AllowCookies:=True;
  //2.2 �Ƿ������ض��� ���ض������
  obj.HandleRedirects:=True;
  obj.MaxRedirects:=20;
  //2.3���÷���ģʽ,ͬ�����첽
  obj.Asynchronous:=False;
  //2.4 ���ó�ʱ
  obj.ConnectionTimeout:=1500;
  obj.ResponseTimeout:=1500;
//��ѡ����
//1 ���cookies
Manager.Clear;


//3.����Э��ͷ�����룬charset һϵ����Ϣ
 obj.Accept:='';
 obj.AcceptCharSet:='';
 obj.AcceptLanguage:='';
 obj.AcceptEncoding:='';
 obj.ContentType:='';
 obj.UserAgent:='';



end;

//˳��2 �������� ��get������POST����Ϊ��

procedure sendGetRequest();//˳��2 ����get����
begin
  //1. ���췵����Ϣ ���ƶ�����
  ResData:=TStringStream.Create('',TEncoding.UTF8);

  //2.��������
  resmsg:=obj.get(url,ResData,resheader);


end;

procedure sendPostRequest();//˳��2 ����post����
begin
  //1. ���췵����Ϣ ���ƶ�����

  ReqData:=TStringStream.Create(str,TEncoding.UTF8);
  ResData:=TStringStream.Create('',TEncoding.UTF8);

  //2.��������
  resmsg:=obj.post(url,ReqData,ResData);


end;

procedure getResponse();//˳��3 ��ȡ ���ص���Ϣ
begin
//1.��ȡ���ص���Ϣ

  //1.1 �ӷ��ص���������ȡ���ַ�����Ϣ
  str2:=ResData.DataString;

//2.�ӷ��ص�HTTPResponse�� ȡ����Ϣ

  //2.1 ����name��ȡ���ص�Э��ͷֵ
  Hvalue:=resmsg.GetHeaderValue(Hname);

  //2.2 ��ȡ�������ݵ�char-set ����ֵΪ�ַ���
  resmsg.GetContentCharSet;

  //2.3 ��ȡ�������ݵı���
   resmsg.GetContentEncoding;

  //2.4  ��ȡ�������ݵ�����
   resmsg.GetContentLanguage;
  //2.5 ��ȡ�������ݵĵĳ���
   resmsg.GetContentLength;
  //2.6 ��ȡ�������ݵ�����
   resmsg.GetDate;
  //2.7 ��ȡ�������ݵ������
   resmsg.GetLastModified;
  //2.8 ��ȡ�������ݵ�״̬
   resmsg.GetStatusCode;
  //2.9 ��ȡ�������ݵ�״̬
   resmsg. GetStatusText;
  //2.10 ��ȡ�������ݵĵ�http�汾
   resmsg.GetVersion;
  //2.11 ���ҷ��������Ƿ񱣺�ĳЭ��ͷ
  resmsg.ContainsHeader(Hname);
  //2.12 ��ȡ���ص�cokies
   cookiesarr:=TCookies.Create;
   cookiesarr:=resmsg.GetCookies;
   //2.12.1��ȡ������coookie
   for I := 0 to cookiesarr.Count-1 do
     begin
       cookiesarr.Items[0].ToString //��ȡ����cookies


     end;


end;

procedure afterResponse();//˳��4 ��ɷ��ʺ��ͷŶ���
begin
  obj.Free;
  Manager.Free;
  ReqData.Free;
  ResData.Free;
  cookiesarr.Free;


end;
end.
