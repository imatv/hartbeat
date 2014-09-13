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

defaultproperties
{
}