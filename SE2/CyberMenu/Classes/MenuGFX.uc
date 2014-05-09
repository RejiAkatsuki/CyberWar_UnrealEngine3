class MenuGFX extends GFxMoviePlayer;

var WorldInfo ThisWorld;


//Called from STHUD'd PostBeginPlay()
function Init2()
{
	//Start and load the SWF Movie
	Start();
	Advance(0.f);
	
	ThisWorld = GetPC().WorldInfo;

}




//join a game
function JoinFunction()
{
        //open the ip address in the textinput
         `log('---------------------JOINED');
         ConsoleCommand("open 127.0.0.1");
}

// Host a game
function HostFunction()
{
        //open a map as a listen server, change DM-Deck to your map
          `log('---------------------HOSTED');
        ConsoleCommand("open AwesomeTestMapUpdate?GoalScore=0?TimeLimit=0?Game=cyberwar.CyberGame?Listen");
        `log('---------------------HOSTED');
}

DefaultProperties
{
        //this is the HUD. If the HUD is off, then this should be off
       // bDisplayWithHudOff=false
        //The path to the swf asset we will create later
        MovieInfo=SwfMovie'Hotshot.MainScreen'
}