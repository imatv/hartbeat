/*
    TODO: Somehow remove the exec's from this file,
    and use states in HBPlayerController to control these functions.
*/

class HBPawn extends UTPawn;

///EXEC FUNCTIONS:
//Sprint function (mapped to the LEFT SHIFT)
exec function HBStartSprint()
{
	ConsoleCommand("Sprint");
    StopFiring();

	ClientMessage("--Sprinting--");
    ClientMessage("Pawnspeed before change is: " @ GroundSpeed);
	GroundSpeed = 440.0;
	ClientMessage("Pawnspeed after change is: " @ GroundSpeed);
	ClientMessage("--Sprinting--");
}

//Walk function (mapped to LEFT ALT)
exec function HBStartSneak()
{
	ConsoleCommand("Sneak");

    ClientMessage("--Sneaking--");
    ClientMessage("Pawnspeed before change is: " @ GroundSpeed);
	GroundSpeed = 130.0; //130 for crouching
	ClientMessage("Pawnspeed after change is: " @ GroundSpeed);
	ClientMessage("--Sneaking--");
}

//Revert back to normal speed
exec function HBStopSprintOrSneak()
{
    
	ClientMessage("--Normal--");
	ClientMessage("Pawnspeed before change is: " @ GroundSpeed);
	GroundSpeed = 220.0;
	ClientMessage("Pawnspeed after change is: " @ GroundSpeed);
    ClientMessage("--Normal--");
}

///DEFAULT PLAYER PROPERTIES:
defaultproperties
{
	WalkingPct=+0.7
	GroundSpeed=220.0
	AirSpeed=220.0
	DodgeSpeed=300.0
}