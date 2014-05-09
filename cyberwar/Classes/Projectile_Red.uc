class Projectile_Red extends Projectile_Class;

simulated function SpawnFlightEffects()
{
	Super.SpawnFlightEffects();
	if (ProjEffects != None)
	{
		ProjEffects.SetVectorParameter('LinkProjectileColor', ColorLevel);
	}
}

DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Projectile'
    ProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
    ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
    ColorLevel=(X=2,Y=0,Z=0)
    LifeSpan = 5;
}