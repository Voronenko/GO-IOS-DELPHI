unit XOPoint;

interface

type TXOPoint = class
    public
      X: integer;
      Y: integer;
      constructor Create(x:integer; y:integer);
  end;

implementation



constructor TXOPoint.Create(x, y: integer);
begin
  self.X := x;
  self.Y := y;
end;


end.
