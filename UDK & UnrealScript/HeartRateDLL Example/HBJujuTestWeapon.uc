/*
	New Test Weapon using our own weapon properties
*/

class HBJujuTestWeapon extends HBWeapon
	DLLBind(SerialReader);

dllimport final function int getPulseRate();
dllimport final function int getPulseStatus();
	
simulated function rotator AddSpread(rotator BaseAim)
{
	local vector X, Y, Z;
	local float RandY, RandZ;
	mySpread = 0.01 * getPulseRate();
	PrintScreenDebug("Spread " $mySpread);
	GetAxes(BaseAim, X, Y, Z);
	RandY = FRand() - 0.5;
	RandZ = Sqrt(0.5 - Square(RandY)) * (FRand() - 0.5);
	return rotator(X + RandY * mySpread * Y + RandZ * mySpread * Z);
	
}

defaultproperties
{
Begin Object Class=AnimNodeSequence Name=MeshSequenceA
End Object

Begin Object Name=PickupMesh
SkeletalMesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_1P'               // your mesh       
End Object

Begin Object Name=FirstPersonMesh
SkeletalMesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_1P'                   // your mesh
Rotation=(Yaw=-16384)
FOV=60.0
AnimSets(0)=AnimSet'WP_ShockRifle.Anim.K_WP_ShockRifle_1P_Base'                //   your animation left
AnimSets(1)=AnimSet'WP_ShockRifle.Anim.K_WP_ShockRifle_1P_Base'               //   your animation right
Animations=MeshSequenceA
End Object

InstantHitDamage(0)=20                       
InstantHitDamage(1)=20
FireInterval(0)=0.4
FireInterval(1)=0.4

WeaponFireSnd(0)=SoundCue'A_Character_CorruptEnigma_Cue.Mean_Efforts.A_Effort_EnigmaMean_PainSmall_Cue'               //  your sounds
WeaponFireSnd(1)=SoundCue'A_Character_CorruptEnigma_Cue.Mean_Efforts.A_Effort_EnigmaMean_PainSmall_Cue'
WeaponEquipSnd=SoundCue'A_Character_CorruptEnigma_Cue.Mean_Efforts.A_Effort_EnigmaMean_PainSmall_Cue'
WeaponPutDownSound=SoundCue'A_Character_CorruptEnigma_Cue.Mean_Efforts.A_Effort_EnigmaMean_PainSmall_Cue'
PickupSound=SoundCue'A_Character_CorruptEnigma_Cue.Mean_Efforts.A_Effort_EnigmaMean_PainSmall_Cue'

WeaponFireAnim(0)=WeaponFire                                         //  the name of the animation(you can find it when you double click onto the animset)
WeaponFireAnim(1)=WeaponFire

AttachmentClass=Class'HBGame.HBJujuTestWeaponAttachment'                         // your attachmentclass 

WeaponFireTypes(0)=EWFT_Projectile
WeaponProjectiles(0)=class'HBGame.HBProj_TestProjectile'

ShotCost(0)=1
ShotCost(1)=1

MaxAmmoCount=36
AmmoCount=6
TotalAmmoCount=36

Clips=6
ClipSize=6

WeaponRange=20000

MessageClass=Class'UTPickupMessage'
DroppedPickupClass=Class'UTDroppedPickup'
//                                                                                                                              Zoom and flashlight...
DefaultProperties
{

bZoomedFireMode(0)=0
bZoomedFireMode(1)=1

ZoomedTargetFOV=12.0
ZoomedRate=9000
}



}
