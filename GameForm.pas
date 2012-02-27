unit GameForm;

interface

uses
  SysUtils, Types, UITypes, Classes, Variants, FMX_Types, FMX_Controls, FMX_Forms,
  FMX_Dialogs, FMX_Grid, FMX_Layouts, FMX_Ani, GameXOImpl, XOPoint;

type
  TfrmGame = class(TForm)
    pnlNotification: TPanel;
    pnlGamePane: TPanel;
    glButtons: TGridLayout;
    f11: TButton;
    f12: TButton;
    f13: TButton;
    f21: TButton;
    f22: TButton;
    f23: TButton;
    f31: TButton;
    f32: TButton;
    f33: TButton;
    RoundAnimationf11: TFloatAnimation;
    Panel1: TPanel;
    btnPlayX: TButton;
    btnplayO: TButton;
    lblNotification: TLabel;
    procedure btnPlayXClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnplayOClick(Sender: TObject);
    procedure FieldClick(Sender: TObject);
  private
    { Private declarations }
    FGame: TGameXOImpl;
  protected
    procedure ClearSurface();
    procedure PerformComputerTurn();
    procedure AnimeThePoint (Point:TXOPoint);
  public
    { Public declarations }
  end;

var
  frmGame: TfrmGame;

implementation

{$R *.lfm}

{ TForm1 }

procedure TfrmGame.AnimeThePoint(Point: TXOPoint);
var
  Cmp: TComponent;
  Anim: TFloatAnimation;
begin
   Cmp := frmGame.FindComponent('RoundAnimationf'+inttostr(Point.X+1)+inttostr(Point.Y+1));
   if (Cmp<>nil) then begin
     Anim:=Cmp as TFloatAnimation;
     Anim.Start();
   end;

end;

procedure TfrmGame.btnplayOClick(Sender: TObject);
begin
  ClearSurface();
  FGame.StartGame('O');
  PerformComputerTurn();
end;

procedure TfrmGame.btnPlayXClick(Sender: TObject);
begin
  ClearSurface();

  FGame.StartGame('X');
end;

procedure TfrmGame.ClearSurface;
var
  i:integer;
  currButt:TButton;
begin

  lblNotification.Text := 'So, who will be a winner?';
  for i := 0 to glButtons.ChildrenCount-1 do begin
     CurrButt :=  glButtons.Children[i] as TButton;
     CurrButt.Text:='?';
  end;

end;

procedure TfrmGame.FieldClick(Sender: TObject);
var
  button: TButton;
  Move: TXOPoint;
  Result: integer;
begin
  button := Sender as TButton;
  if (button.Text <> '?') then begin
    lblNotification.Text := 'CELL IS OCCUPIED';
    exit;
  end;
  Move := TXOPoint.Create(0,0);
  Move.X := StrToInt(button.Name[2])-1;
  Move.Y := StrToInt(button.Name[3])-1;
  button.Text := FGame.PlayerSign;
  AnimeThePoint(Move);
  FGame.PlayTurn(Move);
  lblNotification.Text := '';
  Result:=FGame.CheckGameIsCompleted(FGame.PlayerSign);
  case Result of
    -1: begin
       lblNotification.Text := 'You: ('+IntToStr(Move.X)+','+IntToStr(Move.Y)+')';
       PerformComputerTurn();
    end;
    0:  begin
          lblNotification.Text := 'Good, noone. Once more?';
        end;
    1:  begin
        lblNotification.Text := 'Greeting! You won';
    end;
  end;
end;

procedure TfrmGame.FormCreate(Sender: TObject);
begin
  self.FGame :=TGameXOImpl.Create();
end;

procedure TfrmGame.PerformComputerTurn;
var Turn: TXOPoint;
  Target: TComponent;
  Button: TButton;
  Result: integer;
begin
  Turn := FGame.ComputerTurn;
  AnimeThePoint(Turn);
  Target := frmGame.FindComponent('f'+IntToStr(Turn.X+1)+IntToStr(Turn.Y+1));
  Button := Target as TButton;
  Button.Text :=  FGame.ComputerSign;
  lblNotification.Text := lblNotification.Text + ' cmp:('+IntToStr(Turn.X)+','+IntToStr(Turn.Y)+')';
  Result := FGame.CheckGameIsCompleted(FGame.ComputerSign);
  case Result of
    
    0:  begin
          lblNotification.Text := 'Good, noone. Once more?';
        end;
    1:  begin
        lblNotification.Text := 'Heh! I WON!';
        end;
    end;

end;

end.
