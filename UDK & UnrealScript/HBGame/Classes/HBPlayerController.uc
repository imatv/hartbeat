/*
    Nothing in this file is used... yet.
    JK. dependson(HBPawn); is what broke everything...
*/

class HBPlayerController extends UTPlayerController
    dependson(HBPawn);

var float reticleSpreadRadius;

function HBSpreadRadiusUpdate(float radius)
{
	reticleSpreadRadius = radius;
}

exec function HBRequestReload()
{
	local HBWeapon hbwp;
	local int TotAmmoCt;
	hbwp = HBWeapon(Pawn.Weapon);

	if(hbwp != none)
	{	
		TotAmmoCt = hbwp.TotalAmmoCount;

		if(TotAmmoCt > 0 && !hbwp.bIsReloading && hbwp.AmmoCount != hbwp.ClipSize)
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
	reticleSpreadRadius = 0.0;
}
