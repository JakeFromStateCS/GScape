MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Name = "Character";

if( SERVER ) then
	util.AddNetworkString( "character_move" );

	function MODULE:MoveCharacter()
		print( "MOVE CHARACTER" );
		local client = net.ReadEntity();
		local pos = net.ReadVector();
		print( pos );
		if( client.Character:IsValid() ) then
			client.Character:MoveToPos( pos );
		end;
	end;
	net.Receive( "character_move", MODULE.MoveCharacter )

	function MODULE.Hooks:PlayerInitialSpawn( client )
		local char = ents.Create( "npc_character" );
		char:SetPos( client:GetPos() );
		char:SetAngles( client:GetAngles() );
		char:Spawn();
		client.Character = char;
	end;

	function MODULE.Hooks:PlayerButtonDown( client, button )
		print( client, button );
		if( button == MOUSE_LEFT ) then

			if( client.Character:IsValid() ) then
				net.Start( "character_move" );
					net.WriteEntity( client.Character );
				net.Send( client );
			end;
		end;
	end;
end;

if( CLIENT ) then
	MODULE.View = {
		["up"] = 60,
		["forward"] = 150,
		["rLeft"] = 0,
		["rRight"] = 0
	};
	MODULE.Angles = Angle( 50, 0, 0 );

	function OrbitCamera(p,a1,x)
	    local a2=(a1:Forward()*-1):Angle();
	    local c=Vector(x,0,0);
	    c:Rotate(a1);
	    c=c+p;
	    return c,a2;
	end

	local m_Angles = Angle( 25, 0, 0 );
	local m_fRotateSpeed = 1;
	local m_fZoom = 256;
	local m_fHeight = 0;

	function MODULE.Hooks:CalcView( client, pos, angles, fov )

		if ( input.IsKeyDown( KEY_LEFT ) ) then
			m_Angles:RotateAroundAxis( Vector( 0, 0, 1 ), -m_fRotateSpeed );
		end;
		if ( input.IsKeyDown( KEY_RIGHT ) ) then
			m_Angles:RotateAroundAxis( Vector( 0, 0, 1 ), m_fRotateSpeed );
		end;
		if( input.IsKeyDown( KEY_UP ) ) then
			m_Angles.p = math.Clamp( m_Angles.p + 1, 25, 89 );
			m_fZoom = math.Clamp( m_fZoom + 3, 256, 420 )
		end;
		if( input.IsKeyDown( KEY_DOWN ) ) then
			m_Angles.p = math.Clamp( m_Angles.p - 1, 25, 89 );
			m_fZoom = math.Clamp( m_fZoom - 3, 256, 420 );
		end
		
		local aBackward = ( m_Angles:Forward() * -1 ):Angle();
		local aForward = ( aBackward:Forward() * -1 ):Angle();
		
		vOrigin = Vector( m_fZoom, 0, 0 );
		vOrigin:Rotate( aBackward );
		vOrigin = vOrigin + LocalPlayer().Character:EyePos(); -- Add the vector you want to orbit around.
		
		client.View = vOrigin;
		return { origin = vOrigin, angles = aForward };
	end;

	function MODULE:MoveCharacter()
		local character = net.ReadEntity();
		if( character:IsValid() ) then
			print( character );
			LocalPlayer().Character = character;
		end;
		local trace = {
			["start"] = LocalPlayer().View,
			["endpos"] = LocalPlayer().View + gui.ScreenToVector( gui.MousePos() ) * 1000,
			["filter"] = { LocalPlayer(), LocalPlayer().Character }
		};
		local tr = util.TraceLine( trace );
		print( tr.HitPos );
		LocalPlayer().MovePos = tr.HitPos;
		LocalPlayer().MoveTime = CurTime();
		net.Start( "character_move" );
			net.WriteEntity( LocalPlayer() );
			net.WriteVector( tr.HitPos );
		net.SendToServer();
	end;
	net.Receive( "character_move", MODULE.MoveCharacter );

	function MODULE.Hooks:HUDPaint()

		local pos = Vector( 0, 0, 0 );
		local moveTime = LocalPlayer().MoveTime or 0;
		moveTime = CurTime() - moveTime;
		local length = math.Clamp( 10 - moveTime * 30, 0, 10 );
		if( LocalPlayer().MovePos ) then
			pos = LocalPlayer().MovePos:ToScreen();
		end;

		surface.SetDrawColor( Color( 255, 255, 0 ) );
		surface.DrawLine( pos.x, pos.y, pos.x - length, pos.y - length );
		surface.DrawLine( pos.x + 1, pos.y + 1, pos.x - length, pos.y - length );
		
		surface.DrawLine( pos.x, pos.y, pos.x + length, pos.y + length );
		surface.DrawLine( pos.x + 1, pos.y + 1, pos.x + length, pos.y + length );
		
		surface.DrawLine( pos.x, pos.y, pos.x + length, pos.y - length );
		surface.DrawLine( pos.x + 1, pos.y + 1, pos.x + length, pos.y - length );
		
		surface.DrawLine( pos.x, pos.y, pos.x - length, pos.y + length );
		surface.DrawLine( pos.x + 1, pos.y + 1, pos.x - length, pos.y + length );
		
		
		--surface.DrawRect( pos.x, pos.y, 10, 10 );
		
	end;


end;