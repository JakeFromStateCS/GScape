/*
	Unnamed Project
    --By Blasphemy
*/

GM.StartTime = SysTime();

Base = GM or {};

GM.Name = "GScape";
GM.Author = "Blasphemy";

--include( "resources.lua" );
AddCSLuaFile( "cl_init.lua" );

function GM:IncludeDir( directory )
	local files = file.Find( self.FolderName .. "/gamemode/" .. directory .. "/*.lua", "LUA" );

	for k,v in pairs( files ) do
		local prefix = string.sub( v, 1, 3 );
		if( prefix == "sh_" ) then
			AddCSLuaFile( path );
			include( path );
		elseif( prefix == "sv_" ) then
			include( path );
		elseif( prefix == "cl_" ) then
			AddCSLuaFile( path );
		end;
	end;
end;

AddCSLuaFile( "main/sh_main.lua" );
AddCSLuaFile( "main/cl_main.lua" );
include( "main/sv_main.lua" );

RunConsoleCommand( "mp_falldamage", "1" );
RunConsoleCommand( "sbox_godmode", "0" );
RunConsoleCommand( "sbox_noclip", "0" );
RunConsoleCommand( "physgun_limited", "1" );
RunConsoleCommand( "sv_alltalk", "2" );

DeriveGamemode( "base" );