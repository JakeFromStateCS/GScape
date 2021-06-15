


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "melee"
	
end

if ( CLIENT ) then

         SWEP.PrintName	                = "Frying Pan"	 
         SWEP.Author				= "alzahos"
         SWEP.Category = "Melee"
         SWEP.Slot			        = 0					 
         SWEP.SlotPos		        = 1
         SWEP.DrawAmmo                  = false					 
         SWEP.IconLetter			= "w"

         killicon.AddFont( "weapon_crowbar", 	"HL2MPTypeDeath", 	"6", 	Color( 255, 80, 0, 255 ) )

end


SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel		= "models/weapons/v_fryingpan/v_fryingpan.mdl"	 
SWEP.WorldModel		= "models/weapons/w_fryingpan.mdl"	
SWEP.DrawCrosshair              = false

SWEP.ViewModelFOV = 75

SWEP.ViewModelFlip = false


SWEP.Weight				= 1			 
SWEP.AutoSwitchTo		= true		 
SWEP.AutoSwitchFrom		= false	
SWEP.CSMuzzleFlashes		= false	  	 		 
	
	 
SWEP.Primary.Damage			= 20						 			  
SWEP.Primary.ClipSize		= -1		
SWEP.Primary.Delay			= 0.9		  
SWEP.Primary.DefaultClip	= 1		 
SWEP.Primary.Automatic		= true		 
SWEP.Primary.Ammo			= "none"	 

SWEP.Secondary.ClipSize		= -1			
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Damage			= 0		 
SWEP.Secondary.Automatic		= false		 
SWEP.Secondary.Ammo			= "none"

function SWEP:Precache()

	util.PrecacheSound("weapons/melee/frying_pan/pan_hit-01.wav")
	util.PrecacheSound("weapons/melee/frying_pan/pan_hit-02.wav")
	util.PrecacheSound("weapons/melee/frying_pan/pan_hit-03.wav")
	util.PrecacheSound("weapons/melee/frying_pan/pan_hit-04.wav")

end

SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/melee/frying_pan/pan_hit-0"..math.random(1, 4)..".wav")

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 50 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

		if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 20
			self.Owner:FireBullets(bullet) 
		else
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 20
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( self.WallSound )		
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		end
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	return false
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end

