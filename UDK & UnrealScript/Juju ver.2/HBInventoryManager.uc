class HBInventoryManager extends UTInventoryManager
	config(Game);

// Holds the last weapon used
//var Weapon PreviousWeapon;

struct native TotalAmmoStore
{
	var int				Amount;
	var class<HBWeapon>	WeaponClass;
};

var array<TotalAmmoStore> TotalAmmoStorage;

/*
simulated function OwnerEvent(name EventName)
{
	local HBInventory	Inv;

	ForEach InventoryActors(class'HBInventory', Inv)
	{
		if( Inv.bReceiveOwnerEvents )
		{
			Inv.OwnerEvent(EventName);
		}
	}
}*/
 
/*simulated function GetWeaponList(out array<HBWeapon> WeaponList, optional bool bNoEmpty, optional bool bFilter, optional int groupFilter)
{
 	local HBWeapon Weap;
 
 	ForEach InventoryActors( class'HBWeapon', Weap )
 	{
 		if ( !bNoEmpty || Weap.HasAnyAmmo())
 		{
 			WeaponList.Insert(0,1);
 			WeaponList[0] = Weap;
 		}
 	}
}*/

simulated function SwitchWeapon(byte NewGroup)
{
	local HBWeapon CurrentWeapon;
	local array<HBWeapon> WeaponList;
	
	Super.SwitchWeapon(NewGroup);
	
	CurrentWeapon = HBWeapon(PendingWeapon);
	if (CurrentWeapon == None)
	{
		CurrentWeapon = HBWeapon(Instigator.Weapon);
	}

	
}
/*
simulated function AdjustWeapon(int NewOffset)
{
	local array<HBWeapon> WeaponList;

	Super.AdjustWeapon(NewOffset);

	CurrentWeapon = HBWeapon(PendingWeapon);
	if (CurrentWeapon == None)
	{
		CurrentWeapon = HBWeapon(Instigator.Weapon);
	}

}*/

/**
 * Switches to Previous weapon
 * Network: Client
 */
simulated function PrevWeapon()
{
	if ( HBWeapon(Pawn(Owner).Weapon) != None && HBWeapon(Pawn(Owner).Weapon).DoOverridePrevWeapon() )
		return;

	Super.PrevWeapon();
}

simulated function NextWeapon()
{
	if ( HBWeapon(Pawn(Owner).Weapon) != None && HBWeapon(Pawn(Owner).Weapon).DoOverrideNextWeapon() )
		return;

	Super.NextWeapon();
}

/*function AllAmmo(optional bool bAmmoForSuperWeapons)
{
	Super.AllAmmo(bAmmoForSuperWeapons);

	for(var int Inv=InventoryChain; Inv!=None; Inv=Inv.Inventory )
		if ( (HBWeapon(Inv)!=None) && (bAmmoForSuperWeapons || !HBWeapon(Inv).bSuperWeapon) )
			HBWeapon(Inv).Loaded(true);
}*/

/*
 * Accessor for the server to begin a weapon switch on the client.
 *
 * @param    DesiredWeapon        The Weapon to switch to
 */
 
//reliable client function ClientSetCurrentWeapon(Weapon DesiredWeapon)
//{
// 	SetPendingWeapon(DesiredWeapon);
//}

simulated function SetPendingWeapon( Weapon DesiredWeapon )
{
	local HBWeapon PrevWeapon, CurrentPending;
	local HBPawn HBP;

	if (Instigator == None)
	{
		return;
	}

	PrevWeapon = HBWeapon( Instigator.Weapon );
	CurrentPending = HBWeapon(PendingWeapon);

	if ( (PrevWeapon == None || PrevWeapon.AllowSwitchTo(DesiredWeapon)) &&
		(CurrentPending == None || CurrentPending.AllowSwitchTo(DesiredWeapon)) )
	{
		// We only work with UTWeapons
		// Detect that a weapon is being reselected.  If so, notify that weapon.
		if ( DesiredWeapon != None && DesiredWeapon == Instigator.Weapon )
		{
			if (PendingWeapon != None)
			{
				PendingWeapon = None;
			}
			else
			{
				PrevWeapon.ServerReselectWeapon();
			}

			// If this weapon is ready to fire, there is no reason to perform the whole switch logic.
			if (!PrevWeapon.bReadyToFire())
			{
				PrevWeapon.Activate();
			}
			else
			{
				PrevWeapon.bWeaponPutDown = false;
			}
		}
		else
		{
			if ( Instigator.IsHumanControlled() && Instigator.IsLocallyControlled() )
			{
				// preload pending weapon textures, clear any other preloads
				if ( HBWeapon(Instigator.Weapon) != None )
				{
					HBWeapon(Instigator.Weapon).PreloadTextures(false);
				}
				if ( PendingWeapon != None )
				{
					HBWeapon(PendingWeapon).PreloadTextures(false);
				}
	 			HBWeapon(DesiredWeapon).PreloadTextures(true);
			}
			PendingWeapon = DesiredWeapon;

			// if there is an old weapon handle it first.
			if( PrevWeapon != None && !PrevWeapon.bDeleteMe && !PrevWeapon.IsInState('Inactive') )
			{
				PrevWeapon.TryPutDown();
			}
			else
			{
				// We don't have a weapon, force the call to ChangedWeapon
				ChangedWeapon();
			}
		}
	}

	HBP = HBPawn(Instigator);
	if (HBP != None)
	{
		HBP.SetPuttingDownWeapon((PendingWeapon != None));
	}
}

 
//simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
//{
// 	if (Role==ROLE_Authority)
// 	{
// 		return Super.CreateInventory(NewInventoryItemClass, bDoNotActivate);
// 	}
// 	return none;
//}

simulated function ProcessRetrySwitch()
{
	local HBWeapon NewWeapon;

	Super.ProcessRetrySwitch();
}

/*simulated function RetrySwitchTo(HBWeapon NewWeapon)
{
	Super.RetrySwitchTo(NewWeapon);
}*/

/** checks if we should autoswitch to this weapon (server)
simulated function CheckSwitchTo(HBWeapon NewWeapon)
{
	if ( HBWeapon(Instigator.Weapon) == None ||
			( Instigator != None && PlayerController(Instigator.Controller) != None &&
				HBWeapon(Instigator.Weapon).ShouldSwitchTo(NewWeapon) ) )
	{
		NewWeapon.ClientWeaponSet(true);
	}
} */


/*
 * Handle AutoSwitching to a weapon
 */
simulated function bool AddInventory( Inventory NewItem, optional bool bDoNotActivate )
{
	local bool bResult;
	local int i;

	if (Role == ROLE_Authority)
	{
		bResult = super(InventoryManager).AddInventory(NewItem, bDoNotActivate);

		if (bResult && UTWeapon(NewItem) != None)
		{
			// Check to see if we need to give it any extra ammo the pawn has picked up
			for (i=0;i<AmmoStorage.Length;i++)
			{
				if (AmmoStorage[i].WeaponClass == NewItem.Class)
				{
					HBWeapon(NewItem).AddAmmo(AmmoStorage[i].Amount);
					AmmoStorage.Remove(i,1);
					break;
				}
			}
			
			for (i=0;i<TotalAmmoStorage.Length;i++)
			{
				if (TotalAmmoStorage[i].WeaponClass == NewItem.Class)
				{
					HBWeapon(NewItem).AddTotalAmmo(TotalAmmoStorage[i].Amount);
					TotalAmmoStorage.Remove(i,1);
					break;
				}
			}
			if (!bDoNotActivate)
			{
				CheckSwitchTo(UTWeapon(NewItem));
			}
		}
	}

	return bResult;
}

 
//simulated function DiscardInventory()
//{
// 	local Vehicle V;
// 
// 	if (Role == ROLE_Authority)
// 	{
// 		Super.DiscardInventory();
// 
// 		V = Vehicle(Owner);
// 		if (V != None && V.Driver != None && V.Driver.InvManager != None)
// 		{
// 			V.Driver.InvManager.DiscardInventory();
// 		}
// 	}
//}
 
//simulated function RemoveFromInventory(Inventory ItemToRemove)
//{
// 	if (Role==ROLE_Authority)
// 	{
// 		Super.RemoveFromInventory(ItemToRemove);
// 	}
//}
/*
 * Scans the inventory looking for any of type InvClass.  If it finds it it returns it, other
 * it returns none.
 */
//function Inventory HasInventoryOfClass(class<Inventory> InvClass)
//{
// 	local inventory inv;
//
// 	inv = InventoryChain;
//	while(inv!=none)
//	{
// 		if (Inv.Class==InvClass)
// 			return Inv;
// 
// 		Inv = Inv.Inventory;
// 	}
// 	return none;
//}
 
/*
 * Store the last used weapon for later
 */
simulated function ChangedWeapon()
{
	local HBWeapon Wep;
	local HBPawn HBP;

	Super.ChangedWeapon();

	Wep = HBWeapon(Instigator.Weapon);

	HBP = HBPawn(Instigator);
	if (HBP != None)
	{
		HBP.SetPuttingDownWeapon((PendingWeapon != None));
	}
}

//simulated function SwitchToPreviousWeapon()
//{
// 	if ( PreviousWeapon!=none && PreviousWeapon != Pawn(Owner).Weapon )
// 	{
// 		PreviousWeapon.ClientWeaponSet(false);
// 	}
//}

function bool NeedsAmmo(class<UTWeapon> TestWeapon)
{
    local array <UTWeapon> WeaponList;
	local int i;

	// Check the list of weapons
	GetWeaponList(WeaponList);
	for (i=0;i<WeaponList.Length;i++)
	{
		if ( ClassIsChildOf(WeaponList[i].Class, TestWeapon) )	// The Pawn has this weapon
		{
			if ( HBWeapon(WeaponList[i]).TotalAmmoCount < HBWeapon(WeaponList[i]).MaxAmmoCount )
				return true;
			else
				return false;
		}
	}

	// Check our stores.
	for (i=0;i<AmmoStorage.Length;i++)
	{
		if ( ClassIsChildOf(WeaponList[i].Class, TestWeapon) )
		{
			if ( TotalAmmoStorage[i].Amount < TestWeapon.default.MaxAmmoCount )
				return true;
			else
				return false;
		}
	}

	return true;

}

function AddAmmoToWeapon(int AmountToAdd, class<UTWeapon> WeaponClassToAddTo)
{
	local array<UTWeapon> WeaponList;
	local int i;

	// Get the list of weapons

	GetWeaponList(WeaponList);
	for (i=0;i<WeaponList.Length;i++)
	{
		if ( ClassIsChildOf(WeaponList[i].Class, WeaponClassToAddTo) )	// The Pawn has this weapon
		{
			HBWeapon(WeaponList[i]).AddTotalAmmo(AmountToAdd);
			return;
		}
	}

	// Add to to our stores for later.

	for (i=0;i<TotalAmmoStorage.Length;i++)
	{

		// We are already tracking this type of ammo, so just increment the ammount

		if (TotalAmmoStorage[i].WeaponClass == WeaponClassToAddTo)
		{
			TotalAmmoStorage[i].Amount += AmountToAdd;
			return;
		}
	}

	// Track a new type of ammo

	i = TotalAmmoStorage.Length;
	TotalAmmoStorage.Length = TotalAmmoStorage.Length + 1;
	TotalAmmoStorage[i].Amount = AmountToAdd;
	TotalAmmoStorage[i].WeaponClass = class<HBWeapon>(WeaponClassToAddTo);

}

/**
 * Hook called from HUD actor. Gives access to HUD and Canvas
 *
 * @param	H	HUD
 */
simulated function DrawHud(HUD H)
{
	// Send ActiveRenderOverlays event to active weapon
	if( HBWeapon(Instigator.Weapon) != None )
	{
		HBWeapon(Instigator.Weapon).ActiveRenderOverlays(H);
	}
}


defaultproperties
{
}