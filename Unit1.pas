unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, System.JSON,
  FMX.Styles.Objects, FMX.Layouts;

type
  TForm1 = class(TForm)
    edPath: TEdit;
    lbPath: TLabel;
    Edit3: TEdit;
    cbCategory: TComboBox;
    meText: TMemo;
    Button1: TButton;
    Button2: TButton;
    pnScreenName: TLabel;
    pnPath: TPanel;
    recPath: TRectangle;
    pnTitle: TPanel;
    edTitle: TEdit;
    recTitle: TRectangle;
    lbTitle: TLabel;
    pnCategory: TPanel;
    recCategory: TRectangle;
    lbCategory: TLabel;
    pnTopBar: TRectangle;
    pnAbstract: TPanel;
    recAbstract: TRectangle;
    lbAbstract: TLabel;
    edAbstract: TEdit;
    pnText: TPanel;
    recText: TRectangle;
    lbText: TLabel;
    lySearchPath: TLayout;
    btSearchPath: TButton;
    lyTitle: TLayout;
    lyIndex: TLayout;
    edIndex: TEdit;
    lbIndex: TLabel;
    procedure edPathKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btSearchPathClick(Sender: TObject);
    procedure edIndexKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    GMasterObject: TJSONObject; // Contains all the Json

    procedure SearchJSONPath();
    procedure extractJsonInfo(JSON: String);
    procedure gPBI(pValue: Integer);
    function  rQM(pValue: String): String;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btSearchPathClick(Sender: TObject);
begin
  SearchJSONPath();
end;

procedure TForm1.edIndexKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    if GMasterObject <> nil then
    begin
      try
        gPBI(StrtoInt(edIndex.Text))
      except
        ShowMessage('O valor digitado no campo "' + TEdit(Sender).Hint + '" não é um inteiro.');
        edIndex.Text := '';
      end;
    end
  end;
end;

procedure TForm1.edPathKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    SearchJSONPath();
  end;
end;

procedure TForm1.SearchJSONPath();
var
  wArchive : TextFile;
  wLine    : String;
  wJSON    : String;

begin
  AssignFile(wArchive, edPath.Text);
  wLine := '';

  {$I-}
  Reset(wArchive); // Enter in edit mode of arquive 01/05/2019
  {$I+}

  while (not eof(wArchive)) do
  begin
    readln(wArchive, wLine);

    wJSON := wJSON + wLine;
  end;

  CloseFile(wArchive);

  extractJsonInfo(wJSON);
end;

procedure TForm1.extractJsonInfo(JSON: String);
var
  wCategories   : TJSONArray;
  i             : Integer;

begin
  GMasterObject := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
  wCategories   := GMasterObject.GetValue('categories') as TJSONArray;

  for i := 0 to wCategories.Count-1 do
    cbCategory.Items.Add(rQM(wCategories.Items[i].ToString));

  gPBI(0);
  edIndex.Enabled := True;
end;

procedure TForm1.gPBI(pValue: Integer);
var
  wPosts        : TJSONArray;
  wFirstPost    : TJSONObject;

begin
  wPosts          := GMasterObject.GetValue('posts') as TJSONArray;
  wFirstPost      := wPosts.Items[pValue] as TJSONObject;
  edIndex.Text    := pValue.ToString;
  edTitle.Text    := rQM(wFirstPost.GetValue('title').ToString);
  edAbstract.Text := rQM(wFirstPost.GetValue('abstract').ToString);
  meText.Text     := rQM(wFirstPost.GetValue('text').ToString);

  cbCategory.ItemIndex := cbCategory.Items.Indexof(rQM(wFirstPost.GetValue('category').ToString));
end;

function TForm1.rQM(pValue: String): String; // Remove quotation marks
begin
  Result := StringReplace(pValue, '"', '', [rfReplaceAll]);
end;

end.
