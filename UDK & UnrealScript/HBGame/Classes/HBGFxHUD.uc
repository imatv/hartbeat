class HBGFxHUD extends GFxMoviePlayer;

function Init( optional LocalPlayer LocPlay )
{
    //Gets all the other intialization stuff we need.
    super.Init (LocPlay);
    
    //Starts the GFx Movie that's attached to this script (IE: our HUD).
    Start();
    
    //Advances the frame to the first one.
    Advance(0.f);
}

//Calls every tick; we set this up ourselves in the PostRender function in the HUD wrapper.
function TickHUD()
{
    //Store the current player's info.
    //local HBPlayerReplicationInfo HBRep;
    local UTWeapon CurrentWeapon;

    local float thisAmmoCount;
    local float thisMaxAmmoCount;
    
    local float thisHealth;
    local float thisHealthMax;
    
    //Gets the player's replication info and weapon info.
    //HBRep=HBPlayerReplicationInfo(GetPC().Pawn.PlayerReplicationInfo);
    CurrentWeapon = UTWeapon(GetPC().Pawn.Weapon);

    //Now that we HAVE the player's replication info, we can update the current variables to that which is stored in the replication info.
    thisAmmoCount = CurrentWeapon.AmmoCount; 
    thisMaxAmmoCount = CurrentWeapon.MaxAmmoCount;
    
    thisHealth = HBPawn(GetPC().Pawn).Health;
    thisHealthMax = HBPawn(GetPC().Pawn).HealthMax;
    
    SetVariableNumber("current_ammo",thisAmmoCount); 
    SetVariableNumber("max_ammo",thisMaxAmmoCount);
    
    SetVariableNumber("currentHealth",thisHealth);
    SetVariableNumber("maxHealth",thisHealthMax);
}

DefaultProperties
{
    //The path to the swf asset
    MovieInfo=SwfMovie'hb_hud.hb_hud'
    bDisplayWithHudOff=false
    bIgnoreMouseInput=true
    bAutoPlay=true
}