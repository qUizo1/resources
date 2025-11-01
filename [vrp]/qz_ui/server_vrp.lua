local UI = class("UI", vRP.Extension)

function UI:__construct()
    vRP.Extension.__construct(self)
end

RegisterServerEvent("hud:getData")
AddEventHandler("hud:getData", function()
    local player = source
    local user = vRP.users_by_source[source]
    if user then
        local ped = GetPlayerPed(player)
        local health = (ped and GetEntityHealth(ped) or 200) - 100
        local armor = ped and GetPedArmour(ped) or 0

        local hunger = (user:getVital("food") or 0) * 100
        local thirst = (user:getVital("water") or 0) * 100

        TriggerClientEvent("hud:update", player, {
            health = math.max(0, health),
            armor = armor,
            hunger = hunger,
            thirst = thirst
        })
    end
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent("hud:getData", source)
    end
end)

vRP:registerExtension(UI)    