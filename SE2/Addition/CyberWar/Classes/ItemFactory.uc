class ItemFactory extends Actor
placeable;

var Item item;

enum Type {

	ARMOR_TYPE,
	HELMET_TYPE,
	WEAPON_TYPE,

};

//initialize
defaultproperties
{

        Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=True
        End Object

        Components.Add(Sprite)


}

function SpawnItem(int EnemyTypeRequested,vector DropPoint)
{

        switch(EnemyTypeRequested)
        {
                case 0:
                item = spawn(class'Item_RedMedal', self,,DropPoint);
                item.SetOwner(self);
                break;

                case 1:
                item = spawn(class'Item_GreenMedal', self,,DropPoint);
                item.SetOwner(self);
                break;

                case 2:
                item = spawn(class'Item_WhiteMedal', self,,DropPoint);
                item.SetOwner(self);
                break;

                case 3:
                item = spawn(class'Item_BlueMedal', self,,DropPoint);
                item.SetOwner(self);
                break;

        }

}

function GiveItem(String ItemName,Pawn P)
{


        if(ItemName == "GreenMedal")
                spawn(class'Item_GreenMedal',,,P.Location);

        if(ItemName == "RedMedal")
              spawn(class'Item_RedMedal',,,P.Location);

        if(ItemName == "WhiteMedal")
              spawn(class'Item_WhiteMedal',,,P.Location);

        if(ItemName == "BlueMedal")
              spawn(class'Item_BlueMedal',,,P.Location);


        
        



}

function EnemyDied()
{

        SetTimer(2, false, 'SpawnEnemyRandomly');
      // MySpawnedBot.Location = Location;

}

function SpawnItemRandomly(vector DropPoint)
{

        local int RandomNumber;

        RandomNumber = Rand(11);

        SpawnItem(1,DropPoint);
}


