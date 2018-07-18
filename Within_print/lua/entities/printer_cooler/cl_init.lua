
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
		draw.DrawText(self.PrintName, "HUDNumber5", 0, 0, Color(255,255,255,255), 1)
	cam.End3D2D()
end


--Copyright © Edward Peter Lemon AKA "TheGreatNacho", 2013