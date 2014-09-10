/*
	Attempts to mute footsteps while walking.
*/

class HBPawnSoundGroup extends UTPawnSoundGroup within HBPawn
	abstract
	dependson (HBPhysicalMaterialProperty);

static function MuteSneakFootstep(HBPawn P)
{
	if (P.HBbSneakOn)
	{
		P.PlaySound(default.DefaultFootstepSound, false, false);
	}
}

DefaultProperties
{
}