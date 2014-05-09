class AwesomeGameReplicationInfo extends UTGameReplicationInfo;

var vector EnemyLocation[10];
var int EnemyHealth[10];
var String  EnemyMessage[10];

defaultproperties
{

}

//used to replicate for everyone to see
replication
{
        if(bNetDirty)
        EnemyLocation,EnemyHealth,EnemyMessage;
}



