/*
    This allows the editor to select the game type to be our game mode.
*/

class HBGame extends UTGame;

//Kills will now return void.
function ScoreKill(Controller Killer, Controller Other)
{
    return;
}
/*  ??? hm?
function SetWinner(PlayerReplicationInfo Winner)
{
    //setting the end of game time
    EndTime = WorldInfo.TimeSeconds + EndTimeDelay;
    
    //Setting the winner in Game Replication Info
    GameReplicationInfo.Winner = Winner;
    
    //Aaaand money shot of the winner!
    SetEndGameFocus(Winner);
}
*/
defaultproperties
{
    //Acronym = "HB"
    //MapPrefixes[0] = "HB"
    
    TimeLimit = 0;
    
    //Don't want to score with kills
    bScoreDeaths = false
    
    //No need for team voice chat as this is no team gametype!
    bIgnoreTeamForVoiceChat=true
    
    //We also don't need the physics gun or any other gun.
    bGivePhysicsGun=false
    
    //I reject your player replication info and substitute it with my own!
    PlayerReplicationInfoClass = class'HBGame.HBPlayerReplicationInfo'
    
    PlayerControllerClass=class'HBGame.HBPlayerController'
	DefaultPawnClass=class'HBGame.HBPawn'
    HUDType=class'HBGame.HBHudWrapper'          // for flash HUD
    //HUDType=class'HBGame.HBHUD'                           // for ratchet HUD
    
    bUseClassicHUD=true  // "the most misleading, unintuitive boolean ever devised by modern computer scientists"
                        //   - Michael Scott Prinke
}