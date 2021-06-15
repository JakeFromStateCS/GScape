/*
	Unnamed Project
    --By Blasphemy
*/

GM.StartTime = SysTime();

Base = Base or {};

GM.Name = "GScape";
GM.Author = "Blasphemy";


function GM:IncludeDir( directory )
	local files = file.Find( self.FolderName .. "/gamemode/" .. directory .. "/*.lua", "LUA" );

	for k,v in pairs( files ) do
		local prefix = string.sub( v, 1, 3 );
		if( prefix != "sv_" ) then
			include( path );
		end;
	end;
end;

include( "main/cl_main.lua" );

DeriveGamemode( "base" );