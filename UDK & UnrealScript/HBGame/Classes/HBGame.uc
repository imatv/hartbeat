/*
    This allows the editor to select the game type to be our game mode.
*/

class HBGame extends UTGame;

defaultproperties
{
    PlayerControllerClass=class'HBGame.HBPlayerController'
	DefaultPawnClass=class'HBGame.HBPawn'
    HUDType=class'HBGame.HBHudWrapper'          // for flash HUD
    //HUDType=class'HBGame.HBHUD'                           // for ratchet HUD
    bUseClassicHUD=true  // "the most misleading, unintuitive boolean ever devised by modern computer scientists" - Michael Scott Prinke
}