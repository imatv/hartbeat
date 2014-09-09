/*
    Nothing in this file is used... yet.
    JK. dependson(HBPawn); is what broke everything...
*/

class HBPlayerController extends UTPlayerController
    dependson(HBPawn);

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