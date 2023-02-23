local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

Alert = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","JK_Alert")
ASclient = Tunnel.getInterface("JK_Alert","JK_Alert")
Tunnel.bindInterface("JK_Alert",Alert)

RegisterNetEvent("JK_Alert:Server:Menu" , function()
    local src = source
	local user_id = vRP.getUserId({src})
	local AlertMenu = {name="قائمة استنفار امني", css={top="75px",header_color="rgba(255,125,0,0.75)"}}
	AlertMenu.onclose = function() print("Close Menu") end
    AlertMenu['! انشاء استنفار امني !'] = {function()
        vRPclient.getPosition(src , {} , function(x , y , z)
            TriggerClientEvent("JK_Alert:Client:Start" , -1 , x , y , z )
        end)
        vRP.closeMenu({src})
    end , 'من هذا الخيار تستطيع انشاء استنفار امني بالمكان الذي انت به'}
    AlertMenu['الغاء الاستنفار الامني'] = {function()
        vRPclient.getPosition(src , {} , function(x , y , z)
            TriggerClientEvent("JK_Alert:Client:Stop" , -1 , x , y , z )
        end)
        vRP.closeMenu({src})
    end , 'من هذا الخيار تستطيع الغاء الاستنفار الامني الذي انت بداخله'}
    vRP.openMenu({src,AlertMenu})
end)



AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
    if first_spawn then 
        local player = vRP.getUserSource({user_id})
        if vRP.hasPermission({user_id, Config.Permission}) then 
            TriggerClientEvent("JK_Alert:Client:SetWhiteList" , player , true)
        else
            TriggerClientEvent("JK_Alert:Client:SetWhiteList" , player , false)
        end
    end
end)

AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
    local player = vRP.getUserSource({user_id})
    if vRP.hasPermission({user_id, Config.Permission}) then 
        TriggerClientEvent("JK_Alert:Client:SetWhiteList" , player , true)
    else
        TriggerClientEvent("JK_Alert:Client:SetWhiteList" , player , false)
    end
end)

AddEventHandler("vRP:playerLeaveGroup", function(user_id, group, gtype)
    local player = vRP.getUserSource({user_id})
    if vRP.hasPermission({user_id, Config.Permission}) then 
        TriggerClientEvent("JK_Alert:Client:SetWhiteList" , player , true)
    else
        TriggerClientEvent("JK_Alert:Client:SetWhiteList" , player , false)
    end
end)

local function ch_menu(player,choice)
    vRP.buildMenu({"police_alert", {player = player}, function(menu)
        menu.name = Config.Menu.MenuName
        menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
        menu.onclose = function(player) vRP.closeMenu({player}) end
        local user_id = vRP.getUserId({player})
        menu['! انشاء استنفار امني !'] = {function()
            vRPclient.getPosition(player , {} , function(x , y , z)
                TriggerClientEvent("JK_Alert:Client:Start" , -1 , x , y , z )
            end)
            vRP.closeMenu({player})
        end , 'من هذا الخيار تستطيع انشاء استنفار امني بالمكان الذي انت به'}
        menu['الغاء الاستنفار الامني'] = {function()
            vRPclient.getPosition(player , {} , function(x , y , z)
                TriggerClientEvent("JK_Alert:Client:Stop" , -1 , x , y , z )
            end)
            vRP.closeMenu({player})
        end , 'من هذا الخيار تستطيع الغاء الاستنفار الامني الذي انت بداخله'}
        vRP.openMenu({player, menu})
    end})
end

vRP.registerMenuBuilder({"admin", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
        if vRP.hasPermission({ user_id , Config.Menu.Permission }) then
            choices[Config.Menu.MenuName] = {ch_menu}
        end
        add(choices)
    end
end})