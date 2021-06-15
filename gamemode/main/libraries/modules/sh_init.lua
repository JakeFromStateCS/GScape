--sh_init.lua
/*
	sh_init.lua
*/

/*
	NOTES:
		I basically decided this was necessary because in previous
		gamemodes I would just loop through the modules table but
		since the modules arent being stored in a table in this gamemode
		this is a nice way of doing it
		its also easier because all the hooks are in one place and accessable as opposed to
		looping through the whole module table which includes functions that arent hooks etc.
		
*/

Base = Base;
Base.Modules = Base.Modules or {};
Base.Modules.Stored = Base.Modules.Stored or {};
Base.Modules.HookTypes = {};

function Base.Modules:LoadModules()
	local fileTab = {file.Find( GM.FolderName .. "/gamemode/main/modules/*", "LUA" )};
	for k,v in pairs( fileTab[2] ) do
		for k, file in pairs( {file.Find(GM.FolderName .. "/gamemode/main/modules/" .. v .. "/*.lua", "LUA")} ) do
			if( file[1] ~= nil ) then
				local prefix = string.sub( file[1], 1, 3 );
				local path = GM.FolderName .. "/gamemode/main/modules/" .. v .. "/" .. file[1];
				if( string.match( prefix, "_" ) ) then
					MODULE = {};
					MODULE.Hooks = {};
					if( prefix == "sh_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
							include( path );
						else
							include( path );
						end;
						if( Base.Config.Debug and MODULE.Name ) then
							Base.Modules.Stored[MODULE.Name] = MODULE;
							self:RegisterHooks( MODULE );
							MsgC( Base.Config.ConsoleColor, "[GM-SH] | Loaded " );
							MsgC( Base.Config.HighlightColor, "MODULE" );
							MsgC( Base.Config.ConsoleColor, ": " .. MODULE.Name .. "\n" );
						end;
						if( MODULE.OnLoad ) then
							MODULE:OnLoad();
						end;
					elseif( prefix == "sv_" ) then
						if( SERVER ) then
							include( path );

						end;
						if( Base.Config.Debug and MODULE.Name ) then
							Base.Modules.Stored[MODULE.Name] = MODULE;
							self:RegisterHooks( MODULE );
							MsgC( Base.Config.ConsoleColor, "[GM-SV] | Loaded " );
							MsgC( Base.Config.HighlightColor, "MODULE" );
							MsgC( Base.Config.ConsoleColor, ": " .. MODULE.Name .. "\n" );
						end;
						if( MODULE.OnLoad ) then
							MODULE:OnLoad();
						end;
					elseif( prefix == "cl_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						else
							include( path );
							if( Base.Config.Debug and MODULE.Name ) then
								Base.Modules.Stored[MODULE.Name] = MODULE;
								self:RegisterHooks( MODULE );
								MsgC( Base.Config.ConsoleColor, "[GM-CL] | Loaded " );
								MsgC( Base.Config.HighlightColor, "MODULE" );
								MsgC( Base.Config.ConsoleColor, ": " .. MODULE.Name .. "\n" );
							end;
							if( MODULE.OnLoad ) then
								MODULE:OnLoad();
							end;
						end;
					end;
					MODULE = nil;
				end;
			end;
		end;
	end;
end;

function Base.Modules:RegisterHooks( MODULE )
	if( MODULE.Name and MODULE.Hooks ) then
		for name,func in pairs( MODULE.Hooks ) do
			if( Base.Modules.HookTypes[name] == nil ) then
				Base.Modules.HookTypes[name] = {};
			end;
			table.insert( Base.Modules.HookTypes[name], func );
			hook.Add( name, "Base" .. name, function( ... )
				for k=1, #Base.Modules.HookTypes[name] do
					local func = Base.Modules.HookTypes[name][k];
					local retVar = func( unpack( { MODULE, ... } ) );
					if( retVar ~= nil ) then
						return retVar;
					end;
				end;
			end );
			if( Base.Config.Debug ) then
				MsgC( Base.Config.ConsoleColor, "[GM-SH] | Registering " );
				MsgC( Base.Config.HighlightColor, "HOOK" );
				MsgC( Base.Config.ConsoleColor, ": " .. name .. " from" );
				MsgC( Base.Config.HighlightColor, " MODULE" );
				MsgC( Base.Config.ConsoleColor, ": " .. MODULE.Name .. "\n" );
			end;
		end;
	end;
end;

Base.Modules:LoadModules();

/*

if( MODULE.Name != nil and MODULE.Hooks != nil ) then
						--Assume it's valid if it has a name because a name is required
						--To store it in the table
						if( SERVER ) then
							Base.Modules.Stored[MODULE.Name] = MODULE;
							Base.Config[MODULE.Name] = MODULE.Config;
							MsgC( Base.Config.ConsoleColor, "[GM-SV] | Loaded Module: " .. MODULE.Name .. "\n" );
							if( MODULE.Hooks.OnLoad != nil ) then
								MODULE.Hooks:OnLoad();
							end;

							Base.Modules:RegisterHooks( MODULE );
						else
							Base.Modules.Stored[MODULE.Name] = MODULE;
							Base.Config[MODULE.Name] = MODULE.Config;
							MsgC( Base.Config.ConsoleColor, "[GM-CL] | Loaded Module: " .. MODULE.Name .. "\n" );
							if( MODULE.Hooks.OnLoad != nil ) then
								MODULE.Hooks:OnLoad();
							end;

							Base.Modules:RegisterHooks( MODULE );
						end;
					else
						if( SERVER and prefix != "cl_" ) then
							MsgC( Base.Config.ConsoleColor, "[GM-SV] | Module failed to load: " .. path .. "\n" );
						else
							MsgC( Base.Config.ConsoleColor, "[GM-CL] | Module failed to load: " .. path .. "\n" );
						end;
					end;
					MODULE = nil;
				else
					if( Base.Config.Debug ) then
						if( SERVER and prefix != "cl_" ) then
							MsgC( Base.Config.ConsoleColor, "[GM-SV] | Skipped File: " .. path .. "\n" );
						else
							MsgC( Base.Config.ConsoleColor, "[GM-CL] | Skipped File: " .. path .. "\n" );
						end;
					end;
				end;

*/