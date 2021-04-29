unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Winapi.Windows,
  ScktComp, FMX.Memo.Types, FMX.Edit, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
     procedure ClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure input(s:string);
    procedure output(s:string);

  end;

var
  Form1: TForm1;

implementation

uses suzie;

{$R *.fmx}

//Активация формы
procedure TForm1.Edit1Enter(Sender: TObject);
var
Layout: array[0.. KL_NAMELENGTH] of char;
begin
LoadKeyboardLayout( StrCopy(Layout,'00000419'),KLF_ACTIVATE);
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
if key = vk_return then
   Begin
memo1.Lines.Add('> '+edit1.text);
input(edit1.text);
edit1.Text := '';
   End;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  r : TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, Addr(r), 0);
  Form1.Left := r.Right-form1.Width-5;
  Form1.Top := r.Bottom-form1.Height-5;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
suzie.init;
end;

procedure TForm1.input(s:string);
begin
  suzie.parce(s);
end;

procedure TForm1.output(s:string);
begin
  memo1.Lines.Add('<'+s);
end;


procedure TForm1.ClientRead(Sender: TObject; Socket: TCustomWinSocket);
begin
memo1.Lines.Add('< '+socket.ReceiveText);
end;

end.
