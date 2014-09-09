/*
    This allows the editor to select the game type to be our game mode.
*/

class HBGame extends UTGame;

defaultproperties
{
    PlayerControllerClass=class'HBGame.HBPlayerController'
	DefaultPawnClass=class'HBGame.HBPawn'
    HUDType=class'HBGame.HBHUD'
    bUseClassicHUD=true
}