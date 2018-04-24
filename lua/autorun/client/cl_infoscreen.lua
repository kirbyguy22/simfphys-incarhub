local matScreen = Material( "PUT SCREEN MATERIAL HERE" )
local RTTexture = GetRenderTarget( "SteeringInfo", 256, 128 )

print("Local infoscreen script loaded")
--Different fonts for display
surface.CreateFont( "SteeringInfo", {
	font = "Arial",
	size = 60,
	weight = 900
} )

surface.CreateFont( "SteeringAuxInfo", {
	font = "Arial",
	size = 24,
	weight = 500
} )


local function DrawGearSelection( ent, y )
	local gear = ent:GetGear()
	local drawGear = "N"
	local rpm = math.Round(ent:GetRPM(), 0)
	local fuel = math.Round(ent:GetFuel(), 1)
	local w, h = surface.GetTextSize( gear )
	if (gear == 1) then
	drawGear = "R"
	elseif (gear == 2) then
	drawGear = "N"
	else
	drawGear = gear - 2
	end
	w = w + 64
	y = y - h / 2
		--Draw Gear
		surface.SetFont( "SteeringInfo" )
		surface.SetTextColor( 255, 255, 255, 255)
		surface.SetTextPos(110, y-48)
		surface.DrawText( drawGear )
		--Draw RPM
		surface.SetFont( "SteeringAuxInfo")
		surface.SetTextColor( 255, 255, 255, 255)
		surface.SetTextPos(120, y)
		surface.DrawText( rpm )
		--Draw Fuel Level
		surface.SetTextColor( 255, 255, 255, 255)
		surface.SetTextPos(72, y)
		surface.DrawText( fuel )
end

local function RenderInfoPod( ent )
	local TEX_SIZE = 256
	local TEX_SIZEH = 128
	local oldW = ScrW()
	local oldH = ScrH()
	matScreen:SetTexture( "$baseTexture", RTTexture )

	local oldRT = render.GetRenderTarget()
	
	render.SetRenderTarget( RTTexture )
	render.SetViewPort(0, 0, TEX_SIZE, TEX_SIZEH)
	cam.Start2D()
		
		surface.SetDrawColor( 0, 0, 0, 255)
		surface.DrawRect(0, 0, TEX_SIZE, TEX_SIZEH)
		surface.SetFont( "SteeringInfo" )
		DrawGearSelection( ent, 104 )
		
	cam.End2D()
	render.SetRenderTarget( oldRT )
	render.SetViewPort(0, 0, oldW, oldH)
	
end
--Code stolen from simfphys
local function DrawInfoHudF1()
	local ply = LocalPlayer()
	
	if !ply or !ply:Alive() then return end

	local vehicle = ply:GetVehicle()
	if (!IsValid(vehicle)) then return end
	
	local vehiclebase = vehicle.vehiclebase
	
	if (!IsValid(vehiclebase)) then return end
	
	local IsDriverSeat = vehicle == vehiclebase:GetDriverSeat()
	if (!IsDriverSeat) then return end
	
	RenderInfoPod(vehiclebase)
end
hook.Add( "HUDPaint", "kirby_incar_HUD", DrawInfoHudF1)