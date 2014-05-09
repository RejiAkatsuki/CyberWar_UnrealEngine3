class AwesomePawn extends UTPawn;

var int HP;
var bool bWalking;
var Item items[6];
var int MAX_ITEMS;
var SQLProject_Manager SQLManager;
var String PType;
var ItemFactory factory;

var bool bPKMode;
//compute health bar
event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        
        if(!bPKMode)
        {
        HP -= 1;

                if(HP <= 0)
                   Killed();
        }
        else
        {
                Health -= 50;

                if(Health <= 0)
                   Killed();
        }


      




}

//for respawn
function Killed()
{
        HP = 100;
        Health = 100;
        SetLocation(self.Owner.Location);
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0025.000000
		CollisionHeight=+0044.000000
	End Object


        MAX_ITEMS = 6;
        HP = 100;
        bPKMode = false;
}



replication
{
        if(bNetDirty)
        bPKMode ;
}

function AddRocketLaucher()
{

        local AwesomeWeapon_RocketLauncher NewWeapon;

        NewWeapon = Spawn(Class'AwesomeWeapon_RocketLauncher');
        NewWeapon.GiveTo(Self);
}

function AddGreenLinkGun()
{

        local AwesomeWeapon_GreenLinkGun NewWeapon;

        NewWeapon = Spawn(Class'AwesomeWeapon_GreenLinkGun');
        NewWeapon.GiveTo(Self);
}

function AddWhiteLinkGun()
{

        local AwesomeWeapon_LinkGun NewWeapon;

        NewWeapon = Spawn(Class'AwesomeWeapon_LinkGun');
        NewWeapon.GiveTo(Self);
}

function AddShockRifle()
{
        local AwesomeWeapon_ShockRifle NewWeapon;

        NewWeapon = Spawn(Class'AwesomeWeapon_ShockRifle');
        NewWeapon.GiveTo(Self);

}

simulated function changeGun()
{
AddRocketLaucher();
ClientChangeGun();
ServerChangeGun();
`log("ROCKET!");
}

reliable client function ClientChangeGun()
{
    AddRocketLaucher();
    `log("Client ROCKET!");
}

reliable server function ServerChangeGun()
{
    AddRocketLaucher();
    `log("Client ROCKET!");
}

function bool init(String PlayerType)
{
        local int index;
        local string itemName;

        PType = PlayerType;

        if(PlayerType == "Red")
        AddRocketLaucher();

        if(PlayerType == "Green")
        AddGreenLinkGun();

        if(PlayerType == "Blue")
        AddShockRifle();

        if(PlayerType == "White")
        AddWhiteLinkGun();



           
           for(index = 1; index < MAX_ITEMS + 1; index++)
           {
                itemName = SQLManager.GetItems(PlayerReplicationInfo.PlayerName,PlayerType,index);
                factory.GiveItem(itemName,self);
           }
                



        initClient(PlayerType);




        return true;
}


reliable server function initClient(String PlayerType)
{

        local int index;
        local string itemName;
        PType = PlayerType;

        if(PlayerType == "Red")
        AddRocketLaucher();

        if(PlayerType == "Green")
        AddGreenLinkGun();

        if(PlayerType == "Blue")
        AddShockRifle();

        if(PlayerType == "White")
        AddWhiteLinkGun();





}


simulated function PostBeginPlay()
{

        super.PostBeginPlay();
        SQLManager = spawn(class'SQLProject_Manager');
        factory = spawn(class'ItemFactory');

InvManager.CreateInventory(class'AwesomeWeapon_RocketLauncher'); //InvManager is the pawn's InventoryManager
InvManager.CreateInventory(class'AwesomeWeapon_ShockRifle');
InvManager.CreateInventory(class'AwesomeWeapon_LinkGun'); // Don't forget the ' in class'MyGame.MG_Weap_Barrett'


}




simulated function addItem(Item item)
{



        ClientAddItem(item);




}


// tell the client to add them too
reliable client function ServerAddItem(int SlotNumber,Item item)
{
        if(item.type != "")
        SQLManager.AddItem(PlayerReplicationInfo.PlayerName,PType,SlotNumber,item.type);
}

// tell the client to add them too
reliable client function ClientAddItem(Item item)
{

        local int index;

        for(index = 0; index < MAX_ITEMS ; index++)
        {
        
                if(items[index] == none)
                {
                        items[index] = item;
                        ServerAddItem(index + 1,item);
                         return;
                }

        }


}



    


