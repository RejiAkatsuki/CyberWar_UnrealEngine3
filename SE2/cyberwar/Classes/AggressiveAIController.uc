class AggressiveAIController extends GameAIController;

var vector targetDirection;
var vector targetLocation;
var float MovementSpeed;
var Actor Target;
var() Vector TempDest;

var Vector NextMoveLocation;
var AnimNodeSlot FullBodyAnimSlot;
var float AttackDistance;

var Arrow Rep;

var float PerceptionDistance;
var float distanceToPlayer;


DefaultProperties
{

        MovementSpeed=250.0
        AttackDistance=800;
        PerceptionDistance = 600;
        NavigationHandleClass=class'NavigationHandle'
        RemoteRole=ROLE_SimulatedProxy
        bPreciseDestination = False;

}

event SeePlayer(Pawn SeenPlayer)

{
       Target = SeenPlayer;
       distanceToPlayer = VSize(Target.Location - Pawn.Location);
       
        if (distanceToPlayer < PerceptionDistance)

       {
           GotoState('Moving');
       }





}

//allow AI to work
event Possess(Pawn inPawn, bool bVehicleTransition)
{
        super.Possess(inPawn, bVehicleTransition);
        Pawn.SetMovementPhysics();
}

//function used to move to destination
function moveToTarget(vector aLocation) {
	local rotator directionVector;

	targetDirection = aLocation - pawn.location ;
	Normal(targetDirection);

	directionVector = rotator(targetDirection);
	Pawn.FaceRotation(directionVector, 0.01);
	targetDirection *= 1000;
}





//patrol from A to B
auto state Patrolling1
{

  	simulated  function Tick(float DeltaTime)
        {

        local Actor destination;

        destination = EnemyFactory(Pawn.Owner).MyNavigationPoints[0];

         if( !ActorReachable(destination) )
	{
		if( FindNavMeshPath(destination) )
		{
                        NavigationHandle.SetFinalDestination(destination.Location);
			// move to the first node on the path
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
			// suggest move preparation will return TRUE when the edge's
			// logic is getting the bot to the edge point
			     if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
                                MoveToVector( DeltaTime,TempDest,MovementSpeed + 100 );
			}

                        }

			else
			{

			}
		}
		else
		{
			// then move directly to the actor
			MoveToVector(DeltaTime,destination.Location,MovementSpeed + 100);
		}

                if(VSize(destination.Location - Pawn.Location) < 50.0 && !Enemy(Pawn).isDead)
                {
                        GoToState('Patrolling2');

                }


                if(AwesomeGameReplicationInfo(WorldInfo.GRI) != none)
                        AwesomeGameReplicationInfo(WorldInfo.GRI).EnemyLocation[Enemy(Pawn).BotID] = Enemy(Pawn).Location;

                Enemy(Pawn).Run();
        }

}

//reverse B to A
state Patrolling2
{

  	simulated  function Tick(float DeltaTime)
        {

        local Actor destination; 
        destination = EnemyFactory(Pawn.Owner);

         if( !ActorReachable(destination) )
	{
		if( FindNavMeshPath(destination) )
		{
                        NavigationHandle.SetFinalDestination(destination.Location);
			// move to the first node on the path
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
			// suggest move preparation will return TRUE when the edge's
			// logic is getting the bot to the edge point
			     if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
                                MoveToVector( DeltaTime,TempDest,MovementSpeed - 100 );
			}

                        }

			else
			{

			}
		}
		else
		{
			// then move directly to the actor
			MoveToVector(DeltaTime,destination.Location,MovementSpeed - 100);
		}

                if(VSize(destination.Location - Pawn.Location) < 50.0 && !Enemy(Pawn).isDead)
                {
                        GoToState('Patrolling1');

                }


                if(AwesomeGameReplicationInfo(WorldInfo.GRI) != none)
                        AwesomeGameReplicationInfo(WorldInfo.GRI).EnemyLocation[Enemy(Pawn).BotID] = Enemy(Pawn).Location;


                Enemy(Pawn).Run();
        }

}

//path fiding for bot
function bool FindNavMeshPath(Actor TargetActor)
{

	if ( NavigationHandle == None )
	InitNavigationHandle();

	// Clear cache and constraints (ignore recycling for the moment)
	NavigationHandle.ClearConstraints();
	NavigationHandle.PathConstraintList = none;
	NavigationHandle.PathGoalList = none;

	// Create constraints
	class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,TargetActor );
	class'NavMeshGoal_At'.static.AtActor( NavigationHandle, TargetActor );

	// Find path
	return NavigationHandle.FindPath();
}

//move and attack
state Moving
{


	simulated  function Tick(float DeltaTime)
        {

                if (Enemy(Pawn).isDead)
                GoToState('Patrolling1');
                
                if(Target == none)
                GoToState('Patrolling1');

                if(VSize(Target.Location - Pawn.Location) > 200.0)
                {

		if( !ActorReachable(Target) )
		{
			if( FindNavMeshPath(Target) )
			{
                                NavigationHandle.SetFinalDestination(Target.Location);
			// move to the first node on the path
			     if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			      {
				// suggest move preparation will return TRUE when the edge's
			    // logic is getting the bot to the edge point
				if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
				    {
				MoveToVector( DeltaTime,TempDest,300.0 );
				    }

			     }

			
                        }
			else
			{
				//give up because the nav mesh failed to find a path
				`warn("FindNavMeshPath failed to find a path to"@ Target);
				Target = None;
			}   
		}
		else
		{
			// then move directly to the actor
			MoveToVector(DeltaTime,Target.Location,300.0);
		}
		
		Enemy(Pawn).Run();

                }
                else
                {

                moveToTarget(Target.Location);

                }




                if(VSize(Target.Location - Pawn.Location) > 400.0)
                {
                  SetTimer(0.5, true, 'PawnFire');
                }

                if(VSize(Pawn.Owner.Location - Pawn.Location) > 900.0)
                {
                       GoToState('Patrolling1');
                }



        }

}

//bot attact
function PawnFire()
{

        if (IsInState('Patrolling1')) //this gives error
                return;
                
        if (IsInState('Patrolling2')) //this gives error
                return;

        Enemy(Pawn).Attack(Target);

}

//initialize animation tree
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	if (SkelComp == Pawn.Mesh)
	{
		FullBodyAnimSlot = AnimNodeSlot(Pawn.Mesh.FindAnimNode('FullBodySlot'));
        }
}

//move to vector
function MoveToVector(float DeltaTime, Vector destination,float Speed)
{

                  local vector NewLocation;

                  NewLocation = Pawn.Location;
                  NewLocation += normal(destination - Pawn.Location) * Speed * DeltaTime;
                  Pawn.SetLocation(NewLocation);

                  moveToTarget(destination);
}

//get enemy
 function GetEnemy()
{

        local CyberPlayerController PC;
        foreach DynamicActors(class'CyberPlayerController',PC)
        {

                 if(PC.Pawn != none)
                          Target = PC.Pawn;


        }

}

simulated function InitNavigationHandle()
{
	if( NavigationHandleClass != None && NavigationHandle == none )
		NavigationHandle = new(self) NavigationHandleClass;
}

function InitFullBodyAnim()
{
	if( FullBodyAnimSlot == none )
		FullBodyAnimSlot = AnimNodeSlot(Pawn.Mesh.FindAnimNode('FullBodySlot'));
}



