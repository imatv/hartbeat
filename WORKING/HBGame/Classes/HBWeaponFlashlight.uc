/*
	Creates light object that acts as a flashlight
*/

class HBWeaponFlashlight extends SpotlightMovable
	notplaceable;


DefaultProperties
{
	Begin Object Name=SpotlightComponent0
	Radius=1000
	Brightness=3
	LightColor=(R=255,G=240,B=190)
	CastShadows=false
	end object
	bNodelete=False
}

