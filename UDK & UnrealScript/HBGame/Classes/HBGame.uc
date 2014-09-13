/*
    This allows the editor to select the game type to be our game mode.
*/

class HBGame extends UTGame
DLLBind(SerialReader);

var int pulseR;
var int pulseS;
var int breathingForce;

dllimport final function startReadingSerialData();
dllimport final function int getPulseRate();
dllimport final function int getPulseStatus();
dllimport final function int getBreathingForce();

function startReadingSerialData()
{
	WorldInfo.Game.Broadcast(self, "Starting DLL!");
	startReadingSerialData();
}

exec function printAllSerialData()
{
	pulseR = getPulseRate();
	pulseS = getPulseStatus();
	breathingForce = getBreathingForce();
	WorldInfo.Game.Broadcast(self, "Pulse rate reading was: "$pulseR);
	WorldInfo.Game.Broadcast(self, "Pulse status was: "$pulseS);
	WorldInfo.Game.Broadcast(self, "Breathing force was: "$breathingForce);
}

function int givePulseRate()
{
	return getPulseRate();
}

function int givePulseStatus()
{
	return getPulseStatus();
}

function int giveBreathingForce()
{
	return getBreathingForce();
}

defaultproperties
{
    PlayerControllerClass=class'HBGame.HBPlayerController'
	DefaultPawnClass=class'HBGame.HBPawn'
    HUDType=class'HBGame.HBHudWrapper'          // for flash HUD
    //HUDType=class'HBGame.HBHUD'                           // for ratchet HUD
    bUseClassicHUD=true  // "the most misleading, unintuitive boolean ever devised by modern computer scientists" - Michael Scott Prinke
}