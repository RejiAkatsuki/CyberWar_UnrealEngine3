class CyberGame extends UTGame;

//Hold all the factories
var array<EnemyFactory> EnemySpawners;
var array<ItemFactory> ItemSpawners;

//Hold wave information
var int EnemiesLeft;

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local PlayerController PC;
   // local CyberPlayerController CPC;
    local string PlayerType;
    local string Username;
    local string ItemString;

    PC = Super.Login(Portal, Options, UniqueId, ErrorMessage);

    PlayerType = ParseOption(Options, "PlayerType");
    Username = ParseOption(Options, "Username");


     CyberPlayerController(PC).SetPlayerType(Username,PlayerType);

    return PC;
}



//Scoring
function ScoreObjective(PlayerReplicationInfo Scorer, Int Score)
{
        EnemiesLeft--;
        super.ScoreObjective(Scorer, Score);

        //release boss if wave is completed
        if(EnemiesLeft <= 0)
        {
        ActivateBoss();
        EnemiesLeft = 3;
        }

}

event InitGame( string Options, out string ErrorMessage )
{
    Super.InitGame(Options, ErrorMessage);
    `log("**********" @ Options);
    BroadcastHandler = spawn(BroadcastHandlerClass);
}

event Broadcast( Actor Sender, coerce string Msg, optional name btype )
{
    local CyberPlayerController PC;
    local PlayerReplicationInfo PRI;

    // This code gets the PlayerReplicationInfo of the sender. We'll use it to get the sender's name with PRI.PlayerName
    if ( Pawn(Sender) != None )
        PRI = Pawn(Sender).PlayerReplicationInfo;
    else if ( Controller(Sender) != None )
	PRI = Controller(Sender).PlayerReplicationInfo;
	
	// This line executes a "Say"
    BroadcastHandler.Broadcast(Sender,Msg,btype);

   // This is where we broadcast the received message to all players (PlayerControllers)
    if (WorldInfo != None)
    {
	foreach WorldInfo.AllControllers(class'CyberPlayerController',PC)
	{
	    `Log(Self$":: Sending "$PC$" a broadcast message from "$PRI.PlayerName$" which is '"$Msg$"'.");
	     PC.ReceiveBroadcast(PRI.PlayerName, Msg);
	}
    }
}

//Initialize necessary variables
defaultproperties
{

        PlayerControllerClass = class 'CyberPlayerController'
        HUDType = class 'MouseInterfaceHUD'
        DefaultPawnClass = class 'AwesomePawn'
        GameReplicationInfoClass = class 'AwesomeGameReplicationInfo'
        BroadcastHandlerClass=class'Engine.BroadcastHandler'
      //  DefaultInventory = class 'CustomInventory'
        bUseClassicHUD = true
        bDelayedStart = false

        EnemiesLeft = 3;
}

//Loading functions before playing
function PostBeginPlay()
{       

        local EnemyFactory EF;
        local ItemFactory ItF;

        super.PostBeginPlay();
                
                //Find all factories on map and load them into a dynamic array
                foreach DynamicActors(class'EnemyFactory', EF)
                        EnemySpawners[EnemySpawners.length] = EF;

                foreach DynamicActors(class'ItemFactory', ItF)
                        ItemSpawners[ItemSpawners.length] = ItF;
                        
                ActivateSpawners();
}


//Make factory spawns enemies randomly
function ActivateSpawners()
{
        local int i;

        for(i=0; i<EnemySpawners.length; i++)
        {
                 EnemySpawners[i].ID = i;
                 
                 //If the spawner is special, it will wait for 
                 //instructions.
                 //isSpecial variable is determine in UDK editor
                 if(!EnemySpawners[i].isSpecial)
                 EnemySpawners[i].SpawnEnemyRandomly();
                 else
                 EnemySpawners[i].SpawnBoss();
        }
        
        for(i=0; i<ItemSpawners.length; i++)
        {
                 ItemSpawners[i].SpawnItemRandomly();
        }

}

//Make factory spawns boss
function ActivateSpecialSpawners()
{
        local int i;

        for(i=0; i<EnemySpawners.length; i++)
        {

                 if(EnemySpawners[i].isSpecial)
                 EnemySpawners[i].SpawnBoss();
        }
        

}

//Make Boss appear
function ActivateBoss()
{
        local int i;

        for(i=0; i<EnemySpawners.length; i++)
        {

                 if(EnemySpawners[i].isSpecial)
                 EnemySpawners[i]. activateBoss();
        }
        

}

