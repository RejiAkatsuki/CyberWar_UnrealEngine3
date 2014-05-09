class Enemy extends UDKPawn
abstract;

// define a new struct so we can pass all the variables as one
struct RepAnim
{

var bool Toggle;
var name AnimName;
var float Rate;
var float BlendInTime;
var float BlendOutTime;
var bool bLoop;
var Enemy pawn;

};

// declare the var with repnotify so it replicates to all clients
var repnotify RepAnim FullBodyRep;
var Pawn Enemy;
var int BotID;
var vector targetDirection;
var vector targetLocation;
var AnimNodeSlot FullBodyAnimSlot;
var() SkeletalMeshComponent WeaponSkeletalMesh;
var() Arrow DirectionalArrow;
var int HP;
var float AttackDistance;
var bool isDead;
var vector loc;
var String BroadcastMessage;
var SoundCue soundSample;

//compute health bar
event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        
        if(isDead)
        return;



        if(HP <= 0 && EnemyFactory(Owner) != none)
        {
                //Score point
             if(EventInstigator != none && EventInstigator.PlayerReplicationInfo != none)
                   WorldInfo.Game.ScoreObjective(EventInstigator.PlayerReplicationInfo, 1);

                 Killed();
        }
        

        SetTimer(1, true, 'ResetMessage');



        


}


defaultproperties()
{
 isDead = false;
}
//display for others to see
replication
{
        if(bNetDirty)
        Enemy,HP,BotID,FullBodyRep,isDead,DirectionalArrow,BroadcastMessage;
}

function ResetMessage()
{
        BroadcastMessage = "";
}

function registerArrow(Arrow ctor)
{
        DirectionalArrow = ctor;
}

//kill the player
function Killed()
{
        isDead = true;
        setHidden(true);
        SetTimer(4, false, 'resurrect');

}
//for respawn
function resurrect()
{
        setHidden(false);
        HP = 100;
        isDead = false;
        SetLocation(EnemyFactory(Owner).Location);
}

// this is what I’m triggering via my PlayerController to then try to replicate a custom animation
simulated function Run()
{

        ePlayAnim('FullBodyAnimSlot', 'run_fwd_rif', 1.0, 0.15, 0.15, false);

        if(Role < ROLE_Authority)
        ServerRun();

}

// Tell server to do animation
reliable server function ServerRun()
{

        Run();

}

// play custom anims: this is done so they replicate
function ePlayAnim(Name NewAnimSlot, Name NewAnimName, float NewRate, float NewBlendInTime, float NewBlendOutTime, bool NewbLoop)
{

        local RepAnim NewRepAnim;

        NewRepAnim.Toggle = !FullBodyRep.Toggle;
        NewRepAnim.AnimName = NewAnimName;
        NewRepAnim.Rate = NewRate;
        NewRepAnim.BlendInTime = NewBlendInTime;
        NewRepAnim.BlendOutTime = NewBlendOutTime;
        NewRepAnim.bLoop = NewbLoop;
        NewRepAnim.Pawn = self;

        //FullBodyAnimSlot.PlayCustomAnim('run_fwd_rif', 1);
        FullBodyAnimSlot.PlayCustomAnim(NewAnimName, NewRate, NewBlendInTime, NewBlendOutTime, NewbLoop);
        // changing this var will make it get caught and replicated by ReplicatedEvent. remember repnotify on the declaration?
        FullBodyRep = NewRepAnim;

        if(Role < ROLE_Authority)
        ServerPlayAnim(NewAnimSlot, NewAnimName, NewRate, NewBlendInTime, NewBlendOutTime, NewbLoop);

}

// tell the server to play them too
reliable server function ServerPlayAnim(Name NewAnimSlot, Name NewAnimName, float NewRate, float NewBlendInTime, float NewBlendOutTime, bool NewbLoop)
{

        ePlayAnim(NewAnimSlot, NewAnimName, NewRate, NewBlendInTime, NewBlendOutTime, NewbLoop);

}

// this is what all clients are made to do
reliable client function ClientPlayAnim(Name NewAnimSlot, Name NewAnimName, float NewRate, float NewBlendInTime, float NewBlendOutTime, bool NewbLoop, optional Enemy PlayerPawn)
{

        PlayerPawn.FullBodyAnimSlot.PlayCustomAnim('run_fwd_rif', 1);

}

reliable client function MoveRedDot()
{
        if(DirectionalArrow == none)
        return;

        loc = DirectionalArrow.Location;
        loc.X = Location.X;
        loc.Y = Location.Y;
        DirectionalArrow.SetLocation(loc);
}

simulated event ReplicatedEvent(name VarName)

{

        ClientPlayAnim('FullBodyAnimSlot', FullBodyRep.AnimName, FullBodyRep.Rate, FullBodyRep.BlendInTime, FullBodyRep.BlendOutTime, FullBodyRep.bLoop, FullBodyRep.Pawn);
        

        MoveRedDot();
}
//initialize animation
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	if (SkelComp == Mesh)
	{
		FullBodyAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
        }
}


function Attack(Actor target)
{

}

//initalize play
simulated function PostBeginPlay()
{

       super.PostBeginPlay();

       if (Mesh != none && WeaponSkeletalMesh != none)
       Mesh.AttachComponentToSocket(WeaponSkeletalMesh, 'WeaponPoint');

}





