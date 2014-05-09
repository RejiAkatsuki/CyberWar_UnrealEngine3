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

function Upgrade()
{
        MySpawnedBot.HP = MySpawnedBot.HP + (MySpawnedBot.HP * 10)/100;
}

function SpawnEnemy()
{

        if(RED_BOT)
                MySpawnedBot = spawn(class'Enemy_Red', self,,Location);
        if(GREEN_BOT)
                MySpawnedBot = spawn(class'Enemy_Green', self,,Location);
        if(BLUE_BOT)
                MySpawnedBot = spawn(class'Enemy_Blue', self,,Location);
        if(WHITE_BOT)
                MySpawnedBot = spawn(class'Enemy_White', self,,Location);

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

function RespawnBot()
{
        MySpawnedBot.resurrect();
}


