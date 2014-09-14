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

//Distance from origin to reference spread circle
var float y;


/**Functions*************************************/

simulated function vector getShot(vector Direction)
{
	local vector shot;
	local rotator rot;
	local float y;
	local float z;
	local float chanceRadius;
	local float r;
	local float theta;
	local int radiusGenerator;

	rot = rotator(Direction);
	shot = Direction << rot;


	//In this space we will take the heartbeat input to affect the radius of the spread

	//use a normal distribution to select the radius of spread (gives higher chance to hit center than extreme bullet spread)
	radiusGenerator = Rand(100);
	if (radiusGenerator < 69)
		chanceRadius = 0.4*spreadRadius;
	else if (radiusGenerator < 96)
		chanceRadius = 0.75*spreadRadius;

	//randomly select polar coordinates for the bullet to travel bounded by the radius of spread
	r = (Rand(11)/10.0)*chanceRadius;
	theta = (Rand(360)/180)*3.14;
	
	//convert polar coordinates to cartesian form
	y = r*cos(theta);
	z = r*sin(theta);
	
	shot.X += x;
	shot.Y += y;
	shot.Z += z;
	return Shot;


}

function Init(vector Direction)
{
	local vector shot;
	
	shot = getShot(Direction);
	Velocity = Speed*Shot;
	Acceleration = AccelRate*Normal(Velocity);
}


/**Defaults**************************************/

defaultproperties
{
	spreadRadius = 1.0
	radiusScalar = 1.0
	x = 18.0
}
