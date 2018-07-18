AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("NET_PrinterRefresh")
util.AddNetworkString("NET_PrinterAction")

function ENT:Initialize()
	self:SetModel(hg_printer.model)
	self:SetMaterial(hg_printer.material)
	self:SetColor(hg_printer.color)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self.IsMoneyPrinter = true

	// PRINTER VARS
	self.health = hg_printer.starthealth
	self.money = 0
	self.battery = hg_printer.battery
	self.printtime = 0
	self.battstatus = hg_printer.draintotal

	self:BatteryModule()
end

function ENT:SetValues(money, battery)
	self.money = money
	self.battery = battery
end

function UpdatePrinterInfo(printer)
	local tbl                     = {}
	tbl.health        =       printer.health
	tbl.money        =       printer.money
	tbl.battery        =       printer.battery
	tbl.printtime    =       printer.printtime

	net.Start('NET_PrinterRefresh')
		net.WriteEntity(printer)
		net.WriteTable(tbl)
	net.Broadcast()
end

function PrinterAction()
	local action_battery = 1
	local action_money = 2

	local ply = net.ReadEntity()
	local printer = net.ReadEntity()
	local action = net.ReadInt(16)

	if action == action_battery then
		if printer.battery >= hg_printer.battery then return end
		printer.battery = hg_printer.battery
		ply:addMoney(-hg_printer.newbattery)
		DarkRP.notify(ply, 1, 4, "You bought a new battery for $"..hg_printer.newbattery)
	end

	if action == action_money then
		if printer.money <= 0 then return end
		ply:addMoney(printer.money)
		DarkRP.notify(ply, 1, 4, "You have collected $"..printer.money.." from a money printer.")
		printer.money = 0
	end
	UpdatePrinterInfo(printer)
end
net.Receive("NET_PrinterAction", PrinterAction)

function ENT:BatteryModule()
	timer.Create("BatteryTimer"..self:EntIndex(), 1, 0, function()
		if not IsValid(self) then return end
		if self.battery <=  0 then return end

		self.printtime = (self.printtime + 1)
		self.battery = (self.battery - hg_printer.drainrate)

		if self.printtime >= hg_printer.printtime then
			self:Print()
			self.printtime = 0
		end

		if self.battery < 0 then
			self.battery = 0
		end
		UpdatePrinterInfo(self)
	end)
end

function ENT:Print()
	if not IsValid(self) then return end
	local rndamount = math.Round(math.Rand(hg_printer.amount, (hg_printer.amount + 20)))

	self.oldmoney = self.money
	self.money = (self.money + rndamount)

	UpdatePrinterInfo(self)
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.health = (self.health or 100) - dmg:GetDamage()
	if self.health <= 0 then
		self:Destruct()
		self:Remove()
	end
	UpdatePrinterInfo(self)
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end