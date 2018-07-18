include("shared.lua")

surface.CreateFont("r96", {
	font = "Roboto Cn",
	size = 60,
	weight = 500,
	antialias = true,
	italic = true,
})

surface.CreateFont("r32", {
	font = "Roboto",
	size = 32,
	weight = 500,
	antialias = true,
	italic = true,
})

surface.CreateFont("r24", {
	font = "Roboto",
	size = 24,
	weight = 500,
	antialias = true,
	italic = true,
})

surface.CreateFont("r42", {
	font = "Roboto",
	size = 42,
	weight = 500,
	antialias = true,
	italic = true,
})

surface.CreateFont("r56", {
	font = "Roboto",
	size = 56,
	weight = 500,
	antialias = true,
	italic = true,
})
function ReceivePrinterInfo()
	local printer    	 =       net.ReadEntity()
	local tbl        	 =       net.ReadTable()

	printer.health       =       tbl.health
	printer.money        =       tbl.money
	printer.battery         =       tbl.battery
	printer.printtime    =       tbl.printtime
end
net.Receive('NET_PrinterRefresh', ReceivePrinterInfo)

function ENT:Initialize()
	self.money = 0
	self.health = 100
	self.battery = 1
	self.printtime = 0
	self.smoothmoney = 0
	self.smoothbattery = 0
	self.batterybar = hg_printer_vip.battery
	self.timebar = 0
	self.smoothtime = 0
end

function ENT:Draw()
	self:DrawModel()
	local ply = LocalPlayer()
	
	local distance  = ply:GetPos():Distance(self:GetPos())
	if distance > 200 then return end

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local x = -220
	local y = -217

	local w = 440
	local h = 376

	self.timebar = Lerp(0.04, self.timebar, self.printtime)
	self.batterybar = Lerp(0.04, self.batterybar, self.battery)
	self.smoothmoney = Lerp(0.04, self.smoothmoney, self.money)
	self.smoothbattery = Lerp(0.04, self.smoothbattery, self.battery)
	self.smoothtime = Lerp(0.04, self.smoothtime, self.printtime)

	local trace = {}
	trace.start = LocalPlayer():GetShootPos()
	trace.endpos = LocalPlayer():GetAimVector() * 200 + trace.start
	trace.filter = LocalPlayer()		
	trace = util.TraceLine(trace)	
	local hitpos = self:WorldToLocal(trace.HitPos)	
	
	concommand.Add("print_trace", function() print(hitpos) end)

    	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")
	
	Ang:RotateAroundAxis(Ang:Up(), 90)
	
	cam.Start3D2D(Pos + Ang:Up() * 8, Ang, 0.05)
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(x, y, w, h)
		surface.DrawRect(x + 5, y + 5, w - 10, 100) -- Title Background
		surface.DrawRect(x + 5, y + 110, w - 10, 50) -- Battery Background
		surface.DrawRect(x + 5, y + 165, w - 10, 50) -- Progress Background
		surface.DrawRect(x + 5, y + 220, w - 10, 50) -- Money Background

		draw.SimpleTextOutlined(owner.."'s", "r32", x + 10, y + 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined(hg_printer_vip.name, "r96", x + 220, y + 100, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))

		surface.SetDrawColor(0, 60, 255, 255)
		surface.DrawRect(x + 10, y + 115, self.batterybar * 420, 40)
		draw.SimpleTextOutlined("Battery: "..math.Round(self.battery * 100).."%", "r32", x + 15, y + 130, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		surface.SetDrawColor(0, 123, 46, 255)
		surface.DrawRect(x + 10, y + 170, self.timebar * (420 / (hg_printer_vip.printtime - 1)), 40)
		draw.SimpleTextOutlined("Next Print: "..math.Round(((self.smoothtime / hg_printer_vip.printtime)*100)+14).."%", "r32", x + 15, y + 185, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		draw.SimpleTextOutlined("Money: $"..math.Round(self.smoothmoney), "r32", x + 220, y + 243, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		surface.SetDrawColor(0, 0, 0, 150)
		if trace.Entity == self and hitpos.x > 2.93 and hitpos.x < 6.37 and hitpos.y > -10.71  and hitpos.y < -0.1  and distance < 100 then
			surface.SetDrawColor(0, 123, 46, 150)
			if ply:KeyDown(IN_USE) and (not ply.wait or ply.wait < CurTime()) then
				ply.wait = CurTime() + 1
				net.Start("NET_PrinterAction")
					net.WriteEntity(ply)
					net.WriteEntity(self)
					net.WriteInt(2, 16)
				net.SendToServer()
			end
		end
		surface.DrawRect(x + 5, y + 275, ((w / 2) - 7.5), 70)
		draw.SimpleTextOutlined("Collect", "r32", x + 110, y + 305, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		surface.SetDrawColor(0, 0, 0, 150)
		if trace.Entity == self and hitpos.x > 2.93 and hitpos.x < 6.37 and hitpos.y > 0.20 and hitpos.y < 10.71  and distance < 100 then
			surface.SetDrawColor(0, 60, 255, 150)
			if ply:KeyDown(IN_USE) and (not ply.wait or ply.wait < CurTime()) then
				ply.wait = CurTime() + 1
				net.Start("NET_PrinterAction")
					net.WriteEntity(ply)
					net.WriteEntity(self)
					net.WriteInt(1, 16)
				net.SendToServer()
			end
		end
		surface.DrawRect(x + 223, y + 275, ((w / 2) - 7.5), 70)
		draw.SimpleTextOutlined("Battery ( $"..hg_printer_vip.newbattery.." )", "r32", x + 330, y + 305, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	cam.End3D2D()
end 

function ENT:Think()
end