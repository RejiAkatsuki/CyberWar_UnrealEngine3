class MyDerivedGFxMoviePlayer extends GFxMoviePlayer
    dependson(DB_DLLAPI)
    config(Database);

var SQLProject_Manager mSQLProject_Manager;
var WorldInfo ThisWorld;
// Called from elsewhere in script to initialize the movie
event InitializeMoviePlayer()
{
     // Sets up our delegate to be called from ActionScript.
     SetupASDelegate(DoFancyThings);
}

// ...

delegate bool FancyThingsDelegate(String username, String password);

function bool DoFancyThings(String username, String password)
{
     // Code goes here...
     return mSQLProject_Manager.validateUserPass(username, password);

}

function SetupASDelegate(delegate<FancyThingsDelegate> d)
{
     local GFxObject RootObj;

     RootObj = GetVariableObject("_root");
     ActionScriptSetFunction(RootObj, "DoFancyThings");
}

function PostBeginPlay()
{


}

function RegisterSQLManager(SQLProject_Manager SQLManager)
{
        mSQLProject_Manager = SQLManager;
}

//Called from STHUD'd PostBeginPlay()
function Init2()
{
	//Start and load the SWF Movie
	Start();
	Advance(0.f);
        ThisWorld = GetPC().WorldInfo;

}

function ValidateUsername(optional String username)
{
        local bool isValidated;
        isValidated = mSQLProject_Manager.Validate(username);

        if(isValidated)
        chooseCharacter();

}

//Asks flash show message showing that player is validated
function chooseCharacter()
{
        local array<ASValue> args;
        local ASValue asval;


        asval.Type = AS_String;
        asval.s = "Matthew";
        args[0] = asval;

        asval.Type = AS_Number;
        asval.n = 38;
        args[1] = asval;
        GetVariableObject("root").Invoke("chooseCharacter",args );

}

//join a game
function Join(String username,String type)
{
        local bool checker;
        local String itemString;

        checker = mSQLProject_Manager.checkCharacter(username,type);
        itemString = mSQLProject_Manager.GetItem(username,type);

        if(!checker)
        showCharacterCreation(type);
        else
        ConsoleCommand("open 127.0.0.1?PlayerType=" $ type $ "?Username=" $ username $ "?Itesdm=" $ itemString );

}

function createPlayer(String username,String type)
{
        mSQLProject_Manager.createCharacter(username,type);
        ConsoleCommand("open 127.0.0.1?PlayerType=" $ type $ "?Username=" $ username $ "");
}
function showCharacterCreation(String type)
{
        local array<ASValue> args;
        local ASValue asval;


        asval.Type = AS_String;
        asval.s = type;
        args[0] = asval;

        asval.Type = AS_Number;
        asval.n = 38;
        args[1] = asval;
        GetVariableObject("root").Invoke("OnCharCreation",args );
}

DefaultProperties
{
        //this is the HUD. If the HUD is off, then this should be off
        bDisplayWithHudOff=false
        //The path to the swf asset we will create later
        MovieInfo=SwfMovie'Hotshot.MainMenu'
}