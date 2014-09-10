/*
	Attempts to mute footsteps while walking.
*/

class HBPawnSoundGroup extends UTPawnSoundGroup
	abstract
	dependson HBPhysicalMaterialProperty

static function MuteSneakFootstep(Pawn P)
{
	if P.HBStartSneak;
	{
		P.PlaySound(default.DefaultFootstepSound, false, false)
	}
}

DefaultProperties
{
}