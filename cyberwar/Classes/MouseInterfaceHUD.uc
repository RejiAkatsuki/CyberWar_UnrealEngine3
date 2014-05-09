/* Render mouse cursor and user HUD. Display player information (blood, position ..). */
class MouseInterfaceHUD extends HUD;

// The texture which represents the cursor on the screen
var const Texture2D CursorTexture;
// The color of the cursor
var const Color CursorColor;

var Vector WorldOrigin;
var Vector WorldDirection;
var Vector2D    MousePosition;
var Vector test;
var STGFxHUD HudMovie;
var bool bIsInventoryOpen;


event PostRender()
{

  local MouseInterfacePlayerInput MouseInterfacePlayerInput;
  local CyberPlayerController CyberPlayerController;



  // Ensure that we have a valid PlayerOwner and CursorTexture
  if (PlayerOwner != None && CursorTexture != None) 
  {
    // Cast to get the MouseInterfacePlayerInput
    MouseInterfacePlayerInput = MouseInterfacePlayerInput(PlayerOwner.PlayerInput);

    if (MouseInterfacePlayerInput != None)
    {
          // Set the canvas position to the mouse position
        Canvas.SetPos(MouseInterfacePlayerInput.MousePosition.X, MouseInterfacePlayerInput.MousePosition.Y);
         // Set the cursor color
        Canvas.DrawColor = CursorColor;
         // Draw the texture on the screen
        Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,, true);
      
      	MousePosition.X = MouseInterfacePlayerInput.MousePosition.X;
	MousePosition.Y = MouseInterfacePlayerInput.MousePosition.Y;



         //Deproject the mouse from screen coordinate to world coordinate and store World Origin and Dir.
        Canvas.DeProject(MousePosition, WorldOrigin, WorldDirection);

        CyberPlayerController = CyberPlayerController(PlayerOwner);
        CyberPlayerController.PlayerMouse = MousePosition;
        CyberPlayerController.MouseHitWorldLocation = GetMouseWorldLocation();

    }
  }

  Super.PostRender();
  DrawHUD();
}


function DrawHUD()
{
        local CyberPlayerController CyberPlayerController;
        local AwesomePawn MyPawn;
        local int playerHealth;
        local vector ScreenPos;
        local String message;
        local Enemy E;


        CyberPlayerController = CyberPlayerController(PlayerOwner);
        MyPawn = AwesomePawn(CyberPlayerController.Pawn);


        if(MyPawn.bPKMode)
        playerHealth = MyPawn.Health;
        else
        playerHealth = MyPawn.HP;

        Canvas.Font = class'Engine'.static.GetLargeFont();

        Canvas.SetDrawColor(255, 255, 255); // White
        Canvas.SetPos(1000, 675);


        if(playerHealth < 10)
        {
        Canvas.SetDrawColor(255, 0, 0); // Red
        }
        else if (playerHealth < 20)
        {
        Canvas.SetDrawColor(255, 255, 0); // Yellow
        }
        else
        {
        Canvas.SetDrawColor(0, 255, 0); // Green
        }
        
        //Tell flash GUI to update health number
        CyberPlayerController.CyberHUD.UpdateHealthNumber(playerHealth);
        CyberPlayerController.CyberHUD.UpdateLevelNumber(MyPawn.Level);
        CyberPlayerController.CyberHUD.UpdateXPNumber(MyPawn.XP);
        CyberPlayerController.CyberHUD.UpdateAttackNumber(MyPawn.Damage);

        Canvas.SetPos(600 ,15);
        Canvas.DrawText( CyberPlayerController.PlayerReplicationInfo.Score);

                //Find all Enemy Classes
                foreach DynamicActors(class'Enemy', E)
                {
                ScreenPos = Canvas.Project(E.Location);
                Canvas.SetPos(ScreenPos.X ,ScreenPos.Y - 20);
                Canvas.SetDrawColor(255, 0, 0);



                if(!E.isDead && E.HP > 0)
                {

                 message = E.BroadcastMessage;
                 Canvas.DrawText(message);

                 Canvas.SetPos(ScreenPos.X ,ScreenPos.Y - 20);
                 Canvas.SetDrawColor(255, 0, 0);
                 Canvas.DrawRect(0.5 * E.HP, 5);
                 Canvas.SetPos(ScreenPos.X ,ScreenPos.Y - 15);
                 Canvas.DrawText( E.HP);
                 //Canvas.DrawText( CyberPlayerController.PlayerReplicationInfo. PlayerID);
                }






        }



}

defaultproperties
{
  CursorColor=(R=255,G=255,B=255,A=255)
  CursorTexture=Texture2D'EngineResources.Cursors.Arrow'

  bIsInventoryOpen = false

}

//Called after game loaded - initialise things
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	//Create a STGFxHUD for HudMovie
	HudMovie = new class'STGFxHUD';
	//Set the HudMovie's PlayerOwner
	HudMovie.PlayerOwner = CyberPlayerController(PlayerOwner);
	//Set the timing mode to TM_Real - otherwide things get paused in menus
	HudMovie.SetTimingMode(TM_Real);
	//Call HudMovie's Initialise function
	HudMovie.Init2(HudMovie.PlayerOwner);
	HudMovie.hideInventory();
	
	if(CyberPlayerController(PlayerOwner).PlayerType == "White")
        SwitchWeapon_1();
        if(CyberPlayerController(PlayerOwner).PlayerType == "Red")
        SwitchWeapon_2();
        if(CyberPlayerController(PlayerOwner).PlayerType == "Blue")
        SwitchWeapon_3();
        if(CyberPlayerController(PlayerOwner).PlayerType == "Green")
        SwitchWeapon_4();
}

exec function showInventory()
{

        


        if(!HudMovie.bInputFocused)
        return;

	`log("[PlacementHUD].[showInventory] begins");
	if(!bIsInventoryOpen)
	{
	        HudMovie.showInventory();
        	bIsInventoryOpen = true;
	}
	
	else

	{
		HudMovie.hideInventory();
        	bIsInventoryOpen = false;
	}

	`log("[PlacementHUD].[showInventory] ends");
}

exec function InviteToAChallenge()
{


}


exec function SwitchWeapon_1()
{
        local CyberPlayerController CyberPlayerController;
        local AwesomePawn MyPawn;

        CyberPlayerController = CyberPlayerController(PlayerOwner);
        MyPawn = AwesomePawn(CyberPlayerController.Pawn);

        MyPawn.InvManager.GetWeapon(0);

        if(MyPawn.PType != "White")
        MyPawn.Damage = MyPawn.HalvedDamage;
        else
        MyPawn.Damage = MyPawn.BaseDamage;
        
        MyPawn.SetAttackDamage(MyPawn.Damage);
        
        HudMovie.indicator(1);

}

exec function SwitchWeapon_2()
{
        local CyberPlayerController CyberPlayerController;
        local AwesomePawn MyPawn;

        CyberPlayerController = CyberPlayerController(PlayerOwner);
        MyPawn = AwesomePawn(CyberPlayerController.Pawn);

        MyPawn.InvManager.GetWeapon(1);
        

        if(MyPawn.PType != "Red")
        MyPawn.Damage = MyPawn.HalvedDamage;
        else
        MyPawn.Damage = MyPawn.BaseDamage;

        MyPawn.SetAttackDamage(MyPawn.Damage);
        
        HudMovie.indicator(2);

}

exec function SwitchWeapon_3()
{
        local CyberPlayerController CyberPlayerController;
        local AwesomePawn MyPawn;


        CyberPlayerController = CyberPlayerController(PlayerOwner);
        MyPawn = AwesomePawn(CyberPlayerController.Pawn);

        MyPawn.InvManager.GetWeapon(2);

        if(MyPawn.PType != "Blue")
        MyPawn.Damage = MyPawn.HalvedDamage;
        else
        MyPawn.Damage = MyPawn.BaseDamage;
        
        MyPawn.SetAttackDamage(MyPawn.Damage);
        
        HudMovie.indicator(3);

}

exec function SwitchWeapon_4()
{
        local CyberPlayerController CyberPlayerController;
        local AwesomePawn MyPawn;

        CyberPlayerController = CyberPlayerController(PlayerOwner);
        MyPawn = AwesomePawn(CyberPlayerController.Pawn);

        MyPawn.InvManager.GetWeapon(3);

        if(MyPawn.PType != "Green")
        MyPawn.Damage = MyPawn.HalvedDamage;
        else
        MyPawn.Damage = MyPawn.BaseDamage;
        
        MyPawn.SetAttackDamage(MyPawn.Damage);
        
        HudMovie.indicator(4);

}



function Vector GetMouseWorldLocation()
{

  local Vector MouseWorldOrigin, MouseWorldDirection, HitLocation, HitNormal;

  // Ensure that we have a valid canvas and player owner
  if (Canvas == None || PlayerOwner == None)
  {
    return Vect(0, 0, 0);
  }

  // Deproject the mouse position and store it in the cached vectors
  Canvas.DeProject(MousePosition, MouseWorldOrigin, MouseWorldDirection);

  // Perform a trace to get the actual mouse world location.
  Trace(HitLocation, HitNormal, MouseWorldOrigin + MouseWorldDirection * 65536.f, MouseWorldOrigin , true,,, TRACEFLAG_Bullet);
  return HitLocation;
}

exec function Send()
{

       HudMovie.getFocus();
       HudMovie.checkFocus();

       if(HudMovie.bInputFocused)
       {
        HudMovie. RequestInputMessage();
        CyberPlayerController(PlayerOwner).SendTextToServer(CyberPlayerController(PlayerOwner), HudMovie.messageHolder);
        HudMovie.TurnOffFocus();
       }
       else
       {
       HudMovie.TurnOnFocus();
       }

}

function Announce(String announcement)
{
        HudMovie.TurnOnAnnoucement(announcement);
        SetTimer(2, false, 'TurnOffAnn');
}

function TurnOffAnn()
{
        HudMovie.TurnOffAnnoucement();
}





