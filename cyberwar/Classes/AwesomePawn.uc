class AwesomePawn extends UTPawn;

var int HP;
var bool bWalking;
var Item items[6];
var int MAX_ITEMS;
var SQLProject_Manager SQLManager;
var String PType;
var ItemFactory factory;
var int Level;
var int XP;
var int Damage;
var int HalvedDamage;
var int BaseDamage;
var bool bPKMode;
//compute health bar
event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        if(bPKMode)
        {
            Health -= 50;
            if(Health <= 0)
            Killed();
        }
        else
        {
            HP -= 1;

            if(HP <= 0)
             Killed();
        }




}

//When died, re-init eveything
function Killed()
{
        SQLManager.Wipe(PlayerReplicationInfo.PlayerName,PType);
        SetLocation(Owner.Location);
        HP = 202;
        Health = 202;
        bPKMode = false;
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0025.000000
		CollisionHeight=+0044.000000
	End Object


        MAX_ITEMS = 6;
        HP = 200;
        Health = 200;
        bPKMode = false;
        Damage = 20;
        XP = 0;
}



replication
{
        if(bNetDirty)
        bPKMode,Level,HP,Damage ;
}




function bool init(String PlayerType)
{

        initInventory(PlayerType);
        Level = int(SQLManager.GetLevel(PlayerReplicationInfo.PlayerName,PlayerType));
        StatModifier();

        //Tell clients to  init variables
        initClient(PlayerType,Level);




        return true;
}

//Modify health based on level
 function StatModifier()
{
    HP = HP + (HP * Level)/100;
    Health = Health + (Health * Level)/100;
    Damage = Damage + (Damage * Level)/100;
    HalvedDamage = Damage /2;
    BaseDamage = Damage;
}
 //Tell clients to  init variables
reliable client function initInventory(String PlayerType)
{
        local int index;
        local string itemName;

        PType = PlayerType;



           for(index = 1; index < MAX_ITEMS + 1; index++)
           {
                itemName = SQLManager.GetItems(PlayerReplicationInfo.PlayerName,PlayerType,index);
                factory.GiveItem(itemName,self);
           }


}

 //Tell clients to  init variables
reliable client function InventoryWorkaround(String PlayerType)
{
        local int index;
        local string itemName;

        PType = PlayerType;



           for(index = 1; index < MAX_ITEMS + 1; index++)
           {
                itemName = SQLManager.GetItems(PlayerReplicationInfo.PlayerName,PlayerType,index);
                factory.GiveItem(itemName,self);
           }


}

 //Tell clients to  init variables
reliable server function initClient(String PlayerType,int lev)
{
        //initInventory(String PlayerType)
        Level = lev;
        
        StatModifier();
        PType = PlayerType;
        
        if(PlayerType == "White")
        InvManager.GetWeapon(0);
        if(PlayerType == "Red")
        InvManager.GetWeapon(1);
        if(PlayerType == "Blue")
        InvManager.GetWeapon(2);
        if(PlayerType == "Green")
        InvManager.GetWeapon(3);
}

 //Tell server to re-init damage
reliable server function SetAttackDamage(int dmg)
{
        Damage = dmg;
}


simulated function PostBeginPlay()
{

        super.PostBeginPlay();

        SQLManager = spawn(class'SQLProject_Manager');
        factory = spawn(class'ItemFactory');

        InvManager.CreateInventory(class'AwesomeWeapon_LinkGun');
        InvManager.CreateInventory(class'AwesomeWeapon_RocketLauncher'); //InvManager is the pawn's InventoryManager
        InvManager.CreateInventory(class'AwesomeWeapon_ShockRifle');
        InvManager.CreateInventory(class'AwesomeWeapon_GreenLinkGun'); // Don't forget the ' in class'MyGame.MG_Weap_Barrett'
        
	if(PType == "White")
        InvManager.GetWeapon(0);
        if(PType == "Red")
        InvManager.GetWeapon(1);
        if(PType == "Blue")
        InvManager.GetWeapon(2);
        if(PType == "Green")
        InvManager.GetWeapon(3);

}

reliable client function Save()
{
        local int i;
        
        for (i = 1; i< MAX_ITEMS + 1; i++)
        {
                `log('SAVE  ' @ items[i - 1] );
                if(items[i] != none)
                SQLManager.AddItem(PlayerReplicationInfo.PlayerName,PType,i,items[i - 1].type);
        }


}



// tell the client to add them too
reliable client function ServerAddItem(int SlotNumber,Item item)
{
      //  if(item.type != "")
     //   SQLManager.AddItem(PlayerReplicationInfo.PlayerName,PType,SlotNumber,item.type);
}

function AddItem(Item item)
{

//        NormalAddItem(item);
        ClientAddItem(item);

}

// tell the client to add them too
 function NormalAddItem(Item item)
{

        local int index;

        for(index = 0; index < MAX_ITEMS ; index++)
        {

                if(items[index] == none)
                {
                        items[index] = item;
                        return;
                }

        }


}

reliable client function ClientAddItem(Item item)
{

        local int index;
 //       if(items[0] == none)
 //       InventoryWorkaround(PType);

        for(index = 0; index < MAX_ITEMS ; index++)
        {

                if(items[index] == none)
                {
                        items[index] = item;
                        SQLManager.AddItem(PlayerReplicationInfo.PlayerName,PType,index + 1,item.type);
                        return;
                }

        }


}


//This function is called when player killed a bot
function addXP(int exp)
{
        XP += exp;
        ServerAddXP(exp);
}

//Call server to update XP
reliable client function ServerAddXP(int exp)
{
        XP += exp;
        checkXP();
}

//Check to see if player has enogh exp to level up
function checkXP()
{
        if(XP % 100 == 0)
        {

        ServerAddLevel();
        SQLManager.UpdateLevel(PlayerReplicationInfo.PlayerName,PType,Level);

        }

}
reliable client function ServerAddLevel()
{
        Level += 1;
}


    


