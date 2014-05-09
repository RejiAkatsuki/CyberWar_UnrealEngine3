class RedRocket extends UTProj_Rocket;

var vector ColorLevel;
var vector ExplosionColor;

simulated function SpawnFlightEffects()
{
	Super.SpawnFlightEffects();
	if (ProjEffects != None)
	{
		ProjEffects.SetVectorParameter('LinkProjectileColor', ColorLevel);
	}
}

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
	Super.SetExplosionEffectParameters(ProjExplosion);
	ProjExplosion.SetVectorParameter('LinkImpactColor', ExplosionColor);
}

DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RockerLauncher_Muzzle_Flash'
    ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
    ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_AltFireStartCue'
       ColorLevel=(X=0,Y=0,Z=2)
        ExplosionColor=(X=1,Y=1,Z=1);
    Damage = 20;
}