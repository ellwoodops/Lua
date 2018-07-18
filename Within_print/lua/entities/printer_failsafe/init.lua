local model = "models/props_lab/reciever01a.mdl" -- What model should it be?
local classname = "printer_failsafe" -- This should be the name of the folder containing this file.
local ShouldSetOwner = true -- Set the entity's owner?

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.AddNetworkString( "DermaFS" )
util.AddNetworkString( "DataSendFS" )
local dhold = 0
local bhold = 0
local FSMaxHeat = 50
local Edit = false
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
	FSMaxHeat = 50
	self.Entity:SetModel( model )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(ply)
	if dhold == 0 then
		dhold = 1
		net.Start("DermaFS")
			net.WriteEntity(self)
			net.WriteFloat(FSMaxHeat)
		net.Send(ply)
		timer.Simple(1, function() dhold = 0 end)
	end
end

function ENT:Touch(ent)
	if ent:GetClass() == "adv_moneyprinter" and bhold == 0 then
		bhold = 1
		if Edit == true then
			ent:AddFailsafe(FSMaxHeat)
		else
			ent:AddFailsafe(0)
		end
		self:Remove()
		timer.Simple(1, function() bhold = 0 end)
	end
end

net.Receive("DataSendFS", function()
	local Heat = net.ReadFloat()
	local ent = net.ReadEntity()
	local ply = net.ReadEntity()
	FSMaxHeat = Heat
	Edit = true
end)
--Copyright © Edward Peter Lemon AKA "TheGreatNacho", 2013