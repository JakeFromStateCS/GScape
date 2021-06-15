/*
	Unnamed Project
    --By Blasphemy
*/

include( "sh_config.lua" );
include( "sh_main.lua" );


function GM:PlayerSpawn( ply )
	self.BaseClass:PlayerSpawn( ply );
end;

function GM:PlayerInitialSpawn( ply )
	ply:SetRunSpeed( Base.Config.RunSpeed );
    ply:SetWalkSpeed( Base.Config.WalkSpeed );
    
    self.BaseClass:PlayerInitialSpawn( ply );
end;

function GM:AllowPlayerPickup( ply, entity )
	return true;
end;

function GM:EntityRemove( entity )
	self.BaseClass:EntityRemoved( entity );

end;

function GM:CanPlayerSuicide( ply )
	return Base.Config.CanSuicide;
end;

function GM:PlayerSwitchFlashlight( ply, state )
	return false;
end;