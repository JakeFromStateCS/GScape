AddCSLuaFile()


ENT.Base             = "base_nextbot"
ENT.Spawnable        = true


function ENT:Initialize()
    self:SetModel( "models/mossman.mdl" );
end


function ENT:BehaveAct()
end


function ENT:RunBehaviour()
    while ( true ) do
        if( self.NewMove ) then
            self:MoveToVec( self.MoveTo, 10 );
            self.NewMove = false;
        end;
        if( self.Move and self.MoveTo ) then
            self.Idle = false;
            self:StartActivity( ACT_RUN )
            self:MoveToVec( self.MoveTo, 10 );
            if( self:GetPos() == self.MoveTo ) then
                self.Move = false;
            end;
        else
            self:StartActivity( ACT_IDLE );
        end;
        coroutine.yield()
    end
end

function ENT:MoveToVec( gpos, reach, options )

    local options = options or {}
    local updrate = options.updaterate or 0.3
    
    local pp = gpos;
    local np = self:GetPos()
    local dir = ( np - pp )
    dir:Normalize()
    local pos = pp + dir * reach
    
    local path = Path( "Follow" )
    path:SetMinLookAheadDistance( options.lookahead or 300 )
    path:SetGoalTolerance( options.tolerance or 20 )
    path:Compute( self, pos )
    self.updt = CurTime()

    if ( !path:IsValid() ) then return "failed" end

    while ( path:IsValid() ) do

        path:Update( self )

        if ( options.draw ) then
            path:Draw()
        end
        
        if self.updt < CurTime() then
            
            local pp = gpos;
            
            if pp:Distance( pos ) > reach * 1.5 then
            
                local dir = ( np - pp )
                dir:Normalize()
                local pos = pp + dir * reach
            
                path:Compute( self, pos )
                
            end
            
            self.updt = CurTime() + updrate
        end
        
        if ( self.loco:IsStuck() ) then

            self:HandleStuck();

            return "stuck"

        end

        if ( options.maxage ) then
            if ( path:GetAge() > options.maxage ) then return "timeout" end
        end

        if ( options.repath ) then
            if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
        end

        coroutine.yield()

    end

    return "ok"

end

function ENT:MoveToPos( pos )
    self.MoveTo = pos;
    self.Move = true;
    self.NewMove = true;
end;


-- List the NPC as spawnable
list.Set( "NPC", "npc_tf2_ghost",     {    Name = "TF2 Ghost", 
                                        Class = "npc_tf2_ghost",
                                        Category = "TF2"    
                                    })