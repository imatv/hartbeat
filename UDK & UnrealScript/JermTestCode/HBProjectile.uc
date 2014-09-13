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
var float z;


/**Functions*************************************/

simulated function vector getDirection()
{
	local var float x;
	local var float y;
	local var int radiusGenerator;
	local var float chanceRadius
	local var float r;
	local var float theta;

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
	x = r*cos(theta);
	y = r*sin(theta);
	
	return <x, y, z>;
}


function Init()
{
	local var vector Direction;
	
	Direction = getDirection();
	SetRotation(rotator(Direction));
	
	Velocity = Speed*Direction;
	Velocity.Z += TossZ
	Acceleration = AccelRate*Normal(Direction);
}


/**Defaults**************************************/

defaultproperties
{
	spreadRadius = 1.0;
	radiusScalar = 1.0;
	z = -18.0
}
