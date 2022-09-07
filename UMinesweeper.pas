unit UMinesweeper;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Menus;

type
  TMinesweeper = class(TForm)
    LabelMinesLeft: TLabel;
    LabelMinesLeftValue: TLabel;
    LabelSquaresLeft: TLabel;
    LabelSquaresLeftValue: TLabel;
    StringGrid: TStringGrid;
    WinLoseLabel: TLabel;
    OKButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGridOnClick(Sender: TObject);
    procedure StringGridOnDblClick(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
  private
    { Private declarations }
    procedure CellValuesAssign(var MinesValuesChar: char);
    procedure BlankCheck;
    procedure Setup;
    procedure MinesGeneration;
    procedure NumberAssignment;
    procedure CreateArray;
    procedure StringGridHash;
    procedure Lose;
    procedure Win;
    procedure MinesLeftCounter;
    procedure SquaresLeftCounter;
  public
    { Public declarations }
    MinesLeft, SquaresLeft, RowSelected, ColumnSelected: Integer;
    MinesValues: array [0 .. 29, 0 .. 29] of char;
    MinesValuesChar: char;
    MinesValuesString: string;
    DoBlankCheck: boolean;

  end;

var
  Minesweeper: TMinesweeper;

implementation

{$R *.dfm}

procedure TMinesweeper.MinesLeftCounter;
{ this counts the number of mines left, indicated by the number of flagged cells
  taken away from the total number of mines }
var
  I, MineCount, J: Integer;
begin
  MineCount := 100; // sets the total number of mines to 100
  for I := 0 to 29 do
  begin
    for J := 0 to 29 do
    begin
      if StringGrid.Cells[I, J] = '🏳' then
        MineCount := MineCount - 1;
      // if the cell at (i,j) is flagged then the number of mines left is decreased
    end;
  end;
  LabelMinesLeftValue.Caption := inttostr(MineCount);
  // the label is changed to say the number of mines left
end;

procedure TMinesweeper.SquaresLeftCounter;
{ this counts the number of cells that haven't been clicked on }
var
  I, HashCount, J: Integer;
begin
  HashCount := 0; // sets the number of hashes to zero
  for I := 0 to 29 do
  begin
    for J := 0 to 29 do
    begin
      if StringGrid.Cells[I, J] = '#' then
        HashCount := HashCount + 1;
      // if the cell at (i,j) is a hash, then the number of hashes is increased
    end;
  end;
  LabelSquaresLeftValue.Caption := inttostr(HashCount);
  // the number of hashes it outputted to the label
end;

procedure TMinesweeper.Lose;
{ this is run when the user has lost }
var
  I, J: Integer;
begin
  StringGrid.Enabled := False; // the stringgrid is disabled
  WinLoseLabel.Caption := 'You lose!';
  WinLoseLabel.Font.Color := clRed;
  WinLoseLabel.Visible := True;
  // the user is told they have lost, the font is made red and the label becomes visible
  OKButton.Visible := True; // the ok button is made visible
  for I := 0 to 29 do
  begin
    for J := 0 to 29 do
    begin
      if (MinesValues[I, J] = 'm') and
        ((StringGrid.Cells[I, J] = '#') or (StringGrid.Cells[I, J] = '🏳')) then
        StringGrid.Cells[I, J] := '💣'
        // shows all the mines
    end;
  end;
end;

procedure TMinesweeper.Win;
{ this procedure is run when the user has won }
var
  RowWin, HashCount, CorrectMines, ColWin: Integer;
begin
  HashCount := 0;
  CorrectMines := 0;
  for RowWin := 0 to 29 do
  begin
    for ColWin := 0 to 29 do
    begin
      if StringGrid.Cells[ColWin, RowWin] = '#' then
        HashCount := HashCount + 1
    end;
  end;
  // checks that there are no hashes left on the grid
  if HashCount = 0 then
  begin
    for RowWin := 0 to 29 do
    begin
      for ColWin := 0 to 29 do
      begin
        if StringGrid.Cells[ColWin, RowWin] = '🏳' then
        begin
          if MinesValues[ColWin, RowWin] = 'm' then
            CorrectMines := CorrectMines + 1;
        end;
      end;
    end;
  end;
  // this checks that the flags correspond to the mines and that there is the correct number
  if CorrectMines = 100 then
  begin
    StringGrid.Enabled := False;
    WinLoseLabel.Caption := 'You win!';
    WinLoseLabel.Font.Color := clRed;
    WinLoseLabel.Visible := True;
    OKButton.Visible := True;
  end;
end;

procedure TMinesweeper.StringGridOnDblClick(Sender: TObject);
{ this is to reveal the square }
var
  CellValue: string;
begin
  RowSelected := StringGrid.Row;
  ColumnSelected := StringGrid.Col;
  MinesValuesChar := MinesValues[ColumnSelected, RowSelected];
  CellValuesAssign(MinesValuesChar);
  // a value for that vale in the array is assigned
  CellValue := MinesValuesString;
  StringGrid.Cells[ColumnSelected, RowSelected] := CellValue;
  // the string grid is modified
  if CellValue = '💥' then
    Lose; // if that cell value is an explosion, then the lose procedure is called
  BlankCheck; // the board is checked for new adjacent blanks
  Win; // checks if the user has won
  MinesLeftCounter; // counts the number of mines left
  SquaresLeftCounter; // counts the number of cells left
end;

procedure TMinesweeper.StringGridOnClick(Sender: TObject);
{ this is to flag the square }
begin
  RowSelected := StringGrid.Row;
  ColumnSelected := StringGrid.Col;
  StringGrid.Cells[ColumnSelected, RowSelected] := '🏳';
  // modifies the cell so it contains a flag
  Win; // checks if the user has won
  MinesLeftCounter; // counts the number of mines left
  SquaresLeftCounter; // counst the number of cells left
end;

procedure TMinesweeper.CellValuesAssign(var MinesValuesChar: char);
{ assigns a value which will go in the string grid, on the basis of what it corresponds to in the array }
var
  CellValue: string;
begin
  if MinesValuesChar = 'o' then
    CellValue := ' ';
  if MinesValuesChar = 'a' then
    CellValue := '1';
  if MinesValuesChar = 'b' then
    CellValue := '2';
  if MinesValuesChar = 'c' then
    CellValue := '3';
  if MinesValuesChar = 'd' then
    CellValue := '4';
  if MinesValuesChar = 'e' then
    CellValue := '5';
  if MinesValuesChar = 'f' then
    CellValue := '6';
  if MinesValuesChar = 'g' then
    CellValue := '7';
  if MinesValuesChar = 'h' then
    CellValue := '8';
  if MinesValuesChar = 'm' then
    CellValue := '💥';
  MinesValuesString := CellValue;
end;

procedure TMinesweeper.BlankCheck;
{ checks for blanks if a blank has been revealed
  - loops through the entire grid
  - if the cell it is on is blank, it chooses an option on the basis of its postion in the grid
  (ie if it is at the edge or not)
  - checks for each cell surrounding of they are hashes
  - if they are, the cell value is changed, etc
  - if a cell around it is blank, a variable is changed so that it can be called again
  - if that variable is set to true, the procedure is called again }
var
  CellValue: string;
  RowBC1, ColBC1, Choice: Integer;
begin
  DoBlankCheck := False;
  Choice := 0;
  for RowBC1 := 0 to 29 do
  begin
    for ColBC1 := 0 to 29 do
    begin
      if StringGrid.Cells[ColBC1, RowBC1] = ' ' then
      begin
        if ColBC1 = 0 then
        begin
          if RowBC1 = 0 then
            Choice := 4
          else
            Choice := 2;
        end
        else
        begin
          if RowBC1 = 0 then
            Choice := 3
          else
            Choice := 1;
        end;
        case Choice of
          1:
            begin
              if StringGrid.Cells[ColBC1, RowBC1 - 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1, RowBC1 - 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1, RowBC1 - 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 - 1, RowBC1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 - 1, RowBC1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 - 1, RowBC1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 + 1, RowBC1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 + 1, RowBC1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 + 1, RowBC1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1, RowBC1 + 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1, RowBC1 + 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1, RowBC1 + 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 - 1, RowBC1 - 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 - 1, RowBC1 - 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 - 1, RowBC1 - 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 - 1, RowBC1 + 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 - 1, RowBC1 + 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 - 1, RowBC1 + 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 + 1, RowBC1 - 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 + 1, RowBC1 - 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 + 1, RowBC1 - 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 + 1, RowBC1 + 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 + 1, RowBC1 + 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 + 1, RowBC1 + 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
            end;
          2:
            begin
              if StringGrid.Cells[ColBC1, RowBC1 - 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1, RowBC1 - 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1, RowBC1 - 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 + 1, RowBC1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 + 1, RowBC1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 + 1, RowBC1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1, RowBC1 + 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1, RowBC1 + 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1, RowBC1 + 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 + 1, RowBC1 - 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 + 1, RowBC1 - 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 + 1, RowBC1 - 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 + 1, RowBC1 + 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 + 1, RowBC1 + 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 + 1, RowBC1 + 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
            end;
          3:
            begin
              if StringGrid.Cells[ColBC1 - 1, RowBC1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 - 1, RowBC1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 - 1, RowBC1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1 + 1, RowBC1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 + 1, RowBC1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 + 1, RowBC1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1, RowBC1 + 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1, RowBC1 + 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1, RowBC1 + 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
            end;
          4:
            begin
              if StringGrid.Cells[ColBC1 + 1, RowBC1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1 + 1, RowBC1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1 + 1, RowBC1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
              if StringGrid.Cells[ColBC1, RowBC1 + 1] = '#' then
              begin
                MinesValuesChar := MinesValues[ColBC1, RowBC1 + 1];
                CellValuesAssign(MinesValuesChar);
                CellValue := MinesValuesString;
                StringGrid.Cells[ColBC1, RowBC1 + 1] := CellValue;
                if CellValue = ' ' then
                  DoBlankCheck := True;
              end;
            end;
        end;
      end;
    end;
  end;
  if DoBlankCheck = True then
    BlankCheck;
end;

procedure TMinesweeper.Setup;
{ sets up variables and visual elements for the game }
begin
  MinesLeft := 100;
  LabelMinesLeftValue.Caption := inttostr(MinesLeft);
  SquaresLeft := 900;
  LabelSquaresLeftValue.Caption := inttostr(SquaresLeft);
  WinLoseLabel.Visible := False;
  OKButton.Visible := False;
  StringGrid.Enabled := True;
end;

procedure TMinesweeper.MinesGeneration;
{ generates mines and places them on the string grid }
var
  I, RowMineGen, ColMineGen, MinesLeftMineGen: Integer;
begin
  MinesLeftMineGen := 100;
  for I := 1 to 900 do
  begin
    if MinesLeftMineGen = 0 then
    // if the number of mines left to generate is zero, it stops
      break;
    if MinesLeftMineGen > 0 then
    begin
      RowMineGen := random(30); // picks 2 random numbers for column and row
      ColMineGen := random(30);
      if StringGrid.Cells[ColMineGen, RowMineGen] <> 'm' then
      begin
        MinesLeftMineGen := MinesLeftMineGen - 1;
        StringGrid.Cells[ColMineGen, RowMineGen] := 'm';
        // if the cell at the column and row doesn't already have a mine
        // the number of mines left to generate is decreased by one
        // the cell is changed to 'm'
      end;
    end;
  end;
end;

procedure TMinesweeper.NumberAssignment;
{ counts up the number of cells which have a mine adjacent to the them }
var
  ColAssignment, RowAssignment, CellTotal: Integer;
begin
  for ColAssignment := 0 to 29 do
  begin
    for RowAssignment := 0 to 29 do
    begin
      CellTotal := 0;
      if (ColAssignment <> 0) and (RowAssignment <> 0) then
      begin
        if StringGrid.Cells[ColAssignment - 1, RowAssignment - 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment - 1, RowAssignment] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment - 1, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment, RowAssignment - 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment - 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
      end;
      if (ColAssignment = 0) and (RowAssignment <> 0) then
      begin
        if StringGrid.Cells[ColAssignment, RowAssignment - 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment - 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
      end;
      if (ColAssignment <> 0) and (RowAssignment = 0) then
      begin
        if StringGrid.Cells[ColAssignment - 1, RowAssignment] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment - 1, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
      end;
      if (ColAssignment = 0) and (RowAssignment = 0) then
      begin
        if StringGrid.Cells[ColAssignment, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment] = 'm' then
          CellTotal := CellTotal + 1;
        if StringGrid.Cells[ColAssignment + 1, RowAssignment + 1] = 'm' then
          CellTotal := CellTotal + 1;
      end;
      if CellTotal <> 0 then
      begin
        if StringGrid.Cells[ColAssignment, RowAssignment] <> 'm' then
          StringGrid.Cells[ColAssignment, RowAssignment] := inttostr(CellTotal);
      end;
    end;
  end;
end;

procedure TMinesweeper.CreateArray;
{ assigns the values in the string grid into the array }
var
  RowArray, ColArray: Integer;
  ArrayValue: char;
begin
  for RowArray := 0 to 29 do
  begin
    for ColArray := 0 to 29 do
    begin
      if StringGrid.Cells[ColArray, RowArray] = '' then
        ArrayValue := 'o';
      if StringGrid.Cells[ColArray, RowArray] = '1' then
        ArrayValue := 'a';
      if StringGrid.Cells[ColArray, RowArray] = '2' then
        ArrayValue := 'b';
      if StringGrid.Cells[ColArray, RowArray] = '3' then
        ArrayValue := 'c';
      if StringGrid.Cells[ColArray, RowArray] = '4' then
        ArrayValue := 'd';
      if StringGrid.Cells[ColArray, RowArray] = '5' then
        ArrayValue := 'e';
      if StringGrid.Cells[ColArray, RowArray] = '6' then
        ArrayValue := 'f';
      if StringGrid.Cells[ColArray, RowArray] = '7' then
        ArrayValue := 'g';
      if StringGrid.Cells[ColArray, RowArray] = '8' then
        ArrayValue := 'h';
      if StringGrid.Cells[ColArray, RowArray] = 'm' then
        ArrayValue := 'm';
      MinesValues[ColArray, RowArray] := ArrayValue;
    end;
  end;
end;

procedure TMinesweeper.StringGridHash;
{ changes all the values in the string grid to hashes }
var
  RowHash, ColHash: Integer;
begin
  for RowHash := 0 to 29 do
  begin
    for ColHash := 0 to 29 do
    begin
      StringGrid.Cells[ColHash, RowHash] := '#';
    end;
  end
end;

procedure TMinesweeper.FormCreate(Sender: TObject);
{ runs all the below procedures }
begin
  Setup;
  MinesGeneration;
  NumberAssignment;
  CreateArray;
  StringGridHash;
end;

procedure TMinesweeper.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{ colours in the cells the right colour }
var
  ValueColour: Integer;
begin
  ValueColour := 0;
  with StringGrid do
  begin
    if Cells[ACol, ARow] = ' ' then
      ValueColour := 0;
    if Cells[ACol, ARow] = '1' then
      ValueColour := 1;
    if Cells[ACol, ARow] = '2' then
      ValueColour := 2;
    if Cells[ACol, ARow] = '3' then
      ValueColour := 3;
    if Cells[ACol, ARow] = '4' then
      ValueColour := 4;
    if Cells[ACol, ARow] = '5' then
      ValueColour := 5;
    if Cells[ACol, ARow] = '6' then
      ValueColour := 6;
    if Cells[ACol, ARow] = '7' then
      ValueColour := 7;
    if Cells[ACol, ARow] = '8' then
      ValueColour := 8;
    if Cells[ACol, ARow] = '#' then
      ValueColour := 9;
    if Cells[ACol, ARow] = '🏳' then
      ValueColour := 10;
    if Cells[ACol, ARow] = '💥' then
      ValueColour := 11;
    if Cells[ACol, ARow] = '💣' then
      ValueColour := 12;

    case ValueColour of
      0:
        begin
          Canvas.Font.Color := clSilver;
          Canvas.Brush.Color := clSilver;
        end;
      1:
        begin
          Canvas.Font.Color := clHighlight;
          Canvas.Brush.Color := clSilver;
        end;
      2:
        begin
          Canvas.Font.Color := clGreen;
          Canvas.Brush.Color := clSilver;
        end;
      3:
        begin
          Canvas.Font.Color := clRed;
          Canvas.Brush.Color := clSilver;
        end;
      4:
        begin
          Canvas.Font.Color := clNavy;
          Canvas.Brush.Color := clSilver;
        end;
      5:
        begin
          Canvas.Font.Color := clMaroon;
          Canvas.Brush.Color := clSilver;
        end;
      6:
        begin
          Canvas.Font.Color := clTeal;
          Canvas.Brush.Color := clSilver;
        end;
      7:
        begin
          Canvas.Font.Color := clPurple;
          Canvas.Brush.Color := clSilver;
        end;
      8:
        begin
          Canvas.Font.Color := clBlack;
          Canvas.Brush.Color := clSilver;
        end;
      9:
        begin
          Canvas.Font.Color := clGray;
          Canvas.Brush.Color := clGray;
        end;
      10:
        begin
          Canvas.Font.Color := clWhite;
          Canvas.Brush.Color := clGray;
        end;
      11:
        begin
          Canvas.Font.Color := clBlack;
          Canvas.Brush.Color := clYellow;
        end;
      12:
        begin
          Canvas.Font.Color := clBlack;
          Canvas.Brush.Color := clSilver;
        end;
    end;
    Canvas.FillRect(Rect);
    Canvas.TextOut(Rect.Left, Rect.Top, Cells[ACol, ARow]);
  end;
end;

end.
