class AwesomeWeapon extends UTWeapon;

const MAX_LEVEL = 5;
var int CurrentWeaponLevel;
var float FireRates[MAX_LEVEL];

//Upgrade Weapon, based on grade of the item
simulated function UpgradeWeapon(int grade)
{

        FireInterval[0] = FireRates[grade];
        ServerUpgradeWeapon(grade);

}

replication
{
        if(bNetDirty)
        CurrentWeaponLevel;
}

defaultproperties
{

        FireRates(0)=1.5
        FireRates(1)=1.0
        FireRates(2)=0.5
        FireRates(3)=0.3
        FireRates(4)=0.1

        FireInterval[0] = 0.3
}

// tell the server to upgrade them too

reliable server function ServerUpgradeWeapon(int grade)
{

        FireInterval[0] = FireRates[grade];

}
