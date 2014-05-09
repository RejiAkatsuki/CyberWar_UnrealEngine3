class Projectile_Class extends UTProjectile abstract;
var vector ColorLevel;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if (Enemy(Other) != none )
	{
                //Nothing here, because we want projectiles to pass through bots
	}
	else
	{
	       super.ProcessTouch(Other,HitLocation,HitNormal);
	}
}

