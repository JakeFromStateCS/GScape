local files = { file.Find( GAMEMODE.FolderName .. "/gamemode/main/modules/*", "LUA" ) };
for _,folder in pairs( files[2]) do
	local files = file.Find( GAMEMODE.FolderName .. "/gamemode/main/modules/" .. folder .. "/*", "LUA" );
	MODULE = {};
	for _,fileName in pairs( files ) do
		local path = GAMEMODE.FolderName .. "/gamemode/main/modules/" .. folder .. "/" .. fileName;
		local prefix = string.sub( fileName, 1, 3 );
		
		if( prefix == "sv_" ) then
			include( path );
		elseif( prefix == "sh_" ) then
			include( path );
			AddCSLuaFile( path );
		elseif( prefix == "cl_" ) then
			if( CLIENT ) then
				include( path );
				if( Base.Config.Debug ) then
					
				end;
			else
				AddCSLuaFile( path );
			end;
		end;
	end;
	MODULE = nil;
end;

