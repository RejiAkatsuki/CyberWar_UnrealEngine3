class LinkGun_WhiteProjectile extends UTProjectile;
var vector ColorLevel;
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
    ColorLevel=(X=1,Y=1,Z=1)

}