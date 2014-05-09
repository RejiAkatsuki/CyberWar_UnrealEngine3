Class Item extends Actor
abstract;

var string type;
var int FireRate;

event Touch(Actor Other, PrimitiveComponent OtherComp, vector
HitLocation, vector HitNormal)
{
        if (AwesomePawn(Other) != none)

        {

                AwesomePawn(Other).addItem(self);
                Destroy();

        }
        

}

function PostBeginPlay()
{

        FireRate = 0.1;


}
