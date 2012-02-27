unit GameXOImpl;

interface

uses
  SysUtils, Variants, Classes, XOPoint;

type

  TGameXOImpl = class
    private
      MovePatterns: array[0..4] of TXOPoint;
       //matched to external X/O/' '  layout button texts
      GamePane: array[0..2,0..2] of char;
      Moves: array[0..2,0..2] of byte;

      SignComputer: char;
      SignPlayer: char;
    protected
      procedure ResetGamePane();
      function AnalyzeTurn (Computer: Boolean; Step: Integer): Integer;
    public
      constructor Create();
      function ComputerTurn():TXOPoint;
      function CheckGameIsCompleted(Mark: Char):integer;
      procedure StartGame(PlayerSign: char);
      function PlayTurn(Turn:TXOPoint):integer;

      property ComputerSign : char read SignComputer ;
      property PlayerSign : char read SignPlayer;

  end;

implementation
{ TGameXOImpl }

(**
*   @Mark char X|O check win criteria for passed mark
*
*   return  -1 game in progress,  0 - nobody won, 1 - passed mark has won
*)
function TGameXOImpl.AnalyzeTurn(Computer: Boolean; Step: Integer): Integer;
var i, j, checkturn, weight, max: Integer;
begin
  max := -1;
  for i := 0 to 2 do
    for j := 0 to 2 do
    begin
      weight := -2;
      if GamePane[i,j] = ' ' then
      begin
        if Computer then begin
          GamePane[i,j] := self.SignComputer;
        end else begin
         GamePane[i,j] := self.SignPlayer;
        end;

        if Computer then checkturn := CheckGameIsCompleted(self.SignComputer)
                    else checkturn := CheckGameIsCompleted (self.SignPlayer);
        if (checkturn < 0) then begin
          weight := - AnalyzeTurn(not Computer, Step + 1);
        end else begin
          weight := checkturn;
        end;
        if (weight > Max) then begin
          max := weight;
        end;
        GamePane[i,j] := ' ';

        if ((max = 1) and (step > 0)) then
        begin
          Result := Max;
          break;
        end;
      end;
      if (Step = 0) then Moves[i,j] := weight;
    end;
  Result := Max;
end;

function TGameXOImpl.CheckGameIsCompleted(Mark: Char): integer;
var i, j: Integer;
    flagEmptyCellPresent,
    flagHorizontalFilled,
    flagVerticalFilled,
    flagDiagonal1Filled,
    flagDiagonal2Filled: Boolean;
begin
  Result:= -1;

  flagEmptyCellPresent := False;
  flagDiagonal1Filled := True;
  flagDiagonal2Filled := True;

  for i := 0 to 2 do
  begin
    flagHorizontalFilled := True;
    flagVerticalFilled := True;
    for j := 0 to 2 do
    begin
      if GamePane[i,j] = ' ' then flagEmptyCellPresent := True;
      if GamePane[i,j] <> Mark then flagHorizontalFilled := False;
      if GamePane[j,i] <> Mark then flagVerticalFilled := False;
    end;
    if  (flagHorizontalFilled or flagVerticalFilled) then
    begin
      Result := 1;
      break;
    end else
    if (GamePane[i,i] <> Mark) then flagDiagonal1Filled := False;
    if GamePane[2-i,i] <> Mark then flagDiagonal2Filled := False;
  end;
  if (Result < 0) then begin
    if (flagDiagonal1Filled or flagDiagonal2Filled) then begin
      Result:= 1;
    end else if (not flagEmptyCellPresent) then begin
      Result := 0;
    end;
  end;
end;

function TGameXOImpl.ComputerTurn: TXOPoint;
var max, i, j: Integer;
begin
  max := AnalyzeTurn (True, 0);
  repeat
    i := Random (3);
    j := Random (3);
  until ((Moves[i,j] = Max) and (GamePane[i,j]=' '));
  GamePane[i,j] := self.SignComputer;
  Result := TXOPoint.Create(i,j);
end; 

constructor TGameXOImpl.Create;
begin
  Randomize();
  MovePatterns[0] := TXOPoint.Create(0,0);
  MovePatterns[1] := TXOPoint.Create(0,2);
  MovePatterns[2] := TXOPoint.Create(1,1);
  MovePatterns[3] := TXOPoint.Create(2,2);
end;


function TGameXOImpl.PlayTurn(Turn: TXOPoint): integer;
begin
 if (GamePane[Turn.X,Turn.Y] = ' ') then
  begin
    GamePane[Turn.X,Turn.Y] := self.PlayerSign;
    Result := CheckGameIsCompleted(self.PlayerSign);
  end;
end;
(**
*  Resets game pane to initial state
*
*  return void
*)
procedure TGameXOImpl.ResetGamePane;
var i, j: byte;
begin
  for i := 0 to 2 do
    for j := 0 to 2 do
    begin
      GamePane[i,j] := ' ';
    end;
end;

(**
*  @PlayerSign  char X|O
*
*  returns TPoint if it is computer turn, nil otherwise
*)
procedure TGameXOImpl.StartGame(PlayerSign: char);
begin
  Randomize();
  self.SignPlayer := PlayerSign;
  if (PlayerSign='X') then begin
    self.SignComputer :='O';
  end else begin
    self.SignComputer:='X';
  end;

  ResetGamePane();

  if (self.SignComputer = 'X') then begin
  end;

end;


end.

