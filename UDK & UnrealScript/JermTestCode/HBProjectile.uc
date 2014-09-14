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
	spreadRadius = 0.1
	radiusScalar = 1.0
}
