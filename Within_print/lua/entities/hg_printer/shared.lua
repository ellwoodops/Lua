ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "Husky Hobo"
ENT.Category = "Halcyon"
ENT.Spawnable = true
ENT.AdminSpawnable = true

hg_printer                                                                       ={}
hg_printer.name                                                            = "Money Printer"
hg_printer.color                                                             = Color(255, 255, 255, 255)
hg_printer.model                                                           = "models/props_c17/consolebox03a.mdl"
hg_printer.material                                                       = "phoenix_storms/gear"
hg_printer.health                                                          = 100
hg_printer.amount                                                        = 27
hg_printer.battery                                                        = 1
hg_printer.drainrate                                                     =  0.002
hg_printer.printtime                                                     =  7
hg_printer.newbattery                                                = 50



function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar("Entity", 0, "owning_ent")
end
