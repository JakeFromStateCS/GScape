--

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 2
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.HoldType			= "pistol"
	SWEP.itemDatas = {
		["spawned_weapon"] = {
			"weaponclass"
		},
		["spawned_food"] = {
			"FoodEnergy"
		},
		["spawned_shipment"] = {
			["dt"] = {
				"contents",
				"count",
			}
		},
		["empty_box"] = {
			"storedItems"
		}
	};
	SWEP.WhiteList = {
		"spawned_weapon",
		"durgz_weed",
		"durgz_cocaine",
		"durgz_lsd",
		"durgz_pcp",
		"empty_box",
		"weapon_fas_m4a1"
	};
end

if ( CLIENT ) then
	SWEP.PrintName = "Inventory Tester";
	SWEP.Slot = 3;
	SWEP.SlotPos = 1;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = true;
end

SWEP.Author = "Blasphemy";
SWEP.Contact = "";
SWEP.Purpose = "gg";
SWEP.Instructions = "gg";

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"

function SWEP:Initialize()
	self.reload = 0
end;

function SWEP:Reload()

	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 ) then

		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		self.Weapon:EmitSound( "Weapon_Pistol.Reload" )
 
	end
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
	if( SERVER ) then
		local ent = self.Owner:GetEyeTrace().Entity;
		if( ent:IsValid() ) then
			if( ent:GetPos():Distance( self.Owner:GetPos() ) <= 100 ) then
				if( table.HasValue( self.WhiteList, ent:GetClass() ) ) then
					local itemTable = {};
					itemTable.model = ent:GetModel();
					itemTable.class = ent:GetClass();
					if( self.itemDatas[itemTable.class] != nil ) then
						for k,v in pairs( self.itemDatas[itemTable.class] ) do
							if( ent:GetClass() == "spawned_shipment" and k == "dt" ) then
								itemTable.dt = {};
								for k,v in pairs( v ) do
									print( v );
									itemTable.dt[v] = ent.dt[v];
								end;
							end;
							if( k != "dt" ) then
								itemTable[v] = ent[v];
							end;
							PrintTable( itemTable );
						end;
					end;
					BW_Inventory.Functions:StoreItem( self.Owner, itemTable );
					ent:Remove();
				end;
			end;
		end;
	end;
end

function SWEP:SecondaryAttack()
	if( SERVER ) then
		PrintTable( BW_Inventory.Items[self.Owner][table.Count( BW_Inventory.Items[self.Owner] )] );
		BW_Inventory.Functions:PocketItem( self.Owner, BW_Inventory.Items[self.Owner][table.Count( BW_Inventory.Items[self.Owner] )] );
	end;
end;

function SWEP:Reload()
	if( CLIENT ) then
		if( self.reload < CurTime() ) then
			BW_Inventory.Functions.Menu();
			self.reload = CurTime() + 1;
		end;
	end;
end;
