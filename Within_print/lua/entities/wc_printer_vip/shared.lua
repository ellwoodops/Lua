ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "Husky Hobo"
ENT.Category = "Halcyon"
ENT.Spawnable = true
ENT.AdminSpawnable = true

hg_printer_vip                                                                       ={}
hg_printer_vip.name                                                            = "VIP Money Printer"
hg_printer_vip.color                                                             = Color(255, 255, 255, 255)
hg_printer_vip.model                                                           = "models/props_c17/consolebox03a.mdl"
hg_printer_vip.material                                                       = "phoenix_storms/gear"
hg_printer_vip.health                                                          = 100
hg_printer_vip.amount                                                        = 54
hg_printer_vip.battery                                                        = 1
hg_printer_vip.drainrate                                                     =  0.002
hg_printer_vip.printtime                                                     =  7
hg_printer_vip.newbattery                                                = 50



function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar("Entity", 0, "owning_ent")
end
