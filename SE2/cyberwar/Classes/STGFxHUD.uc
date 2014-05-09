class STGFxHUD extends GFxMoviePlayer;

var WorldInfo ThisWorld;
var CyberPlayerController PlayerOwner;
var int MAX_ITEMS;
var String messageHolder;
var bool bInputFocused;
var TextureRenderTarget2D RearViewRT;


//Called from STHUD'd PostBeginPlay()
function Init2(CyberPlayerController PC)
{
	//Start and load the SWF Movie
	Start();
	Advance(0.f);

	ThisWorld = GetPC().WorldInfo;

	// Register the HUD with the PlayerController
        PC = CyberPlayerController(GetPC());
        PC.registerHUD(self);
        
       // bInputFocused = false;

}

function setRenderTexture()
{
        setExternalTexture("rearviewmirror",RearViewRT);
}


//Check if txtbox is focused, if not, focus
function checkFocus()
{

        if(bInputFocused)
        `log('focusing');
        else
        `log('not focusing');

}

//Asks flash to see if input is focused
function getFocus()
{
        local array<ASValue> args;
        local ASValue asval;


        asval.Type = AS_String;
        asval.s = "Matthew";
        args[0] = asval;

        asval.Type = AS_Number;
        asval.n = 38;
        args[1] = asval;
        GetVariableObject("root").Invoke("checkFocus",args );

}


//Asks flash to turn off focus on textbox
function TurnOffFocus()
{
        local array<ASValue> args;
        local ASValue asval;


        asval.Type = AS_String;
        asval.s = "Matthew";
        args[0] = asval;

        asval.Type = AS_Number;
        asval.n = 38;
        args[1] = asval;
        GetVariableObject("root").Invoke("turnOffFocus",args );

}

//Asks flash to turn on focus on textbox
function TurnOnFocus()
{
        local array<ASValue> args;
        local ASValue asval;


        asval.Type = AS_String;
        asval.s = "Matthew";
        args[0] = asval;

        asval.Type = AS_Number;
        asval.n = 38;
        args[1] = asval;
        GetVariableObject("root").Invoke("turnOnFocus",args );

}



//Setter for bInputFocused
//Set by Flash object.Called by actionscript
function setbInputFocused(bool isFocused)
{

        bInputFocused = isFocused;

}

 function showInventory()
{

local array<ASValue> args;
local ASValue asval;


asval.Type = AS_String;
asval.s = "Matthew";
args[0] = asval;

asval.Type = AS_Number;
asval.n = 38;
args[1] = asval;
        GetVariableObject("root").Invoke("showInventory",args );
        showItems();
	`log("[STGFxHUD].[showInventory] begins");
}

 function hideInventory()
{
local array<ASValue> args;
local ASValue asval;

asval.Type = AS_String;
asval.s = "Matthew";
args[0] = asval;

asval.Type = AS_Number;
asval.n = 38;
args[1] = asval;
        GetVariableObject("root").Invoke("hideInventory",args );
	`log("[STGFxHUD].[hideInventory] begins");
}

 function renderItems(int slot)
{
local array<ASValue> args;
local ASValue asval;
local Pawn player;

player = PlayerOwner.Pawn;

asval.Type = AS_String;
asval.s = AwesomePawn(player).items[slot].type;
args[0] = asval;

asval.Type = AS_Number;
asval.n = 4;
args[1] = asval;

        switch(slot)
        {
                case 0:
                GetVariableObject("root").Invoke("showSlot1",args );
                break;
                
                case 1:
                GetVariableObject("root").Invoke("showSlot2",args );
                break;
                
                case 2:
                GetVariableObject("root").Invoke("showSlot3",args );
                break;

                case 3:
                GetVariableObject("root").Invoke("showSlot4",args );
                break;
                
                case 4:
                GetVariableObject("root").Invoke("showSlot5",args );
                break;
                
                case 5:
                GetVariableObject("root").Invoke("showSlot6",args );
                break;
        }

}

function UpgradeWeapon(int grade)
{

        local Pawn player;

        player = PlayerOwner.Pawn;



        if(AwesomeWeapon_LinkGun(player.Weapon) != none)
        {
                AwesomeWeapon_LinkGun(player.Weapon).UpgradeWeapon(grade);
                `log('UPGGRADED ');
        }
        
        if(AwesomeWeapon_RocketLauncher(player.Weapon) != none)
        AwesomeWeapon_RocketLauncher(player.Weapon).UpgradeWeapon(grade);

        if(AwesomeWeapon_GreenLinkGun(player.Weapon) != none)
        AwesomeWeapon_GreenLinkGun(player.Weapon).UpgradeWeapon(grade);
        
        if(AwesomeWeapon_ShockRifle(player.Weapon) != none)
        AwesomeWeapon_ShockRifle(player.Weapon).UpgradeWeapon(grade);

}

function showItems()
{
        local Pawn player;
        local int i;
        
        player = PlayerOwner.Pawn;

        for(i = 0; i < MAX_ITEMS ;i++)
        {
                if(AwesomePawn(player).items[i] != none)
                {
                         `log('FOUND IT AAT ' @ i);
                       renderItems(i);

                }


        }
}
function RetrieveInputMessage(optional String message)
{
        `log(message);
        messageHolder = message;
}
function UpdateChatLog(String message)
{
        local array<ASValue> args;
        local ASValue asval;

        asval.Type = AS_String;
        asval.s = message;
        args[0] = asval;

        asval.Type = AS_Number;
        asval.n = 4;
        args[1] = asval;

        GetVariableObject("root").Invoke("UpdateChatLog",args );

}

function RequestInputMessage()
{
        local array<ASValue> args;
        local ASValue asval;

        asval.Type = AS_String;
        asval.s = "ABC";
        args[0] = asval;

        asval.Type = AS_Number;
        asval.n = 4;
        args[1] = asval;

        GetVariableObject("root").Invoke("GetMessageInput",args );
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
        ConsoleCommand("open AwesomeTestMap?GoalScore=0?TimeLimit=0?Game=CyberWar.CyberGame?Listen");
        `log('---------------------HOSTED');
}

DefaultProperties
{
        //this is the HUD. If the HUD is off, then this should be off
        bDisplayWithHudOff=false
        //The path to the swf asset we will create later
        MovieInfo=SwfMovie'Hotshot.Inventory'
        bInputFocused = true;
        MAX_ITEMS = 6;
        RearViewRT = TextureRenderTarget2D'Hotshot.RearViewRT'
}