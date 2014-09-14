/**
	Projectiles should function the same no in HB as they do in UT.
	Ensure that projectile base variables are correct for your projectile.
*/

class HBProjectile extends UTProjectile;


/**Variables*************************************/

//Radius of spread of bullets
var float spreadRadius;

//Multiplier to increase/decrease radius of spread
var float radiusScalar;


/**Functions*************************************/

function float scaleRadius(int BPM)
{
	if (BPM >= 75 && BPM <= 85)
	{
		return 0.1;
	}
	else if (BPM > 85 && BPM <= 100)
	{
		return 0.2;
	}
	else if (BPM > 100 && BPM <= 115)
	{
		return 0.4;
	}
	else if (BPM > 115 && BPM <= 130)
	{
		return 0.8;
	}
	else if (BPM > 130 && BPM <= 150)
	{
		return 1.6;
	}
	else if (BPM > 150)
	{
		return 3.2;
	}
	else if (BPM < 75 && BPM >= 60)
	{
		return 0.05;
	}
	else if (BPM < 60)
	{
		return 0.025;
	}
}

function tick(float DeltaTime)
{
    local HBPlayerController PC;
	PC = HBPlayerController(Instigator.Controller);
	PC.HBSpreadRadiusUpdate(spreadRadius);
	super.tick(DeltaTime);
}


simulated function rotator getShot(vector Direction)
{
	local vector shot, X, Y, Z;
	local rotator rotor, turnyyy;
	local float ry;
	local float rz;
	local float chanceRadius;
	local float r;
	local float theta;
	local int radiusGenerator;

	rotor = rotator(Direction);

	//get unit vectors of the current direction
	GetAxes(rotor, X, Y, Z);


	//In this space we will take the heartbeat input to affect the radius of the spread
	

	//use a normal distribution to select the radius of spread (gives higher chance to hit center than extreme bullet spread)
	radiusGenerator = Rand(100);
	if (radiusGenerator < 69)
		chanceRadius = 0.4*spreadRadius;
	else if (radiusGenerator < 96)
		chanceRadius = 0.75*spreadRadius;

	//randomly select polar coordinates for the bullet to travel bounded by the radius of spread
	r = (Rand(10)/(10.0))*chanceRadius;
	theta = (Rand(360)/(180.0))*(3.14);
	
	//convert polar coordinates to cartesian form
	ry = r*cos(theta);
	rz = r*sin(theta);

	//convert the data to a rotator to return
	turnyyy = rotator(X + ry*Y + rz*Z);
	return turnyyy;


}

function Init(vector Direction)
{
	local vector shot;
	
	SetRotation(rotator(Direction));

	shot = vector(getShot(Direction));
	Velocity = Speed*Shot;
	Acceleration = AccelRate*Normal(Direction);
}


/**Defaults**************************************/

defaultproperties
{
	spreadRadius = .1
	radiusScalar = 1.0
}
