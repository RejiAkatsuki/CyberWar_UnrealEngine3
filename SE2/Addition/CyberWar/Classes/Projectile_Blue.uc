class Projectile_Blue extends Projectile_Class;

simulated function SpawnFlightEffects()
{
	Super.SpawnFlightEffects();
	if (ProjEffects != None)
	{
		ProjEffects.SetVectorParameter('LinkProjectileColor', ColorLevel);
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
super.Explode(HitLocation,HitNormal);
}

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	Velocity = MirrorVectorByNormal(Velocity, HitNormal);
	SetRotation(Rotator(Velocity));
}

DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Projectile'
    ProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
    ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
    ColorLevel=(X=0,Y=0,Z=2)
    Damage = 20;

}