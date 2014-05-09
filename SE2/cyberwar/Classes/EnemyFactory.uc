class EnemyFactory extends Actor
placeable;



var Enemy MySpawnedBot;
var int ID;
var () array<NavigationPoint> MyNavigationPoints;//for patrol route
var () bool isSpecial;
var () Arrow Arrow;

var () bool RED_BOT;
var () bool GREEN_BOT;
var () bool BLUE_BOT;
var () bool WHITE_BOT;

enum Type {

	BLUE_BOT,
	GREEN_BOT,
	RED_BOT,
	WHITE_BOT,
	BOSS_TYPE,

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

function SpawnEnemy()
{

        if(RED_BOT)
                MySpawnedBot = spawn(class'RedBot', self,,Location);
        if(GREEN_BOT)
                MySpawnedBot = spawn(class'GreenBot', self,,Location);
        if(BLUE_BOT)
                MySpawnedBot = spawn(class'BlueBot', self,,Location);
        if(WHITE_BOT)
                MySpawnedBot = spawn(class'WhiteBot', self,,Location);

        MySpawnedBot.SetOwner(self);
        MySpawnedBot.BotID = ID;
        MySpawnedBot.registerArrow(Arrow);

}

function EnemyDied()
{

        SetTimer(2, false, 'SpawnEnemyRandomly');
      // MySpawnedBot.Location = Location;

}

function SpawnEnemyRandomly()
{

     //   local int RandomNumber;

     //   RandomNumber = Rand(3);

        SpawnEnemy();
}

function SpawnBoss()
{
                MySpawnedBot = spawn(class'Boss', self,,Location);
                MySpawnedBot.SetOwner(self);
                MySpawnedBot.setHidden(true);
                MySpawnedBot.isDead = true;
}

function activateBoss()
{
        MySpawnedBot.setHidden(false);
        MySpawnedBot.isDead = false;
}


