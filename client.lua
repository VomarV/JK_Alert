blips = {}

Alert = {}
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP","vRP")
ASserver = Tunnel.getInterface("JK_Alert","JK_Alert")
Tunnel.bindInterface("JK_Alert",Alert)

Citizen.CreateThread(function()
	while true do
		ped = PlayerPedId()
		pos = GetEntityCoords(ped)
		Citizen.Wait(500)
	end
end)
Whitelist = false
RegisterNetEvent("JK_Alert:Client:SetWhiteList" , function(newwhitelist)
	Whitelist = newwhitelist
end)

inzoen = true
Citizen.CreateThread(function()
	while true do
		Sleep = 500
		for k , v in pairs(blips) do
			if #(pos - vector3(v.coords[1] , v.coords[2] , v.coords[3])) <= 100.0 then
				Sleep = 0
				drawTxt("ﻲﻨﻣﺍ ﺭﺎﻔﻨﺘﺳﺍ" , 4, 1, 0.5, 0.85, 0.5, 0, 255, 0, 255)
				if Whitelist == false then
					if IsPedInAnyVehicle(ped , false) then
						SetVehicleMaxSpeed(GetVehiclePedIsUsing(ped), Config.SpeedCar/3.6)
					end
					SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
				end
			end
			if Sleep == 0 and inzoen then
				inzoen = false
				if Whitelist == false then
					StartScreenEffect('DeathFailMPDark', 0, true)
				end
			end
			if Sleep == 500 and not inzoen then
				SetVehicleMaxSpeed(GetVehiclePedIsUsing(ped), 1000.00)
				inzoen = true
				if Whitelist == false then
					SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
					StopScreenEffect('DeathFailMPDark')
				end
			end
		end
		Citizen.Wait(Sleep)
	end
end)

RegisterNetEvent("JK_Alert:Client:Start" , function(x , y , z)
	blip = AddBlipForRadius(vector3(x , y , z), 100.0)
	SetBlipColour(blip, 1)
	SetBlipAlpha(blip, 128)
	table.insert(blips, {type = blip , coords = {x , y , z}})
end)

RegisterNetEvent("JK_Alert:Client:Stop" , function(x , y , z)
	for k , v in pairs(blips) do
		if #(vector3(x , y , z) - vector3(v.coords[1] , v.coords[2] , v.coords[3])) <= 100.0 then
			RemoveBlip(v.type)
			blips[k] = nil
			StopScreenEffect('DeathFailMPDark')
			SetVehicleMaxSpeed(GetVehiclePedIsUsing(ped), 1000.00)
		end
	end
end)

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString("<FONT FACE='Arb'>"..text)
    DrawText(x, y)
end
