local model = "models/Items/car_battery01.mdl" -- What model should it be?
local classname = "printer_largebattery" -- This should be the name of the folder containing this file.
local ShouldSetOwner = true -- Set the entity's owner?

-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
--------------------
-- Spawn Function --
--------------------
function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 25
	local ent = ents.Create( classname )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	if ShouldSetOwner then
		ent.Owner = ply
	end
	return ent
	
end
function ENT:Initialize()
	self.Entity:SetModel( model )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetNWInt("dhold", 0)
end
function ENT:Touch(ent)
	if self:GetNWInt("dhold")==0 then
		if (ent:GetClass() == "adv_moneyprinter") then
			self:SetNWInt("dhold", 1)
			if (ent:GetPower()<Config.DefaultMaxPower*ent:GetBatLevel()) then
			
			end
			self:Remove()
			ent:AddPower(Config.DefaultMaxPower)
		end
	end
end


--Copyright © Edward Peter Lemon AKA "TheGreatNacho", 2013