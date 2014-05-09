Class GreenItem extends Item;


defaultproperties
{
        bCollideActors=True

        Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=TRUE
        End Object

        Components.Add(MyLightEnvironment)

        Begin Object Class=StaticMeshComponent Name=PickupMesh
        StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
        Materials(0)=Material'EditorMaterials.WidgetMaterial_Y'
        LightEnvironment=MyLightEnvironment
        Scale3D=(X=0.125,Y=0.125,Z=0.125)
        End Object

        Components.Add(PickupMesh)

        Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=16.0
        CollisionHeight=16.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
        End Object

        CollisionComponent=CollisionCylinder
        Components.Add(CollisionCylinder)
        
         RemoteRole=ROLE_SimulatedProxy
        bAlwaysRelevant=true
        type="Rifle";
}