local QZUI = class("QZUI", vRP.Extension)

function QZUI:__construct()
    vRP.Extension.__construct(self)

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

    local initialized = {}

    RegisterServerEvent("hud:retrieveData")
    AddEventHandler("hud:retrieveData", function()
         local player = source
         local user = vRP.users_by_source[source]

         if user then
             if not initialized[user] then
                 SetTimeout(500, function ()
                     TriggerClientEvent("hud:sendMessage", player, {
                         target = "hud",
                         action = "load",
                         code = "Hud.loaded = true;"
                     })
                 end)

                 initialized[user] = true
             end

             TriggerClientEvent("hud:sendMessage", player, {
                 target = "money-hud",
                 action = "load",
                 code = "Hud.player = { wallet: '"..QZUI:formatMoney(user:getWallet()).."'};"

             })
         end
     end)
end

function QZUI:formatMoney(amount)
  local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

AddEventHandler("vRP:playerSpawn", function(user, source, first_spawn)
    if first_spawn then
        TriggerClientEvent("hud:getData", source)
    end
end)

vRP:registerExtension(QZUI)    