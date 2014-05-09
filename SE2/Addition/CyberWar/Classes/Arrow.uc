class Arrow extends StaticMeshActor placeable;





defaultproperties
{
          Begin Object Class=StaticMeshComponent Name=PickupMesh
          StaticMesh=StaticMesh'EditorMeshes.TexPropSphere'
          Materials(0)=Material'CTF_Flag_IronGuard.Materials.M_CTF_Flag_IG_FlagRed'
          Scale3D=(X=0.2,Y=0.2,Z=0.2)
          CastShadow = false
          End Object

          Components.Add(PickupMesh)



	bStatic=false
	bMovable=true
//	CollisionComponent=StaticMeshComponent0
//	bCollideActors=true
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true

}






    
