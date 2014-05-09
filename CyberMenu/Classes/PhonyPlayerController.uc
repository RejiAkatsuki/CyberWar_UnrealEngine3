class PhonyPlayerController extends UTPlayerController;


simulated function PostBeginPlay()
{
        super.PostBeginPlay();

        bNoCrosshair = true;


                Pawn.Weapon.SetHidden(true);

        //Inventory(Pawn).ThirdPersonActor.bHidden=True;
}

defaultproperties
{
}

state PlayerWalking
{
        function PlayerMove(float DeltaTime)
        {


        }

}










