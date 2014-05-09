class Boss extends Enemy;
event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        local int Damage;

        //default damage
        Damage = 10;

        HP -= Damage;

        if(HP <= 0 && EnemyFactory(Owner) != none)
        {
                isDead = true;
                setHidden(true);
                HP = 100;
        }

}
DefaultProperties
{

    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'CH_TwinSouls_Cine.Mesh.SK_CH_RedGuard_Custom'
                Scale = 2
        Translation = (Z=20.0)
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
    HP = 200;
    AttackDistance=500.0


}


function Attack(Actor target)
{
        local UTProj_Rocket projectile;
        local Vector temp;

        //Bullet Lane 1
        projectile = spawn(class' UTProj_Rocket', self,, Location);
        projectile.Damage = 2;
        
        temp = target.Location;
        temp.X = temp.X + 100;
        temp.Y = temp.Y + 100;
        projectile.Init(normal(temp - Location));
        
        //Bullet Lane 2
        projectile = spawn(class' UTProj_Rocket', self,, Location);
        projectile.Damage = 2;
        
        temp = target.Location;
        temp.X = temp.X - 100;
        temp.Y = temp.Y - 100;
        projectile.Init(normal(temp - Location));
        

        //Main Lane
        projectile = spawn(class' UTProj_Rocket', self,, Location);
        projectile.Damage = 2;
        
        projectile.Init(normal(target.Location - Location));
        

}

simulated function PostBeginPlay()
{
      //  SetDrawScale(X=2.0,Y=2.0,Z=4.0) ;
       super.PostBeginPlay();

       if (Mesh != none && WeaponSkeletalMesh != none)
       Mesh.AttachComponentToSocket(WeaponSkeletalMesh, 'WeaponPoint');

}








