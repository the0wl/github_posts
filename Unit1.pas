unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, System.JSON;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Rectangle1: TRectangle;
    Label6: TLabel;
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button2Click(Sender: TObject);
var
  arq: TextFile;
  linha: String;

begin
  AssignFile(arq, Edit1.Text);

  {$I-}
  Reset(arq);
  {$I+}

  while (not eof(arq)) do
  begin
   readln(arq, linha);

   Memo1.Lines.Add(linha);
  end;

  CloseFile(arq);
end;

end.
