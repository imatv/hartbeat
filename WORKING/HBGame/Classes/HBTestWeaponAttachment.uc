

class HBTestWeaponAttachment extends UTWeaponAttachment;

defaultproperties
{
Begin Object Name=SkeletalMeshComponent0 
Skeletalmesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_3P'            //    your mesh
End Object
DefaultImpactEffect=(ParticleTemplate=ParticleSystem'gaz661-darkarts3dweapons.Effects.m60Impact',DecalMaterials=(MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'),DecalWidth=12.0,DecalHeight=12.0,Sound=SoundCue'gaz661-darkarts3dweapons.Sounds.bullethit1')
BulletWhip=SoundCue'A_Character_CorruptEnigma_Cue.Mean_Efforts.A_Effort_EnigmaMean_PainSmall_Cue'
bMakeSplash=true
MuzzleFlashSocket=MF
MuzzleFlashPSCTemplate=ParticleSystem'gaz661-darkarts3dweapons.Effects.m60mk6MF'
MuzzleFlashDuration=0.33
MuzzleFlashLightClass=class'darkarts3d.m60_mk6_mflight'
WeapAnimType=EWAT_Default
}