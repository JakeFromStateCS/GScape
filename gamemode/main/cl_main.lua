/*
	Unnamed Project
    --By Blasphemy
*/

Base.Inventory = Base.Inventory or {};
include( "sh_config.lua" );
include( "sh_main.lua" );


function GM:HUDDrawTargetID()
	--return false;
	self.BaseClass:HUDDrawTargetID();
end;