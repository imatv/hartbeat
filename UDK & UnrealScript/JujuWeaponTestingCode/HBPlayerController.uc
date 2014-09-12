/*
    Nothing in this file is used... yet.
    JK. dependson(HBPawn); is what broke everything...
*/

class HBPlayerController extends UTPlayerController
    dependson(HBPawn);

exec function RequestReload()
{
	local HBWeapon hbwp;
	local int clips;
	hbwp = HBWeapon(Pawn.Weapon);

	if(hbwp != none)
	{	
		clips = hbwp.clips;

		if(clips > 0 && !hbwp.bIsReloading && hbwp.AmmoCount != hbwp.MaxAmmoCount)
		{
			hbwp.bIsReloading = true;
			hbwp.SetTimer(2.5, false, 'Reload');
		}
	}
}

/*
    
var bool HBbIsSprinting;
var bool HBbIsSneaking;

var HBPawn Thing;

function HBCheckSprintOrSneak()
{
    if ( Pawn == None )
	{
		return;
	}
    
    if (HBbIsSprinting && !HBbIsSneaking)
    {
        Thing.HBStartSprint();
    }
    if (!HBbIsSprinting && HBbIsSneaking)
    {
        Thing.HBStartSneak();
    }
    if (!HBbIsSprinting && !HBbIsSneaking)
    {
        Thing.HBStopSprintOrSneak();
    }
}

state HBPlayerSpeedChange
{
    ignores SeePlayer, HearNoise, Bump;  
    
    function PlayerMove(float DeltaTime)
    {
        Super.PlayerMove(DeltaTime);
		HBCheckSprintOrSneak();
    }
}

*/

defaultproperties
{
}