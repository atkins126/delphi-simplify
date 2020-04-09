unit nethttpDemo;
 {

 说明 ：
 1.本单元演示用 nethhtp控件完成网页访问
 2.nethhtp是delphi XE之后推出的基于winhttp的网页访问控件
 3. 网页访问需要
 3.1 网址 url
 3.2 设置协议头 headers
 3.3 设置 重定向 cookies等
 3.3 发起访问
 3.4 获取返回数据

 }
interface
uses
System.SysUtils,System.Classes,System.Net.URLClient,System.Net.HttpClient, System.Net.HttpClientComponent;
//这些是 nethttp所需要的引用单元
var

obj:TNetHTTPClient; //发起请求所需要的对象
url:string;         //请求地址
Manager:TCookieManager;//访问的cookies管理

resheader:TNetHeaders;//头信息
ReqData:TStringStream;//请求的流对象
str:string;         //发起请求的数据
ResData:TStringStream;//返回数据的流对象
str2:string;//返回的文本信息

resmsg:IHTTPResponse;//发送请求后的返回数据;
Hname:string;//协议头的name
Hvalue:string;//协议头的value
cookiesarr:TCookies; //返回的cookies
I:Integer;//获取单个cookies的索引



implementation
procedure initialize(); //顺序1 在访问之前调用
begin
//1. 构造请求对象 绑定cookies管理器
  obj:=TNetHTTPClient.Create(nil);
  Manager:=TCookieManager.Create;
  obj.CookieManager:= Manager;
//2. obj的重定向，cookies设置,访问模式
  //2.1 是否允许cookies
  obj.AllowCookies:=True;
  //2.2 是否允许重定向 和重定向次数
  obj.HandleRedirects:=True;
  obj.MaxRedirects:=20;
  //2.3设置访问模式,同步或异步
  obj.Asynchronous:=False;
  //2.4 设置超时
  obj.ConnectionTimeout:=1500;
  obj.ResponseTimeout:=1500;
//可选操作
//1 清楚cookies
Manager.Clear;


//3.设置协议头，编码，charset 一系列信息
 obj.Accept:='';
 obj.AcceptCharSet:='';
 obj.AcceptLanguage:='';
 obj.AcceptEncoding:='';
 obj.ContentType:='';
 obj.UserAgent:='';



end;

//顺序2 发起请求 以get方法和POST方法为例

procedure sendGetRequest();//顺序2 发起get请求
begin
  //1. 构造返回信息 并制定编码
  ResData:=TStringStream.Create('',TEncoding.UTF8);

  //2.发生请求
  resmsg:=obj.get(url,ResData,resheader);


end;

procedure sendPostRequest();//顺序2 发起post请求
begin
  //1. 构造返回信息 并制定编码

  ReqData:=TStringStream.Create(str,TEncoding.UTF8);
  ResData:=TStringStream.Create('',TEncoding.UTF8);

  //2.发生请求
  resmsg:=obj.post(url,ReqData,ResData);


end;

procedure getResponse();//顺序3 获取 返回的信息
begin
//1.获取返回的信息

  //1.1 从返回的流对象中取出字符串信息
  str2:=ResData.DataString;

//2.从返回的HTTPResponse中 取出信息

  //2.1 根据name获取返回的协议头值
  Hvalue:=resmsg.GetHeaderValue(Hname);

  //2.2 获取返回内容的char-set 返回值为字符串
  resmsg.GetContentCharSet;

  //2.3 获取返回内容的编码
   resmsg.GetContentEncoding;

  //2.4  获取返回内容的语言
   resmsg.GetContentLanguage;
  //2.5 获取返回内容的的长度
   resmsg.GetContentLength;
  //2.6 获取返回内容的日期
   resmsg.GetDate;
  //2.7 获取返回内容的最后变更
   resmsg.GetLastModified;
  //2.8 获取返回内容的状态
   resmsg.GetStatusCode;
  //2.9 获取返回内容的状态
   resmsg. GetStatusText;
  //2.10 获取返回内容的的http版本
   resmsg.GetVersion;
  //2.11 查找返回内容是否保含某协议头
  resmsg.ContainsHeader(Hname);
  //2.12 获取返回的cokies
   cookiesarr:=TCookies.Create;
   cookiesarr:=resmsg.GetCookies;
   //2.12.1获取单个的coookie
   for I := 0 to cookiesarr.Count-1 do
     begin
       cookiesarr.Items[0].ToString //获取单个cookies


     end;


end;

procedure afterResponse();//顺序4 完成访问后释放对象
begin
  obj.Free;
  Manager.Free;
  ReqData.Free;
  ResData.Free;
  cookiesarr.Free;


end;
end.
