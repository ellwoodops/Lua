/*---------------------------------------------------------------------------
Nacho's Money Printer
---------------------------------------------------------------------------*/
include("shared.lua")
include("config.lua")
function CanLevel(ply)
	for k,v in pairs(Config.CanLevelRanks) do
		if not (ply:GetUserGroup() == nil) then
			if ply:GetUserGroup() == v then
				return true
			end
		end
	end
	return false
end
function ENT:Initialize()
	self:SetNWInt("SLev", self:GetLVL())
	self:SetNWVector("Color", Config.Level[1])
end

function ENT:Draw()
	self:DrawModel()
	self:SetColor(Color(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z))
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Ang1 = self:GetAngles()
	local Ang2 = self:GetAngles()
	
	if self:GetPToggle() then
		Status = "On"
	else
		Status = "Off"
	end
	
	if self:GetCooler() then
		CoolStat = "Yes"
	else
		CoolStat = "No"
	end
	
	if self:GetOC() then
		OverStat = "Yes"
	else
		OverStat = "No"
	end
	
    local owner = self:Getowning_ent()
	if IsValid(owner) then
		if #owner:Nick() > 15 then
			owner = string.len(owner:Nick(), 1, 15)
		else
			owner = owner:Nick()
		end
	else
		owner = "Unknown"
	end
	local txt1 = Config.MoneyPrinterName.." ("..Status..")"
	txt2 = "$" ..self:GetPrintA()
	txt3 = "Stats"
	txt4 = "Level: "..self:GetLVL()+1
	txt5 = math.floor((self:GetExP()/100)*100)
	txt6 = "Cooler: "..CoolStat
	txt7 = "Overclocker: "..OverStat
	Heat = math.floor((self:GetHeat()/(Config.DefaultHeatAmount*(self:GetLVL()+1)))*100)
	
	surface.SetFont("DarkRPHUD1")
	local Size1 = self:GetExP()/100 * 236
	local Size2 = Heat/100* 236
	local Size3
	if Config.RequiresPower then
		Size3 = self:GetPower()/(Config.DefaultMaxPower*self:GetBatLevel()) * 236
		if Size3>236 then
			Size3 = 236
		end
		if Size3<0 then
			Size3 = 0
		end
	end
	if Size1>236 then
		Size1 = 236
	end
	if Size2>236 then
		Size2 = 236
	end
	
	Ang1:RotateAroundAxis(Ang1:Up(), 90)
	Ang2:RotateAroundAxis(Ang2:Up(), 90)
	Ang2:RotateAroundAxis(Ang2:Forward(), 90)
	
	cam.Start3D2D(Pos + Ang:Up() * 10.7, Ang1, 0.11)
		draw.RoundedBox(0, -128,-128,256,256, self:GetNWVector("Color"))
		draw.RoundedBox(0, -128,-128,256,256, Color(0,0,0,230))
		draw.RoundedBox(0, -128,-128,256,50, self:GetNWVector("Color"))
		
		draw.SimpleTextOutlined(txt1, "HUDNumber5", 0, -116, Color(255,255,255,255), 1, 2, 1, Color(0,0,0,255))
		draw.DrawText("Owned by: "..owner, "BudgetLabel", -118, -70, Color(255,255,255,255), 0)
		draw.DrawText("Stored: "..txt2.."|"..Config.DefaultMaxStorage+(Config.DefaultMaxStorage*self:GetLVL()), "BudgetLabel", -118, -55, Color(255,255,255,255), 0)
		draw.DrawText(txt4, "BudgetLabel", -118, -20, Color(255,255,255,255), 0)
		draw.DrawText(txt6, "BudgetLabel", -118, -5, Color(255,255,255,255), 0)
		draw.DrawText(txt7, "BudgetLabel", -118, 10, Color(255,255,255,255), 0)
		if self:GetFailSafes() == 0 then
			draw.DrawText("Fail Safe: None", "BudgetLabel", -118, 25, Color(255,255,255,255), 0)
		else
			draw.DrawText("Fail Safe: "..self:GetFailSafes(), "BudgetLabel", -118, 25, Color(255,255,255,255), 0)
		end
		if Config.RequiresPower then
			draw.RoundedBox(1, -123,69,246,53, self:GetNWVector("Color"))
			draw.RoundedBox(1, -123,69,246,53, Color(0,0,0,150))
			draw.RoundedBox(1, -118,72,236,15, Color(255,255,255,255))
			if (Size3>0) then
				draw.RoundedBox(1, -118,72,Size3,15, self:GetNWVector("Color"))
			end
			draw.RoundedBox(1, -118,102,236,15, Color(255,255,255,255))
			if (Size1>0) then
				draw.RoundedBox(1, -118,102,Size1,15, self:GetNWVector("Color"))
			end
			draw.DrawText("XP: "..txt5.."|100", "BudgetLabel", 0, 102, Color(255,255,255,255), 1)
			draw.DrawText("Power: "..self:GetPower().."|"..(Config.DefaultMaxPower*self:GetBatLevel()), "BudgetLabel", 0, 72, Color(255,255,255,255), 1)
		else
			draw.RoundedBox(1, -121,71,242,44, self:GetNWVector("Color"))
			draw.RoundedBox(1, -121,71,242,44, Color(0,0,0,150))
			draw.RoundedBox(1, -118,74,236,38, Color(255,255,255,255))
			if (Size1>0) then
				draw.RoundedBox(1, -118,74,Size1,38, self:GetNWVector("Color"))
			end
			draw.DrawText("XP: "..txt5.."|100", "BudgetLabel", 0, 85, Color(255,255,255,255), 1)
		end
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang2:Up()*16.9 + Ang2:Right()*-12, Ang2, 0.11)
		draw.RoundedBox(1, -128,10,256,100, self:GetNWVector("Color"))
		draw.RoundedBox(1, -128,10,256,100, Color(0,0,0,230))
		draw.DrawText(Heat.."%", "BudgetLabel", 118, 25, Color(255,255,255), 2)
		draw.DrawText("Heat: ", "BudgetLabel", -118, 25, Color(255,255,255), 0)
		draw.DrawText(self:GetMaxFSHeat().."%", "BudgetLabel", 118, 45, Color(255,255,255), 2)
		draw.DrawText("Max Heat: ", "BudgetLabel", -118, 45, Color(255,255,255), 0)
		draw.RoundedBox(1, -118,70,236,25,Color(255,255,255,255))
		if (Heat>0) then
			draw.RoundedBox(1, -118,70,Size2,25,self:GetNWVector("Color"))
		end
	cam.End3D2D()
end

function ENT:Derma()
	Panal = vgui.Create("DFrame")
	local owner = self:Getowning_ent()
	if IsValid(owner) then
		owner = (owner:Nick())
	else
		owner = "Unknown"
	end
	local ply = LocalPlayer()
	SizeX = 500
	SizeY = 185
	Panal:SetPos( ScrW()/2 - SizeX/2, ScrH()/2 - SizeY/2 )
	Panal:SetSize( SizeX, SizeY )
	Panal:SetVisible( true )
	Panal:SetTitle( owner.."'s Money Printer" )
	Panal:SetDraggable( false )
	Panal:ShowCloseButton( true )
	local SizeXb = Panal:GetWide()/2 - 100
	Panal.Paint = function(w,h)
		draw.RoundedBox(1, 0,0,Panal:GetWide(),Panal:GetTall(), self:GetNWVector("Color"))
		draw.RoundedBox(1, 0,0,Panal:GetWide(),Panal:GetTall(), Color(0,0,0,210))
		surface.DrawRect( 0, 0, Panal:GetWide(), Panal:GetTall() )
		surface.SetDrawColor(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z)
		surface.DrawRect( 0, 25, Panal:GetWide(), 2 )
		surface.DrawRect( 0, 25, 100, 2 )
		surface.DrawRect( 0, 0, Panal:GetWide(), 2 )
		surface.DrawRect( Panal:GetWide()/2, 85, Panal:GetWide()/2, 2 )
		surface.DrawRect( 0, Panal:GetTall()-2, Panal:GetWide(), 2 )
		surface.DrawRect( 0, 0, 2, Panal:GetTall() )
		surface.DrawRect( Panal:GetWide()-2, 0, 2, Panal:GetTall() )
		surface.DrawRect( Panal:GetWide()/2, 25, 2, Panal:GetTall()-25 )
				
		surface.SetDrawColor(255,255,255,255)
		draw.DrawText("Power:", "DarkRPHUD1", Panal:GetWide()/2 +40, 95, Color(255,255,255,255), 1)
		draw.DrawText("Heat:", "DarkRPHUD1", Panal:GetWide()/2 +40, 115, Color(255,255,255,255), 1)
		draw.DrawText("Money:", "DarkRPHUD1", Panal:GetWide()/2 +40, 135, Color(255,255,255,255), 1)
		draw.DrawText("XP:", "DarkRPHUD1", Panal:GetWide()/2 +40, 155, Color(255,255,255,255), 1)
		if not Config.RequiresPower then
			surface.SetDrawColor(50,50,50,255)
		end
		surface.DrawRect( Panal:GetWide()/2 + 90, 99, SizeXb, 10)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawRect( Panal:GetWide()/2 + 90, 119, SizeXb, 10)
		surface.DrawRect( Panal:GetWide()/2 + 90, 139, SizeXb, 10)
		surface.DrawRect( Panal:GetWide()/2 + 90, 159, SizeXb, 10)
		if Config.RequiresPower == true then
			surface.SetDrawColor(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z)
		else
			surface.SetDrawColor(255,255,255,255)
		end
		if (self:GetPower()/(Config.DefaultMaxPower*self:GetBatLevel())*SizeXb > 0) then
			surface.DrawRect( Panal:GetWide()/2 + 90, 99, self:GetPower()/(Config.DefaultMaxPower*self:GetBatLevel()) * SizeXb, 10)
		end
		surface.SetDrawColor(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z)	
		if (self:GetHeat()/(Config.DefaultHeatAmount*(self:GetLVL()+1)))*SizeXb > 0 then
			surface.DrawRect( Panal:GetWide()/2 + 90, 119, (self:GetHeat()/(Config.DefaultHeatAmount*(self:GetLVL()+1)))*SizeXb, 10)
		end
		if self:GetPrintA()/(Config.DefaultMaxStorage*(self:GetLVL()+1))*SizeXb > 0 then
			surface.DrawRect( Panal:GetWide()/2 + 90, 139, self:GetPrintA()/(Config.DefaultMaxStorage*(self:GetLVL()+1))*SizeXb, 10)
		end
		if (self:GetExP()/500)*SizeXb > 0 then
			surface.DrawRect( Panal:GetWide()/2 + 90, 159, (self:GetExP()/100)*SizeXb, 10)
		end
		
	end
	Panal:MakePopup()
	Collect = vgui.Create("DButton")
	Collect:SetParent( Panal )
	Collect:SetText( "" )
	Collect:SetPos(10,35)
	Collect:SetSize( (SizeX/2)-20, 40 )
	Collect.Paint = function(w,h)
		surface.SetDrawColor(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z)
		surface.DrawRect( 0, 0, (SizeX/2)-20,40 )
		draw.DrawText("Collect", "DarkRPHUD1", ((SizeX/2)-20)/2, 12, Color(255,255,255,255), 1)
	end
	Collect.DoClick = function ( btn )
		net.Start("DataSend")
			net.WriteFloat(2)
			net.WriteEntity(self)
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
	end
	Tog = vgui.Create("DButton")
	Tog:SetParent( Panal )
	Tog:SetText( "" )
	Tog:SetPos(10,85)
	Tog:SetSize( (SizeX/2)-20, 40 )
	Tog.Paint = function(w,h)
		surface.SetDrawColor(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z)
		surface.DrawRect( 0, 0, (SizeX/2)-20,40 )
		if self:GetPToggle() then
			draw.DrawText("Power (On)", "DarkRPHUD1", ((SizeX/2)-20)/2, 12, Color(255,255,255,255), 1)
		else
			draw.DrawText("Power (Off)", "DarkRPHUD1", ((SizeX/2)-20)/2, 12, Color(255,255,255,255), 1)
		end
	end
	Tog.DoClick = function ( btn )
		net.Start("DataSend")
			net.WriteFloat(1)
			net.WriteEntity(self)
		net.SendToServer()
	end
	if Config.RequiresPower == true then
		BatteryUp = vgui.Create("DButton")
		BatteryUp:SetParent( Panal )
		BatteryUp:SetText( "" )
		BatteryUp:SetPos(SizeX/2 +10,35)
		BatteryUp:SetSize( (SizeX/2)-20, 40 )
		BatteryUp.Paint = function(w,h)
			local price = (Config.BatteryUpgrade/2)*math.pow(2, self:GetBatLevel())
			surface.SetDrawColor(Color(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z))
			surface.DrawRect( 0, 0, SizeX/2 - 20,40 )
			draw.DrawText("Upgrade Battery [$"..price.."]", "DarkRPHUD1", ((SizeX/2)-20)/2, 12, Color(255,255,255,255), 1)
		end
		BatteryUp.DoClick = function ( btn )
			net.Start("DataSend")
				net.WriteFloat(3)
				net.WriteEntity(self)
				net.WriteEntity(LocalPlayer())
			net.SendToServer()
		end
	else
		BatteryUp = vgui.Create("DButton")
		BatteryUp:SetParent( Panal )
		BatteryUp:SetText( "" )
		BatteryUp:SetPos(SizeX/2 +10,35)
		BatteryUp:SetSize( (SizeX/2)-20, 40 )
		BatteryUp.Paint = function(w,h)
			local price = Config.BatteryUpgrade
			for i=1, self:GetBatLevel() do
				if (i==1) then continue end
				price = price+price
			end
			surface.SetDrawColor(50,50,50,255)
			surface.DrawRect( 0, 0, SizeX/2 - 20,40 )
			draw.DrawText("Upgrade Battery [$"..price.."]", "DarkRPHUD1", ((SizeX/2)-20)/2, 12, Color(100,100,100,255), 1)
		end
		BatteryUp.DoClick = function ( btn )
			
		end
	end
	if Config.SuperAdminsCanLevel == true and CanLevel(ply) then
		LevUp = vgui.Create("DButton")
		LevUp:SetParent( Panal )
		LevUp:SetText( "" )
		LevUp:SetPos(10,135)
		LevUp:SetSize( (SizeX/2)-20, 40 )
		LevUp.Paint = function(w,h)
			surface.SetDrawColor(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z)
			surface.DrawRect( 0, 0, SizeX/2 - 20,40 )
			draw.DrawText("Level Up", "DarkRPHUD1", ((SizeX/2)-20)/2, 12, Color(255,255,255,255), 1)
		end
		LevUp.DoClick = function ( btn )
			net.Start("DataSend")
				net.WriteFloat(4)
				net.WriteEntity(self)
				net.WriteEntity(LocalPlayer())
			net.SendToServer()
		end
	end
end

function RandomColour(ent)
	ent:SetNWVector("Color", Vector(math.random(255),math.random(255),math.random(255), 255))
	ent:SetColor(ent:GetNWVector("Color"))
end

function pulse(ent)
	timer.Simple(1, function()
		RandomColour(ent)
	end)
end
function ENT:Think()
	if self:GetLVL()<Config.MaxLevel then
		self:SetNWVector("Color", Config.Level[self:GetLVL()+1])
	else
		if Config.MaxLevel < 10 then
			self:SetNWVector("Color", Config.Level[Config.MaxLevel])
		end
	end
	if self:GetNWInt("SLev") ~= self:GetLVL() then
		self:SetColor(Color(self:GetNWVector("Color").x, self:GetNWVector("Color").y, self:GetNWVector("Color").z))
		if (self:GetLVL() > 10) then
			RandomColour(self)
		end
		if self:GetLVL() == 99 then
			if (timer.Exists("NewColor")) then timer.Stop("NewColor") end
			timer.Create("NewColor", 0.3, 0, function()
				RandomColour(self)
			end)
		end
		self:SetNWInt("SLev", self:GetLVL())
	end
end
net.Receive( "Derma", function()
	net.ReadEntity():Derma()
end)
