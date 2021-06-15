MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Name = "Camera";

function MODULE.Hooks:CalcView( client, pos, angles, fov )
	
	--print( self, client, pos, angles, fov );

	local view = {};
	view.origin = pos - client:GetForward() * 90 + client:GetRight() * 20;
	view.angles = angles;
	view.fov = fov;
	
	
	--return view;
end;