program PMinesweeper;

uses
  Vcl.Forms,
  UMinesweeper in 'UMinesweeper.pas' {Minesweeper};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMinesweeper, Minesweeper);
  Application.Run;
end.
