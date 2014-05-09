/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */

class CustomInventory extends InventoryManager;

simulated function NextWeapon2()
{
	local Weapon	StartWeapon, CandidateWeapon, W;
	local bool		bBreakNext;

	StartWeapon = Instigator.Weapon;
	if( PendingWeapon != None )
	{
		StartWeapon = PendingWeapon;
	}

	ForEach InventoryActors( class'Weapon', W )
	{
		if( bBreakNext || (StartWeapon == None) )
		{
			CandidateWeapon = W;
			break;
		}
		if( W == StartWeapon )
		{
			bBreakNext = true;
		}
	}

	if( CandidateWeapon == None )
	{
		ForEach InventoryActors( class'Weapon', W )
		{
			CandidateWeapon = W;
			break;
		}
	}
	// If same weapon, do not change
	if( CandidateWeapon == Instigator.Weapon )
	{
		return;
	}

	SetCurrentWeapon(CandidateWeapon);
}

defaultproperties
{
 PendingFire(0)=0
PendingFre(1)=0   
}

