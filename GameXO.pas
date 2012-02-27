program GameXO;

uses
  cwstring, cthreads, FMX_Forms,
  GameForm in 'GameForm.pas' {frmGame},
  GameXOImpl in 'GameXOImpl.pas',
  XOPoint in 'XOPoint.pas';

{.$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGame, frmGame);
  Application.Run;
end.
