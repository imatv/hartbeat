class HBInventoryManager extends InventoryManager
	config(Game);

// Holds the last weapon used
var Weapon PreviousWeapon;
 
simulated function GetWeaponList(out array<HBWeapon> WeaponList, optional bool bNoEmpty)
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
}
/*
 * Accessor for the server to begin a weapon switch on the client.
 *
 * @param    DesiredWeapon        The Weapon to switch to
 */
 
reliable client function ClientSetCurrentWeapon(Weapon DesiredWeapon)
{
 	SetPendingWeapon(DesiredWeapon);
}
 
simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
 	if (Role==ROLE_Authority)
 	{
 		return Super.CreateInventory(NewInventoryItemClass, bDoNotActivate);
 	}
 	return none;
}
/*
 * Handle AutoSwitching to a weapon
 */
simulated function bool AddInventory( Inventory NewItem, optional bool bDoNotActivate )
{
 	local bool bResult;
 
 	if (Role == ROLE_Authority)
 	{
 		bResult = super.AddInventory(NewItem, bDoNotActivate);
 	}
 	return bResult;
}
 
simulated function DiscardInventory()
{
 	local Vehicle V;
 
 	if (Role == ROLE_Authority)
 	{
 		Super.DiscardInventory();
 
 		V = Vehicle(Owner);
 		if (V != None && V.Driver != None && V.Driver.InvManager != None)
 		{
 			V.Driver.InvManager.DiscardInventory();
 		}
 	}
}
 
simulated function RemoveFromInventory(Inventory ItemToRemove)
{
 	if (Role==ROLE_Authority)
 	{
 		Super.RemoveFromInventory(ItemToRemove);
 	}
}
/*
 * Scans the inventory looking for any of type InvClass.  If it finds it it returns it, other
 * it returns none.
 */
function Inventory HasInventoryOfClass(class<Inventory> InvClass)
{
 	local inventory inv;
 
 	inv = InventoryChain;
	while(inv!=none)
	{
 		if (Inv.Class==InvClass)
 			return Inv;
 
 		Inv = Inv.Inventory;
 	}
 	return none;
}
 
/*
 * Store the last used weapon for later
 */
simulated function ChangedWeapon()
{
 	PreviousWeapon = Instigator.Weapon;
 	Super.ChangedWeapon();
}
 
simulated function SwitchToPreviousWeapon()
{
 	if ( PreviousWeapon!=none && PreviousWeapon != Pawn(Owner).Weapon )
 	{
 		PreviousWeapon.ClientWeaponSet(false);
 	}
}

function bool NeedsAmmo(class<HBWeapon> TestWeapon)
{
    local array WeaponList;
    local int i;

    // Check the list of weapons
    GetWeaponList(WeaponList);
    for (i=0;i<WeaponList.Length;i++)
    {
        if ( ClassIsChildOf(WeaponList[i].Class, TestWeapon) )// Pawn has this weapon
        {
            //This will check if our current clip is lesser than Maximum clips defined in MyWeapon
            if ( MyWeapon(WeaponList[i]).clips < MyWeapon(WeaponList[i]).MaxClips )
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
            if ( AmmoStorage[i].Amount < TestWeapon.default.MaxAmmoCount )
                //MyWeapon can pickup clips. So return true
                return true;
            else
                //MyWeapon cannot pickup clips because clips is equal to MaxClips
                return false;
        }
    }

    return true;

}

function AddAmmoToWeapon(int AmountToAdd, class<HBWeapon> WeaponClassToAddTo)
{
	local array<HBWeapon> WeaponList;
	local int i;

	// Get the list of weapons

	GetWeaponList(WeaponList);
	for (i=0;i<WeaponList.Length;i++)
	{
		if ( ClassIsChildOf(WeaponList[i].Class, WeaponClassToAddTo) )	// The Pawn has this weapon
		{
			WeaponList[i].AddAmmo(AmountToAdd);
			return;
		}
	}

	// Add to to our stores for later.

	for (i=0;i<AmmoStorage.Length;i++)
	{

		// We are already tracking this type of ammo, so just increment the ammount

		if (AmmoStorage[i].WeaponClass == WeaponClassToAddTo)
		{
			AmmoStorage[i].Amount += AmountToAdd;
			return;
		}
	}
	
	local array WeaponInv;
    local int j;
    GetWeaponList(WeaponInv);
    for (j=0;j<WeaponInv.Length;j++)
    {
        if ( ClassIsChildOf(WeaponInv[j].Class, WeaponClassToAddTo) ) // Pawn has this weapon
        {
            MyWeapon(WeaponInv[j]).AddClip(1);
        }
    }

	// Track a new type of ammo

	i = AmmoStorage.Length;
	AmmoStorage.Length = AmmoStorage.Length + 1;
	AmmoStorage[i].Amount = AmountToAdd;
	AmmoStorage[i].WeaponClass = WeaponClassToAddTo;

}

defaultproperties
{
 	bMustHoldWeapon=true
 	PendingFire(0)=0
 	PendingFire(1)=0
}