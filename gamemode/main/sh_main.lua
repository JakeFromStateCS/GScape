/*
	Unnamed Project
	--By Blasphemy
*/

if( SERVER ) then
	AddCSLuaFile();
end;

local Base = GM
Base.Modules = Base.Modules or {};
Base.Config = Base.Config or {};

function GM:LoadLibraries()
	local fileTab = {file.Find( self.FolderName .. "/gamemode/main/libraries/*", "LUA" )};
	for k,v in pairs( fileTab[2] ) do
		for k, file in pairs( {file.Find( self.FolderName .. "/gamemode/main/libraries/" .. v .. "/*.lua", "LUA" )} ) do
			if( file[1] ~= nil ) then
				local prefix = string.sub( file[1], 1, 3 );
				local path = self.FolderName .. "/gamemode/main/libraries/" .. v .. "/" .. file[1];
				if( string.match( prefix, "_" ) ) then
					if( prefix == "sh_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						end;
						include( path );
						if( Base.Config.Debug ) then
							MsgC( Base.Config.ConsoleColor, "[GM-SH] | Loaded " );
							MsgC( Base.Config.HighlightColor, "LIBRARY" );
							MsgC( Base.Config.ConsoleColor, ": " .. v .. "\n" );
						end;
					elseif( prefix == "sv_" ) then
						if( SERVER ) then
							include( path );
							if( Base.Config.Debug ) then
								MsgC( Base.Config.ConsoleColor, "[GM-SV] | Loaded " );
								MsgC( Base.Config.HighlightColor, "LIBRARY" );
								MsgC( Base.Config.ConsoleColor, ": " .. v .. "\n" );
							end;
						end;
					elseif( prefix == "cl_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						else
							include( path );
							if( Base.Config.Debug ) then
								MsgC( Base.Config.ConsoleColor, "[GM-CL] | Loaded " );
								MsgC( Base.Config.HighlightColor, "LIBRARY" );
								MsgC( Base.Config.ConsoleColor, ": " .. v .. "\n" );
							end;
						end;
					end;
				else
					if( Base.Config.Debug ) then
						if( SERVER ) then
							MsgC( Base.Config.ConsoleColor, "[Org-SV] | Skipped File: " .. path .. "\n" );
						else
							MsgC( Base.Config.ConsoleColor, "[GM-CL] | Skipped File: " .. path .. "\n" );
						end;
					end;
				end;
			end;
		end;
	end;
end;


Base:LoadLibraries();
if( CLIENT ) then
	PrintTable(  Base.Modules );
end;
