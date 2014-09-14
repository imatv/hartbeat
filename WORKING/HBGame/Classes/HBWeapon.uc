/*
	Our new weapon property class
*/

class HBWeapon extends UTWeapon
	dependson (HBPlayerController)
	config(Weapon)
	abstract;

var int TotalAmmoCount; //How much ammo is left

var int TotalDisplayCount; //The total amount of ammo that is displayed on the HUD

var int clips; //How many clips the gun has

var int ClipSize; //How much ammo the clip has

var bool bIsReloading;

var int previousPulseStatus;

//Radius of spread of bullets
var float spreadRadius;

//Multiplier to increase/decrease radius of spread
var float radiusScalar;

var float maxRadius;
/*********************************************************************************************
 * Initialization / System Messages / Utility
 *********************************************************************************************/

/**
 * Initialize the weapon
 */
simulated function PostBeginPlay()
{
	local HBGameReplicationInfo GRI;

	Super.PostBeginPlay();
	
	ConsoleCommand("startReadingSerial");

	CalcInventoryWeight();

	// tweak firing/reload/putdown/bringup rate if on console
	GRI = HBGameReplicationInfo(WorldInfo.GRI);
	
	if ( Mesh != None )
	{
		Mesh.CastShadow = class'HBPlayerController'.default.bFirstPersonWeaponsSelfShadow;
	}

	bConsiderProjectileAcceleration = bConsiderProjectileAcceleration
										&& (((WeaponProjectiles[0] != None) && (class<HBProjectile>(WeaponProjectiles[0]).Default.AccelRate > 0))
											|| ((WeaponProjectiles[1] != None) && (class<HBProjectile>(WeaponProjectiles[1]).Default.AccelRate > 0)) );

	// make sure small weapons matches config
	// this is needed because if the UI modifies UTWeapon's defaults at runtime, it won't propagate to the child classes
	bSmallWeapons = class'HBWeapon'.default.bSmallWeapons;

	if ( bUseCustomCoordinates )
	{
		SimpleCrosshairCoordinates = CustomCrosshairCoordinates;
	}
}
function scaleRadius(int BPM, int pulseStatus)
{
	if (pulseStatus != previousPulseStatus)
	{
		maxRadius *= 0.9;
		return;
	}else{	
		setNewRadius(BPM);
	}
	spreadRadius += (maxRadius - spreadRadius)/10;
	previousPulseStatus = pulseStatus;
}

function setNewRadius(int BPM)
{
if (BPM >= 75 && BPM <= 85)
	{
		maxRadius = 0.1;
	}
	else if (BPM > 85 && BPM <= 100)
	{
		maxRadius = 0.2;
	}
	else if (BPM > 100 && BPM <= 115)
	{
		maxRadius = 0.4;
	}
	else if (BPM > 115 && BPM <= 130)
	{
		maxRadius = 0.8;
	}
	else if (BPM > 130 && BPM <= 150)
	{
		maxRadius = 1.6;
	}
	else if (BPM > 150)
	{
		maxRadius = 3.2;
	}
	else if (BPM < 75 && BPM >= 60)
	{
		maxRadius = 0.05;
	}
	else if (BPM < 60)
	{
		maxRadius = 0.025;
	}
}

function tick(float DeltaTime)
{
    local HBPlayerController PC;
	PC = HBPlayerController(Instigator.Controller);
	PC.HBSpreadRadiusUpdate(spreadRadius);
	super.tick(DeltaTime);
}

simulated function rotator AddSpread(rotator BaseAim)
{
	local vector shot, X, Y, Z;
	local rotator rotor, turnyyy;
	local float ry;
	local float rz;
	local float chanceRadius;
	local float r;
	local float theta;
	local int radiusGenerator;

	//get unit vectors of the current direction
	GetAxes(BaseAim, X, Y, Z);


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

simulated function CreateOverlayMesh()
{
	local SkeletalMeshComponent SKM_Source, SKM_Target;
	local StaticMeshComponent STM;
	local HBPawn P;

	if (OverlayMesh == None && WorldInfo.NetMode != NM_DedicatedServer && Mesh != None)
	{
		if ( WorldInfo.NetMode != NM_Client )
		{
			P = HBPawn(Instigator);
			if ( (P == None) || !P.bUpdateEyeHeight )
			{
				return;
			}
		}

		OverlayMesh = new(outer) Mesh.Class;
		if (OverlayMesh != None)
		{
			OverlayMesh.SetScale(1.00);
			OverlayMesh.SetOwnerNoSee(Mesh.bOwnerNoSee);
			OverlayMesh.SetOnlyOwnerSee(true);
			OverlayMesh.SetDepthPriorityGroup(SDPG_Foreground);
			OverlayMesh.CastShadow = false;

			SKM_Target = SkeletalMeshComponent(OverlayMesh);
			if ( SKM_Target != none )
			{
				SKM_Source = SkeletalMeshComponent(Mesh);

				SKM_Target.SetSkeletalMesh(SKM_Source.SkeletalMesh);
				SKM_Target.AnimSets = SKM_Source.AnimSets;
				SKM_Target.SetParentAnimComponent(SKM_Source);
				SKM_Target.bUpdateSkelWhenNotRendered = false;
				SKM_Target.bIgnoreControllersWhenNotRendered = true;

				if (UDKSkeletalMeshComponent(SKM_Target) != none)
				{
					UDKSkeletalMeshComponent(SKM_Target).SetFOV(UDKSkeletalMeshComponent(SKM_Source).FOV);
				}
			}
			else if ( StaticMeshComponent(OverlayMesh) != none )
			{
				STM = StaticMeshComponent(OverlayMesh);
				STM.SetStaticMesh(StaticMeshComponent(Mesh).StaticMesh);
				STM.SetScale3D(Mesh.Scale3D);
				STM.SetTranslation(Mesh.Translation);
				STM.SetRotation(Mesh.Rotation);
			}
			OverlayMesh.SetHidden(Mesh.HiddenGame);
		}
		else
		{
			`Warn("Could not create Weapon Overlay mesh for" @ self @ Mesh);
		}
	}
}

//Removed stupid InventoryWeight dumb stupid variable crap
/*
simulated function CalcInventoryWeight()
{
	return true;
}*/

/*simulated function bool ShouldSwitchTo(HBWeapon InWeapon)
{
	// if we should, but can't right now, tell InventoryManager to try again later
	if (IsFiring() || DenyClientWeaponSet())
	{
		HBInventoryManager(InvManager).RetrySwitchTo(InWeapon);
		return false;
	}
	else
	{
		return true;
	}
}
*/
/*********************************************************************************************
 * Hud/Crosshairs
 *********************************************************************************************/
/**
 * Access to HUD and Canvas.
 * Event always called when the InventoryManager considers this Inventory Item currently "Active"
 * (for example active weapon)
 *
 * @param	HUD			- HUD with canvas to draw on
 */
simulated function ActiveRenderOverlays( HUD H )
{
	local HBPlayerController PC;

	PC = HBPlayerController(Instigator.Controller);
	Super.ActiveRenderOverlays(H);
}

simulated function DrawWeaponCrosshair( Hud HUD )
{
	local UTHUDBase H;

	H = UTHUDBase(HUD);
	Super.DrawWeaponCrosshair(HUD);

}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	Super.DisplayDebug(HUD, out_YL, out_YPos);

	if (HBPawn(Instigator) != None)
	{
		HUD.Canvas.DrawText("Eyeheight "$Instigator.EyeHeight$" base "$Instigator.BaseEyeheight$" landbob "$UTPawn(Instigator).Landbob$" just landed "$UTPawn(Instigator).bJustLanded$" land recover "$UTPawn(Instigator).bLandRecovery, false);
		out_YPos += out_YL;
	}

}

/*********************************************************************************************
 * Attachments / Effects / etc
 *********************************************************************************************/
/**
 * Returns interval in seconds between each shot, for the firing state of FireModeNum firing mode.
 *
 * @param	FireModeNum	fire mode
 * @return	Period in seconds of firing mode
 */
simulated function float GetFireInterval( byte FireModeNum )
{
	return FireInterval[FireModeNum] * ((HBPawn(Owner)!= None) ? HBPawn(Owner).FireRateMultiplier : 1.0);
}

/** plays view shake on the owning client only */
simulated function ShakeView()
{
	local HBPlayerController PC;

	PC = HBPlayerController(Instigator.Controller);
	Super.ShakeView();
	// Play controller vibration
	if( PC != None && LocalPlayer(PC.Player) != None )
	{
		// only do rumble if we are a player controller
		HBPlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform( WeaponFireWaveForm );
	}
}
simulated event CauseMuzzleFlash()
{
	local HBPawn P;
	
	Super.CauseMuzzleFlash();

	if ( WorldInfo.NetMode != NM_Client )
	{
		P = HBPawn(Instigator);
		if ( (P == None) || !P.bUpdateEyeHeight )
		{
			return;
		}
	}
}

simulated function DetachWeapon()
{
	local HBPawn P;
	P = HBPawn(Instigator);
	Super.DetachWeapon();
}

simulated function ChangeVisibility(bool bIsVisible)
{
	local HBPawn HBP;
	
	Super.ChangeVisibility(bIsVisible);
	
	if (ArmsAnimSet != None && GetHand() != HAND_Hidden)
	{
		HBP = HBPawn(Instigator);
		if (HBP != None && HBP.ArmsMesh[0] != None)
		{
			HBP.ArmsMesh[0].SetHidden(!bIsVisible);
		}
	}	
}

simulated function PerformWeaponChange()
{
	if ( HBPawn(Instigator) != None )
	{
		if ( Instigator.IsLocallyControlled() )
		{
			HBPawn(Instigator).WeaponChanged(self);
		}

		// If the controller has not been replicated, try again later
		else if ( Instigator.Controller == None )
		{
			SetTimer(0.01, false, 'PerformWeaponChange');
		}
	}
}

/*********************************************************************************************
 * Pawn/Controller/View functions
 *********************************************************************************************/
simulated function EWeaponHand GetHand() 
{
	local HBPlayerController PC;

	// Get the Weapon Hand from the controller or default to HAND_Right
	if (Instigator != None)
	{
		PC = HBPlayerController(Instigator.Controller);
		if (PC != None)
		{
			return PC.WeaponHand;
		}
	}
	return HAND_Right;
}

 
simulated function bool DoOverrideNextWeapon()
{
	if(clips == 0)
		super.DoOverrideNextWeapon();

	return false;
}


function Reload()
{
	local int AmmoNeeded;
	local int Diff;
	if (AmmoCount == ClipSize)
		return;
	else
	{
		AmmoNeeded = ClipSize - AmmoCount;
		Diff = TotalAmmoCount - AmmoNeeded;
		if (Diff < 0)
			AmmoCount += (AmmoNeeded + Diff);
		else
			AmmoCount += AmmoNeeded;
	}
	bisReloading = False;
	DisplayAmmo();
}

simulated function StartFire(byte FireModeNum)
{
	local PlayerController plr;
	plr = PlayerController(Instigator.Controller);

	if(plr == none || bIsReloading) //You can't shoot while reloading
		return;

	super.StartFire(FireModeNum);
}
 
/*replication
{
 	// Server->Client properties
 	if ( bNetOwner )
	UTWeapon(AmmoCount);
}*/
 
simulated event ReplicatedEvent(name VarName)
{
 	if ( VarName == 'AmmoCount' )
 	{
 		if ( !HasAnyAmmo() )
 		{
			 WeaponEmpty();
 		}
 	}
 	else
	{
 		Super.ReplicatedEvent(VarName);
 	}
}
 
simulated function int GetAmmoCount()
{
	 return AmmoCount;
}

simulated function int GetTotalAmmoCount()
{
	return TotalAmmoCount;
}

simulated function int CalcTotalAmmoCount()
{	
}

/*
 Consumes some of the ammo
*/
function ConsumeAmmo( byte FireModeNum )
{
 	// Subtract the Ammo
 	AddAmmo(-ShotCost[FireModeNum]);
 	AddTotalAmmo(-ShotCost[FireModeNum]);
}
 
/*
  This function is used to add ammo back to a weapon.  It's called from the Inventory Manager
 */
function int AddAmmo( int Amount )
{
	AmmoCount = Clamp(AmmoCount + Amount,0,MaxAmmoCount);
 	return AmmoCount;
}

function int AddTotalAmmo( int Amount )
{
	TotalAmmoCount = Clamp(TotalAmmoCount + Amount,0,MaxAmmoCount);
    DisplayAmmo();
	return TotalAmmoCount;
}
 
/*
  Returns true if the ammo is maxed out
 */
simulated function bool AmmoMaxed(int mode)
{
 	return (TotalAmmoCount >= MaxAmmoCount);
}
 
/*
 * This function checks to see if the weapon has any ammo available for a given fire mode.
 *
 * @param    FireModeNum        - The Fire Mode to Test For
 * @param    Amount            - [Optional] Check to see if this amount is available.  If 0 it will default to checking
 *                              for the ShotCost
 */
simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
 	if (Amount==0)
 	{
 		return (AmmoCount >= ShotCost[FireModeNum]);
 	}
 	else
 	{
 		return ( AmmoCount >= Amount );
 	}
}
 
/*
 * returns true if this weapon has any ammo
 */
simulated function bool HasAnyAmmo()
{
 	return ( ( TotalAmmoCount > 0 ) || (ShotCost[0]==0 && ShotCost[1]==0) );
}
 
/*
 * This function returns how much of the clip is empty.
 */
simulated function float DesireAmmo(bool bDetour)
{
 	return (1.f - float(AmmoCount)/ClipSize);
}
 
/*
 * Returns true if the current ammo count is less than the default ammo count
 */
simulated function bool NeedAmmo()
{
 	return ( TotalAmmoCount < MaxAmmoCount );
}
 
/*
 * Cheat Help function the loads out the weapon
 *
 * @param     bUseWeaponMax     - [Optional] If true, this function will load out the weapon
 *                              with the actual maximum, not 999
 */
simulated function Loaded(optional bool bUseWeaponMax)
{
 	if (bUseWeaponMax)
 	{
 		AmmoCount = ClipSize;
 		TotalAmmoCount = MaxAmmoCount;
 	}
 	else
 	{
 		AmmoCount = 999;
 		TotalAmmoCount = 999;
 	}
}
 
/*
 * Called when the weapon runs out of ammo during firing
 */
simulated function WeaponEmpty()
{
 // If we were firing, stop
 	if ( IsFiring() )
 	{
 		GotoState('Active');
 	}
 
 	if ( Instigator != none && Instigator.IsLocallyControlled() && TotalAmmoCount == 0 )
 	{
 		Instigator.InvManager.SwitchToBestWeapon( true );
 	}
}


function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	local DroppedPickup DP;

	// By default, you can only carry a single item of a given class.
	if ( ItemClass == class )
	{
		DP = DroppedPickup(Pickup);
		if (DP != None)
		{
			if ( DP.Instigator == Instigator )
			{
				// weapon was dropped by this player - disallow pickup
				return true;
			}
			// take the ammo that the dropped weapon has
			AddTotalAmmo(HBWeapon(DP.Inventory).TotalAmmoCount);
			DP.PickedUpBy(Instigator);
			AnnouncePickup(Instigator);
		}
		else
		{
			// add the ammo that the pickup should give us, then tell it to respawn
			AddTotalAmmo(default.TotalAmmoCount);
			if ( PickupFactory(Pickup) != None )
			{
				PickupFactory(Pickup).PickedUpBy(Instigator);
			}
			AnnouncePickup(Instigator);
		}
		return true;
	}
	return false;
}

function DisplayAmmo()
{
	TotalDisplayCount = TotalAmmoCount - AmmoCount;
}



/*********************************************************************************************
 * Ammunition / Inventory
 *********************************************************************************************/
 
function PrintScreenDebug(string debugText)
{
 	local PlayerController PC;
 	PC = PlayerController(Pawn(Owner).Controller);
 	if (PC != None)
 	PC.ClientMessage("HBWeapon: " $ debugText);
}
 
 /*
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
 	local HBPawn HBP;
 
 	HBP = HBPawn(Instigator);
 	PrintScreenDebug("Attaching Weapon");
 	// Attach 1st Person Muzzle Flashes, etc,
 	if ( Instigator.IsFirstPerson() )
 	{
 		AttachComponent(Mesh);
 		EnsureWeaponOverlayComponentLast();
 		SetHidden(False);
 		Mesh.SetLightEnvironment(HTP.LightEnvironment);
	 	PrintScreenDebug("First Person Weapon Attached");
 	}
 	else
 	{
 		SetHidden(True);
 		if (HBP != None)
 		{
			Mesh.SetLightEnvironment(HTP.LightEnvironment);
 		}
 	}
 	//SetSkin(HBPawn(Instigator).ReplicatedBodyMaterial);
}*/
 
defaultproperties
{
 	MaxAmmoCount=1
	TotalAmmoCount=1
	TotalDisplayCount=1	
 	bIsReloading = false
	previousPulseStatus = 0;
	clips = 1
	ClipSize=1
	spreadRadius = .1
	radiusScalar = 1.0
}
