class AwesomeWeapon_LinkGun extends AwesomeWeapon;


defaultproperties
{

        AttachmentClass=class'UTGameContent.UTAttachment_RocketLauncher'

        WeaponFireTypes(0)=EWFT_Projectile
        WeaponFireTypes(1)=EWFT_Projectile

        WeaponProjectiles(0)=class'LinkGun_WhiteProjectile'
        WeaponProjectiles(1)=class'LinkGun_WhiteProjectile'

        AmmoCount=9999
        MaxAmmoCount=9999
       // AttachmentClass=class'UTGameContent.UTBeamWeaponAttachment'u
}

