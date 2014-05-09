class Projectile_Factory extends Actor;


function ParallelPattern(vector from,vector to)
{
        local Projectile_Blue projectile;
        local Vector TempLocation;
        local Vector TempEnemLocation;

        projectile = spawn(class' Projectile_Blue', self,, Location);
        projectile.Damage = 2;
        projectile.Init(normal(to - from));

        //Bullet Lane 1
        TempLocation = from;
        TempLocation.Y = TempLocation.Y - 15;
        TempLocation.X = TempLocation.X - 15;

        TempEnemLocation = to;
        TempEnemLocation.Y = TempEnemLocation.Y - 15;
        TempEnemLocation.X = TempEnemLocation.X - 15;

        projectile = spawn(class' Projectile_Blue', self,, TempLocation);
        projectile.Damage = 2;
        projectile.Init(normal(TempEnemLocation - TempLocation));
        
        //Bullet Lane 2
        TempLocation = from;
        TempLocation.Y = TempLocation.Y + 15;
        TempLocation.X = TempLocation.X + 15;

        TempEnemLocation = to;
        TempEnemLocation.Y = TempEnemLocation.Y + 15;
        TempEnemLocation.X = TempEnemLocation.X + 15;

        projectile = spawn(class' Projectile_Blue', self,, TempLocation);
        projectile.Damage = 2;
        projectile.Init(normal(TempEnemLocation - TempLocation));

}

function CabbagePattern(vector from,vector to)
{
        local Projectile_Red projectile;
        local Vector temp;

        //Bullet Lane 1
        projectile = spawn(class' Projectile_Red', self,, from);
        projectile.Damage = 2;
        
        temp = to;
        temp.X = temp.X + 100;
        temp.Y = temp.Y + 100;
        projectile.Init(normal(temp - from));
        
        //Bullet Lane 2
        projectile = spawn(class' Projectile_Red', self,, from);
        projectile.Damage = 2;
        
        temp = to;
        temp.X = temp.X - 100;
        temp.Y = temp.Y - 100;
        projectile.Init(normal(temp - from));
        

        //Main Lane
        projectile = spawn(class' Projectile_Red', self,, from);
        projectile.Damage = 2;
        
        projectile.Init(normal(to - from));


}

function CabbagePatternV2(vector from,vector to)
{
        local Projectile_White projectile;
        local Vector temp;

        //Bullet Lane 1
        projectile = spawn(class'Projectile_White', self,, from);
        projectile.Damage = 2;
        
        temp = to;
        temp.X = temp.X + 100;
        temp.Y = temp.Y + 100;
        projectile.Init(normal(temp - from));
        
        //Bullet Lane 2
        projectile = spawn(class'Projectile_White', self,, from);
        projectile.Damage = 2;
        
        temp = to;
        temp.X = temp.X - 100;
        temp.Y = temp.Y - 100;
        projectile.Init(normal(temp - from));
        

        //Main Lane
        projectile = spawn(class'Projectile_White', self,, from);
        projectile.Damage = 2;
        
        projectile.Init(normal(to - from));


}
function StraightPattern(vector from,vector to)
{
        local Projectile_Green projectile;
        projectile = spawn(class' Projectile_Green', self,, from);
        projectile.Damage = 2;
        projectile.Init(normal(to - from));
}




