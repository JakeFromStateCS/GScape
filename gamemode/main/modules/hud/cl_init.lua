--The hud includes all the elements that make up the clientside hud experience
--Meaning, things such as the view etc.

MODULE = MODULE or {};
MODULE.Name = "Hud";
MODULE.Hooks = {};

MODULE.HUDShouldDraw = {
	["CHudHealth"] = false,
	["CHudBattery"] = false
};

function MODULE:OnLoad()

end;

function MODULE.Hooks:HUDPaint()
	surface.SetDrawColor( Color( 255, 255, 255 ) );
	surface.DrawRect( ScrW() / 2, ScrH() / 2, 10, 10 );
end;

function MODULE.Hooks:ShouldDrawLocalPlayer()
	--return true;
end;