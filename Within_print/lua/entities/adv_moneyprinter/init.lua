/*---------------------------------------------------------------------------
Nacho's Money Printer
---------------------------------------------------------------------------*/
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
include("shared.lua")
include("config.lua")
--[[ Net Library NetworkString ]]--
util.AddNetworkString( "Derma" )
util.AddNetworkString( "DataSend" )
ENT.SeizeReward = 950
local PrintMore
local ReHeat
local dhold = 0
function CanLevel(ply)
	for k,v in pairs(Config.CanLevelRanks) do
		if not (ply:GetUserGroup() == nil )then
			if ply:GetUserGroup() == v then
				return true
			end
		end
	end
	return false
end


function ENT:Initialize()
	if gmod.GetGamemode().Name ~= "DarkRP" then
		self:Remove()
		error("Server needs to be DarkRP")
	end
	Push = 1
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.damage = 100
	self.IsMoneyPrinter = true
	timer.Simple(1, function() PrintMore(self) end)
	self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
	self.sound:SetSoundLevel(52)
	self.sound:PlayEx(1, 100)
	timer.Simple(1, function() ReHeat(self) end)
	self:SetExP(0)
	self:SetLVL(0)
	self:SetHeat(0)
	self:SetBatLevel(1)
	self:SetFailSafes(0)
	self:SetMaxFSHeat(100)
	self:SetPower(Config.DefaultMaxPower)
	self:SetPToggle(true)
	self:SetCooler(false)
	self:SetOC(false)
	self:SetPID("adv_moneyprinter")
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	DarkRP.notify(self:Getowning_ent(), 1, 4, DarkRP.getPhrase("money_printer_exploded"))
end

function ENT:BurstIntoFlames()
	DarkRP.notify(self:Getowning_ent(), 0, 4, DarkRP.getPhrase("money_printer_overheating"))
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(20, 280) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end
	end
	self:Remove()
end

PrintMore = function(ent)
	if not IsValid(ent) then return end
	timer.Simple(1, function()
		if not IsValid(ent) then return end
		ent:CreateMoneybag()
	end)
end

ReHeat = function(ent)
	if not IsValid(ent) then return end
	ent:SecondTick()
end

function ENT:CreateMoneybag()
	if self:GetPToggle() == true then
		if not IsValid(self) or self:IsOnFire() then return end
		if not (self:GetPrintA() >= Config.DefaultMaxStorage+(Config.DefaultMaxStorage*self:GetLVL())) then
			amount = self:GetPrintA()+(Config.DefaultPrintAmount*(1+(self:GetLVL()*0.5)))
			XP = self:GetExP()+ Config.XPBoost / (self:GetLVL()+1)
			if amount >Config.DefaultMaxStorage+(Config.DefaultMaxStorage*self:GetLVL()) then
				amount = Config.DefaultMaxStorage+(Config.DefaultMaxStorage*self:GetLVL())
			end
			self:SetPrintA(amount)
			if self:GetExP()<100 then
				self:SetExP(XP)
			end
			if self:GetExP()>=100 then
				self:LevelUp()
			end
		end
	end
	if self:GetOC() then
		timer.Simple(math.random(1,5), function() PrintMore(self) end)
	else
		timer.Simple(math.random(1,20), function() PrintMore(self) end)
	end
end

function ENT:SecondTick()
	local heat
	local power = 1
	if (self:GetHeat()>=(Config.DefaultHeatAmount*(self:GetLVL()+1))) then
		self:BurstIntoFlames()
	else
		if self:GetPToggle()==true then
			if Config.RequiresPower == true then
				if self:GetPower()>0 then
					if self:GetCooler()==true then
						heat = self:GetHeat()+0.2
						power = power+3
					else
						heat = self:GetHeat()+1
					end
					if self:GetOC() == true then
						power = power+5
					end
					if (self:GetPrintA() >= Config.DefaultMaxStorage+(Config.DefaultMaxStorage*self:GetLVL())) then
						heat = heat + 5
					end
					if Config.RequiresPower == true then
						power = self:GetPower()-power
						self:SetPower( power)
					end
					self:SetHeat( heat)
				else
					
					if self:GetPToggle() == true then
						self:TurnOff()
					end
				end
			else
				if self:GetCooler()==true then
					heat = self:GetHeat()+0.2
				else
					heat = self:GetHeat()+1
				end
				self:SetHeat( heat)
			end
		else
			if self:GetHeat()>0 then
				if self:GetCooler()==true then
					heat = self:GetHeat()-9
				else
					heat = self:GetHeat()-3
				end
				if heat<0 then
					heat = 0
				end
				self:SetHeat( heat)
			end
		end
		if self:GetFailSafes() > 0 and self:GetHeat() >= ((self:GetMaxFSHeat()/100)*(Config.DefaultHeatAmount*(self:GetLVL()+1))) then
			local rnd = math.random(1,100)
			if rnd ~= 3 then
				self:TurnOff()
			end
			local Fsafe = self:GetFailSafes() - 1
			self:SetFailSafes( Fsafe)
		end
		timer.Simple(1, function() ReHeat(self) end)
	end
end

function ENT:Use(activator)
	if dhold == 0 then
		dhold = 1
		net.Start( 'Derma' )
			net.WriteEntity(self)
		net.Send(activator)
		timer.Simple(1, function() dhold = 0 end)
	end
end

function ENT:Print(ply)
	if self:GetPrintA() >= 1 then
		ply:addMoney(self:GetPrintA())
		DarkRP.notify(ply, 1, 4, "You have collected $"..self:GetPrintA().." from a "..self.PrintName..".")
		self:SetPrintA(0)
	end
end

function ENT:Think()
	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end
function cappedRank(printer)
	local ply = printer:Getowning_ent()
	if not ply:IsPlayer() then return false end
	if (Config.LevelRank[ply:GetUserGroup()]) then
		return !(Config.LevelRank[ply:GetUserGroup()] > printer:GetLVL()+1)
	end
	return false
end
function ENT:LevelUp()
	if (Config.CapRanks and cappedRank(self)) then return end
	
	if (self:GetLVL()<Config.MaxLevel-1) or (Config.LevelCap == false) then
		local Level = self:GetLVL()+1
		self:SetLVL( Level)
		self:SetExP(0)
	end
end

function ENT:AddCooler()
	self:SetCooler( true)
end
function ENT:AddOC()
	self:SetOC( true)
end
function ENT:TurnOff()
	self:SetPToggle( false)
	self.sound:Stop()
end
function ENT:TurnOn()
	self:SetPToggle( true)
	self.sound:PlayEx(1, 100)
end
function ENT:AddFailsafe(HeatSet)
	if HeatSet > 0 then
		local Fsafe = self:GetFailSafes() + 1
		self:SetFailSafes( Fsafe)
		self:SetMaxFSHeat( HeatSet)
	else
		local Fsafe = self:GetFailSafes() + 1
		self:SetFailSafes( Fsafe)
	end
end

function ENT:AddPower(amount)
	amount = tonumber(amount)
	if (self:GetPower()<(Config.DefaultMaxPower*self:GetBatLevel())-amount) then
		local power = self:GetPower()+amount
		self:SetPower( power)
	else
		if self:GetPower() == (Config.DefaultMaxPower*self:GetBatLevel()) then
		
		else
			self:SetPower( (Config.DefaultMaxPower*self:GetBatLevel()))
		end
	end
end
net.Receive("DataSend", function()
	local IntType = net.ReadFloat()
	local ent = net.ReadEntity()
	local ply = net.ReadEntity()
	if IntType == 1 then
		if ent:GetPToggle() == false then
			ent:TurnOn()
		elseif ent:GetPToggle() == true then
			ent:TurnOff()
		end
	end
	if IntType == 2 then
		ent:Print(ply)
	end
	if IntType == 3 then
		local price = (Config.BatteryUpgrade/2)*math.pow(2, ent:GetBatLevel())
		if ply:getDarkRPVar("money")>=price then
			ply:addMoney(-price)
			ent:SetBatLevel( ent:GetBatLevel()+1)
		end
	end
	if IntType == 4 then
		if CanLevel(ply) then
			ent:LevelUp()
		end
	end
end)

hook.Add("canPocket", "CanPocketPrinter", function(ply, ent)
	if ent == ENT then
		return false
	end
end)