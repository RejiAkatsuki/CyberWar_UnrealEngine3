Class MyActor extends Actor
    placeable;
    
defaultproperties
{
    Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=True
    End Object
    Components.Add(Sprite)
}

function PostBeginPlay()
{
    `log("Hello World! =========");
}