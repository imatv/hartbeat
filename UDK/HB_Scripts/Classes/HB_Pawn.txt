/*
* Copyright 2014 Hartbeat. All Rights Reserved.
*/
class HB_Pawn extends UTPawn;

///EXEC FUNCTIONS:
//Sprint function (mapped to the LEFT SHIFT)
exec function HB_StartSprint()
{
	GroundSpeed = 440.0;
}
exec function HB_StopSprint()
{
	GroundSpeed = 220.0;
}

//Walk function (mapped to LEFT ALT)
exec function HB_StartWalk()
{
	GroundSpeed = 140.0;
}
exec function HB_StopWalk()
{
	GroundSpeed = 220.0;
}

///DEFAULT PLAYER PROPERTIES:
defaultproperties
{
	WalkingPct=+0.7
	CrouchedPct=+0.4
	BaseEyeHeight=38.0
	EyeHeight=38.0
	GroundSpeed=220.0
	AirSpeed=220.0
	WaterSpeed=220.0
	DodgeSpeed=300.0
	DodgeSpeedZ=295.0
	AccelRate=2048.0
	JumpZ=322.0
	CrouchHeight=29.0
	CrouchRadius=21.0
	WalkableFloorZ=0.78
}