class AwesomeWeapon_GreenLinkGun extends AwesomeWeapon;

defaultproperties
{

        Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
        End Object

        AttachmentClass=class'UTGameContent.UTAttachment_RocketLauncher'

        WeaponFireTypes(0)=EWFT_Projectile
        WeaponFireTypes(1)=EWFT_Projectile

        WeaponProjectiles(0)=class'LinkGun_GreenProjectile'
        WeaponProjectiles(1)=class'LinkGun_GreenProjectile'
        
        AmmoCount=9999
        MaxAmmoCount=9999
}
