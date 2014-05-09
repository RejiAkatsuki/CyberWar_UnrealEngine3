class CyberGame extends UTGame;

//Hold all the factories
var array<EnemyFactory> EnemySpawners;
var array<ItemFactory> ItemSpawners;

//Hold wave information
var int EnemiesLeft;
var int Wave;
var soundcue soundSample;
var bool PvpMode;
//Loading functions before playing
simulated function PostBeginPlay()
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

        EnemiesLeft = 10 ;
        GoalScore = 55;
        Wave = 0;
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local PlayerController PC;
   // local CyberPlayerController CPC;
    local string PlayerType;
    local string Username;


    PC = Super.Login(Portal, Options, UniqueId, ErrorMessage);

    PlayerType = ParseOption(Options, "PlayerType");
    Username = ParseOption(Options, "Username");

    CyberPlayerController(PC).PlayerReplicationInfo.PlayerName = Username;
    CyberPlayerController(PC).SetPlayerType(Username,PlayerType);

    return PC;
}

//Scoring
function ScoreObjective(PlayerReplicationInfo Scorer, Int Score)
{

        super.ScoreObjective(Scorer, Score);

        //End game condition
        if(Scorer.Score == 30)
        EndGameHandling(Scorer.PlayerName);
        else
        checkConditions();
        
        //Start PVP phase when wave equals 5
        if(Scorer.Score % 20 == 0 && !PvpMode)
        {
           PvpMode = true;
           startPVP();
           AnnounceAll("PVP Phase Commenced!");
        }

}

function EndGameHandling(String Winner)
{
         local Controller P;
    // all player cameras focus on winner
    foreach WorldInfo.AllControllers(class'Controller', P)
    {
        P.GameHasEnded();
        AnnounceAll(Winner @ "Won!");
    }

    SetTimer(2, false, 'quit');
}

function quit()
{
  ConsoleCommand("Quit");
}

function checkConditions()
{
        EnemiesLeft--;



        if(EnemiesLeft <= 0)
        {
        //increment waves when a wave is completed
        Wave ++;
        //Reset wave
         EnemiesLeft = 10 ;
        //Anounce wave
        AnnounceAll("Wave COmpleted");
        //Repsawn bots when wave completed
        RespawnBots();
        }

        //For every 2 waves, release boss and upgrade bots
        if (Wave % 2 == 0 && Wave != 0)
        {
            UpgradeSpawners();
            ActivateBoss();
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

function startPVP()
{
        local CyberPlayerController PC;
        if (WorldInfo != None)
        {
	foreach WorldInfo.AllControllers(class'CyberPlayerController',PC)
	{
	    PC.PlayerReplicationInfo.Score = 0;
	}
        }
}

function KillAll()
{
        local CyberPlayerController PC;
        if (WorldInfo != None)
        {
	foreach WorldInfo.AllControllers(class'CyberPlayerController',PC)
	{
	    PC.Terminate();
	}
        }
}

function AnnounceAll(String ann)
{
        local CyberPlayerController PC;
        if (WorldInfo != None)
        {
	foreach WorldInfo.AllControllers(class'CyberPlayerController',PC)
	{
	    PC.ReceiveAnnouncement(ann);
	}
        }
}

//Initialize necessary variables
defaultproperties
{

        PlayerControllerClass = class 'CyberPlayerController'
        HUDType = class 'MouseInterfaceHUD'
        DefaultPawnClass = class 'AwesomePawn'
        BroadcastHandlerClass=class'Engine.BroadcastHandler'
      //  soundSample = SoundCue'MyPackage.Theme'

        bUseClassicHUD = true
        bDelayedStart = false
        PvpMode = false

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


}

//Make factory spawns enemies randomly
function RespawnBots()
{
        local int i;

        for(i=0; i<EnemySpawners.length; i++)
        {
                 EnemySpawners[i].ID = i;

                 //If the spawner is special, it will wait for 
                 //instructions.
                 //isSpecial variable is determine in UDK editor
                 if(!EnemySpawners[i].isSpecial)
                 EnemySpawners[i].RespawnBot();

        }


}

function UpgradeSpawners()
{
        local int i;

        for(i=0; i<EnemySpawners.length; i++)
        {
                 EnemySpawners[i].Upgrade();
                 

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

