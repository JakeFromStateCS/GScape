require( "mysqloo" );
include( "sh_von.lua" );

Base = Base or {};
Base.Data = {};
Base.Data.Hooks = {};
Base.Data.Queue = {};
Base.Data.Stored = {};
Base.Data.Types = {
	["Vector"] = { "x", "y", "z" },
	["Angle"] = { "p", "y", "r" },
	["Table"] = { "r", "g", "b", "a" }
};
Base.Data.Config = {
	mysql = {
		default = true,
		info = {
			host = "beigelands.com",
			username = "fuckingwork",
			password = "fuckingwork",
			database = "Gmod_DarkRP",
			port = 3306
		},
		database = nil;
	},
	defaultRanks = {
		["Owner"] = {
			flags = {
				"*"
			}
		}
	}
};
Base.Data.QueueTimer = CurTime();
Base.Data.KATimer = CurTime()
Base.Data.KADelay = 30;
Base.Data.QueueDelay = 0.25;

function Base.Data:Decode( encodedStr )
	return von.decode( encodedStr );
end;

function Base.Data:Encode( dataTable )
	return von.encode( dataTable );--self:RecursiveEncode( dataTable );
end;

function Base.Data:Connect()
	if( self.Config.mysql.default ) then
		local mysql = self.Config.mysql;
		self.Config.mysql.database = mysqloo.connect( mysql.info.host, mysql.info.username, mysql.info.password, mysql.info.database, mysql.info.port );
		mysql.database.onConnected = function()
			print( "SUCCESS CONNECTING TO DB" );
			if( mysql.database.FirstConnect ) then
	--TODO:
	--			self:Log( some message about first time connecting or something );
			else
	--			self:Log( some message about connecting, info param possibly );
			end;

		end;
		mysql.database.onConnectionFailed = function( query, err )
	--TODO:
	--		self:Log( some message about some bullshit .. tostring( err ), error );
		print( query, err );
		end;
	--TODO:
	-- self:Log( some bullshit about connecting );
	self.Config.mysql.database:connect();
	self.Config.mysql.database:wait();
	end;
end;

function Base.Data:Disconnect()

end;

function Base.Data:TableExists( tableName )
	if( !self.Config.mysql.default ) then
		return sql.TableExists( tableName );
	else
		local query = "SELECT EXISTS (SELECT * FROM `" .. tableName .. "`);";
		local retVal = self:Query( query );
		if( #retVal == 0 ) then
			return false;
		else
			return true;
		end;
	end;
end;

function Base.Data:Query( string )
	local mysql = self.Config.mysql;
	if( !mysql.default ) then
		sql.Begin();
			local query = sql.query( string );
		sql.Commit();
		return query;
	else
		if( mysql.database ~= nil ) then
			local result = mysql.database:query( string );
			local retVal = {};
			if( result ) then
				
				result.onSuccess = function( data )
					--PrintTable( data );
					--retVal = data;
				end;
				result.onError = function( string, err )
					print( "ORGS ERROR | " .. err );
				end;
				result.onData = function( query, data )
					table.insert( retVal, data );
				end;
				result:start();
				result:wait();

				return retVal;
			end;

		else
			--Try to connect and re-run the query.
			self:Connect();
				-- Add the query to a queue then throw an error
				table.insert( self.Queue, string );
--TODO:
--				self.Log( )
		end;
	end;
end;

function Base.Data:Escape( string )
	if( self.Config.mysql.database ) then
		return self.Config.mysql.database:escape( string );
	end;
end;


function Base.Data:KeepAlive()
	if( Base.Data.KATimer < CurTime() ) then
		local db = Base.Data.Config.mysql.database;
		if( db ~= nil ) then
			db:status();
			Base.Data.KATimer = CurTime() + Base.Data.KADelay;
		end;
	end;
end;
--hook.Add( "Think", "Base.Data.KeepAlive", Base.Data.KeepAlive );


function Base.Data:ManageQueue()
	if( Base.Data.QueueTimer < CurTime() ) then
		if( #Base.Data.Queue > 0 ) then
			local result = Base.Data:Query( Base.Data.Queue[1] );
			if( result ~= nil ) then
				table.remove( Base.Data.Queue, 1 );
			end;
			Base.QueueTimer = CurTime() + Base.Data.QueueDelay;
		end;
	end;
	Base.QueueTimer = CurTime() + Base.Data.QueueDelay;
end;
--hook.Add( "Think", "Base.Data.ManageQueue", Base.Data.ManageQueue );

function Base.Data:InitialSetup()
	if( !self:TableExists( "Base_OrgData" ) ) then
		self:Query( "CREATE TABLE `Base_OrgData` ( `uniqueID` varchar(255), `title` varchar(255), `memberStr` varchar(255), `rankStr` varchar(255), `modStr` varchar(255) );" );
		self:Query( "CREATE TABLE `Base_MemberData` ( `uniqueID` varchar(255), `orgID` varchar(255), `flags` varchar(255), `nick` varchar(255), `rank` varchar(255) );" );
	end;
end;