class GreenProjectile extends UTProjectile;
var vector ColorLevel;
simulated function SpawnFlightEffects()
{
	Super.SpawnFlightEffects();
	if (ProjEffects != None)
	{
		ProjEffects.SetVectorParameter('LinkProjectileColor', ColorLevel);
	}
}

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

DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Projectile'
    ProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
    ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
    ColorLevel=(X=0,Y=2,Z=0)
    Damage = 20;
}