
include('shared.lua')
function ENT:Initialize()
	
	self.Color = Color( 255, 255, 255, 255 )
	
end

function ENT:Draw()
	
	--self:DrawEntityOutline( 1 )
	self.Entity:DrawModel()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	Ang:RotateAroundAxis(Ang:Up(), 90)
	cam.Start3D2D(Pos + Ang:Up()*4 + Ang:Right()*-2, Ang, 0.11)
		draw.DrawText(self.PrintName, "HUDNumber5", 0, -15, Color(255,255,255,255), 1)
		draw.DrawText("Press 'E' to modify", "ChatFont", 0, 15, Color(255,255,255,255), 1)
		draw.DrawText("Fail safe settings", "ChatFont", 0, 30, Color(255,255,255,255), 1)
	cam.End3D2D()
end

function ENT:Derma(Heat)
	local Panal = vgui.Create("DFrame")
	Panal:SetPos( ScrW()/2 - 100, ScrH()/2 - 100 )
	Panal:SetSize( 200, 120 )
	Panal:SetVisible( true )
	Panal:SetTitle( "Fail Safe" )
	Panal:SetDraggable( false )
	Panal:ShowCloseButton( true )
	Panal:MakePopup()
	local HeatLabel = vgui.Create("DLabel", Panal)
	HeatLabel:SetPos(10,30) // Position
	HeatLabel:SetColor(Color(255,255,255,255))
	HeatLabel:SetFont("ChatFont")
	HeatLabel:SetText("Max Heat:")
	HeatLabel:SizeToContents()
	local HeatPoint = vgui.Create( "DTextEntry", Panal )
	HeatPoint:SetPos( 10,50 )
	HeatPoint:SetTall( 20 )
	HeatPoint:SetWide( 180 )
	HeatPoint:SetValue( Heat )
	HeatPoint:SetEnterAllowed( true )
	HeatPoint.OnEnter = function()
		net.Start("DataSendFS")
			net.WriteFloat(HeatPoint:GetValue())
			net.WriteEntity(self)
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
		Panal:SetVisible( true )
	end
	local DermaButton = vgui.Create( "DButton" )
	DermaButton:SetParent( Panal )
	DermaButton:SetText( "Set" )
	DermaButton:SetPos( 25, 80 )
	DermaButton:SetSize( 150, 20 )
	DermaButton.DoClick = function ()
		net.Start("DataSendFS")
			net.WriteFloat(HeatPoint:GetValue())
			net.WriteEntity(self)
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
		Panal:SetVisible( true )
	end
end

net.Receive("DermaFS", function()
	net.ReadEntity():Derma(net.ReadFloat())
end)

--Copyright © Edward Peter Lemon AKA "TheGreatNacho", 2013