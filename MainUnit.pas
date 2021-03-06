unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Platform,
  FMX.Layouts, FMX.ListBox;

type
  TMainForm = class(TForm)
    ProgressBarLoading: TProgressBar;
    ImageLoading: TImage;
    Label1: TLabel;
    EventListBox: TListBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

var
  clientScreenService       : IFMXScreenService;
  clientScreenScale         : Single;

{$R *.fmx}

procedure TMainForm.FormActivate(Sender: TObject);
begin
  EventListBox.Items.Add('FormActivate');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(clientScreenService)) then
  begin
    clientScreenScale       := clientScreenService.GetScreenScale;
  end;
  EventListBox.ItemHeight := 24;
end;


procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  EventListBox.Items.Add('FormDeactivate');
end;

procedure TMainForm.FormFocusChanged(Sender: TObject);
begin
  EventListBox.Items.Add('FormFocusChanged');
end;

procedure TMainForm.FormHide(Sender: TObject);
begin
  EventListBox.Items.Add('FormHide');
end;

procedure TMainForm.FormResize(Sender: TObject);
var
  I : Integer;
begin
  EventListBox.Items.Add('FormResize, clientSize : '+IntToStr(Trunc(ClientWidth))+'x'+IntToStr(Trunc(ClientHeight)));
  If (clientWidth = clientScreenService.GetScreenSize.X) and (clientHeight = clientScreenService.GetScreenSize.Y) then
  Begin
    // Create progress indicator on a black background image
    ImageLoading.SetBounds(0,0,clientWidth,clientHeight);
    ImageLoading.Bitmap.SetSize(Trunc(clientWidth),Trunc(clientHeight));
    ImageLoading.Bitmap.Clear($FF000000);

    // Position everything
    ProgressBarLoading.Width      := Trunc(clientWidth*0.75);
    ProgressBarLoading.Position.X := Trunc((ClientWidth-ProgressBarLoading.Width) / 2);
    ProgressBarLoading.Position.Y := Trunc(ClientHeight*0.75);

    // Make sure progress indicator are covering the other elements
    ImageLoading.BringToFront;
    ProgressBarLoading.BringToFront;

    For I := 1 to 100 do
    Begin
      ProgressBarLoading.Value := I;
      Application.ProcessMessages;
      Sleep(25);
    End;

    // Hide progress indicator
    ProgressBarLoading.Visible := False;
    ImageLoading.Visible       := False;
    EventListBox.Items.Add('Finished pre-processing');
  End;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  EventListBox.Items.Add('FormShow');
end;

end.
