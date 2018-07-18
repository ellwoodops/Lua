/*---------------------------------------------------------------------------
Nacho's Money Printer
---------------------------------------------------------------------------*/
include("config.lua")
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = Config.MoneyPrinterName
ENT.Author = "TheGreatNacho"
ENT.Category = "Advanced Moneyprinter"
ENT.Spawnable = true
ENT.AdminSpawnable = true
MaxHeat = Config.DefaultHeatAmount
PrintAmount = Config.DefaultPrintAmount

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar( "Float", 1, "ExP") -- 0
	self:NetworkVar( "Int", 2, "LVL") -- 0
	self:NetworkVar( "Float", 3, "Heat") -- 0
	self:NetworkVar( "Int", 4, "BatLevel") -- 1
	self:NetworkVar( "Int", 5, "FailSafes") -- 0
	self:NetworkVar( "Int", 6, "MaxFSHeat") -- 100
	self:NetworkVar( "Float", 7, "Power") -- Config.DefaultMaxPower
	self:NetworkVar( "Int", 8, "PrintA") -- Config.DefaultMaxPower
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar( "Bool", 0, "PToggle") -- true
	self:NetworkVar( "Bool", 1, "Cooler") -- false
	self:NetworkVar( "Bool", 2, "OC") -- false
	self:NetworkVar( "String", 0, "PID") -- "adv_moneyprinter"
end