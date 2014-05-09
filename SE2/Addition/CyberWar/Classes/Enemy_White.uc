class Enemy_White extends Enemy;

simulated event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        local CyberPlayerController AttackerController;
        local int Damage;

        AttackerController = CyberPlayerController(EventInstigator);

        if(AttackerController == none)
        return;

        Damage = AttackerController.GetPawnDamage();
        EXP = 10;
        //AwesomeWeapon_GreenLinkGUn fires GreenProjectile
        //What happens when damaged by green weapon
        if (LinkGun_GreenProjectile(DamageCauser) != none)
        {
                BroadcastMessage = "CRITICAL HIT!";
                Damage = Damage * 2;
        }

        //AwesomeWeapon_LinkGUn fires LinkGun_WhiteProjectile
        //What happens when damaged by white weapon
        if (LinkGun_WhiteProjectile(DamageCauser) != none)
        {
                BroadcastMessage = "ABSORBED!";
                Damage = Damage/2;
        }


        HP -= Damage;

        super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType);
}
DefaultProperties
{

    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh = SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
        Materials(1)=MaterialInstanceConstant'EditorLandscapeResources.PatternBrushMaterial_Smooth'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
        HiddenGame=FALSE
        HiddenEditor=FALSE
        BlockActors=false
        CollideActors=false
    End Object

    Mesh=SandboxPawnSkeletalMesh


    Components.Add(SandboxPawnSkeletalMesh)

    Begin Object Class=SkeletalMeshComponent Name=MyWeaponSkeletalMesh
    CastShadow=true
    bCastDynamicShadow=true
    bOwnerNoSee=false
    SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
    End Object

    WeaponSkeletalMesh=MyWeaponSkeletalMesh
    ControllerClass=class'AggressiveAIController'

    bBlockActors=false
    bJumpCapable=false
    bCanJump=false
    bCanStrafe=True

    GroundSpeed=200.0 //Making the bot slower than the player
    HP = 100;
    AttackDistance=500.0


}


function Attack(Actor target)
{
        local Projectile_White Rprojectile;
        local Projectile_White Gprojectile;
        local Projectile_White Bprojectile;
        local Vector temp;

        //Bullet Lane 1
        Rprojectile = spawn(class' Projectile_White', self,, Location);
        Rprojectile.Damage = 2;
        
        temp = target.Location;
        temp.X = temp.X + 100;
        temp.Y = temp.Y + 100;
        Rprojectile.Init(normal(temp - Location));
        
        //Bullet Lane 2
        Gprojectile = spawn(class' Projectile_White', self,, Location);
        Gprojectile.Damage = 2;

        temp = target.Location;
        temp.X = temp.X - 100;
        temp.Y = temp.Y - 100;
        Gprojectile.Init(normal(temp - Location));
        

        //Main Lane
        Bprojectile = spawn(class' Projectile_White', self,, Location);
        Bprojectile.Damage = 2;
        
        Bprojectile.Init(normal(target.Location - Location));
        

}

simulated function PostBeginPlay()
{

       super.PostBeginPlay();

       if (Mesh != none && WeaponSkeletalMesh != none)
       Mesh.AttachComponentToSocket(WeaponSkeletalMesh, 'WeaponPoint');

}








