unit ReadAndWriteIniFiles;

interface

uses
 Winapi.Windows,
 System.SysUtils,
 System.IniFiles,
 System.StrUtils;

const
  ImproperCommand:array[0..8] of Char = ( '<' , '>' , '/' , '\' , '|' , ':' , '"' , '*' , '?' );

var
  Ini:TIniFile;

procedure WriteIniFile(Path,Section,Key,Value:string);
function ReadIniFile(Path,Section,Key:string;DefaultText:string = ''):string;

implementation

procedure WriteIniFile(Path,Section,Key,Value:string);
var
  Path1,IniFileName:string;
  RecordCount:Byte;
begin
  Path1 := LowerCase(Path);  //文件路径转为小写方便处理
  try
    if (Pos(':\',Path1) = 0) and (Pos('.ini',Path1) <> 0)  then
    //ini目录输错或只输入了ini文件名则默认创建在exe目录下
    begin
      Path1 := Path;  //复原原文件路径确保ini文件名大小写不会变
      if Pos('\',Path1) <> 0 then
      begin
        Path1 := ReverseString(Path1);
        Path1 := Copy(Path1,1,Pos('\',Path1) - 1);
        IniFileName := ReverseString(Path1);
        Path1 := GetCurrentDir + '\' + ReverseString(Path1);
      end
      else
      begin
        IniFileName := Path1;
        Path1 := GetCurrentDir + '\' + Path1;
      end;
    end
    else
    begin
      Path1 := ReverseString(Path1);
      Path1 := Copy(Path1,1,Pos('\',Path1) - 1);
      IniFileName := ReverseString(Path1);
    end;

    for RecordCount := 0 to 8 do  //检测非法字符
    begin
      if Pos(ImproperCommand[RecordCount],IniFileName) <> 0 then
      begin
        MessageBox(0, '非法字符：< > / \ | : " * ?', '文件名称中存在非法字符！', MB_OK + MB_ICONSTOP);
        Exit;
      end;
    end;
    Ini := TIniFile.Create(Path1);
    Ini.WriteString(Section,Key,Value);
    Ini.Free;
  except
    on E:Exception do
    begin
      if (Ini <> nil) then Ini.Free;
      MessageBox(0, PWideChar('错误信息：' + E.Message), '写配置项错误！', MB_OK + MB_ICONSTOP);
    end;
  end;

end;

function ReadIniFile(Path,Section,Key:string;DefaultText:string = ''):string;
var
  Path1:string;
begin
  try
    Path1 := Path;
    if (Pos('.ini',Path1) <> 0) and (Pos('\',Path1) = 0) then Path1 := GetCurrentDir + '\' + Path;
    Ini := TIniFile.Create(Path1);
    Result := Ini.ReadString(Section,Key,DefaultText);
    Ini.Free
  except
    on E:Exception do
    begin
      if (Ini <> nil) then Ini.Free;
      MessageBox(0, PWideChar('错误信息：' + E.Message), '读配置项错误！', MB_OK + MB_ICONSTOP);
    end;
  end;
end;

end.
