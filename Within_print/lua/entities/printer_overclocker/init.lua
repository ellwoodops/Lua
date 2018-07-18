local model = "models/props_lab/reciever01b.mdl" -- What model should it be?
local classname = "printer_overclocker" -- This should be the name of the folder containing this file.
local ShouldSetOwner = true -- Set the entity's owner?

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
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
end

function ENT:Touch(ent)
	if ent:GetClass() == "adv_moneyprinter" and ent:GetOC()==false then
		ent:AddOC()
		self:Remove()
	end
end
--Copyright © Edward Peter Lemon AKA "TheGreatNacho", 2013