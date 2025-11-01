-- init vRP client context
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
-- load script in vRP context
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)        

local UI = class("UI", vRP.Extension)            

function UI:__construct()                         
    vRP.Extension.__construct(self)
end

function ShowTextUI(text)
    SendNUIMessage({
        action = 'ShowTextUI',
        message = text
    })
end

function HideTextUI()
    SendNUIMessage({
        action = 'HideTextUI'
    })
end

AddEventHandler("hud:notify")
RegisterNetEvent("hud:notify", function(title, text, duration)
        SendNUIMessage({
            action = "open",
            title = title,
            info = text,
            duration = duration
        })

end)

local currentStreet, currentZone = "", ""
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        local newStreet = GetStreetNameFromHashKey(streetHash)
        local newCrossing = GetStreetNameFromHashKey(crossingHash)
        
        if newCrossing ~= "" and newCrossing ~= newStreet then
            newStreet = newStreet .. " / " .. newCrossing
        end

       local zoneHash = GetNameOfZone(coords.x, coords.y, coords.z)
        
        local newZone = "Unknown Area"
        if zoneHash then
            newZone = GetLabelText(zoneHash)
            if newZone == "NULL" then newZone = "Unknown Area" end
        end

        if newStreet ~= currentStreet or newZone ~= currentZone then
            currentStreet, currentZone = newStreet, newZone
            SendNUIMessage({
                type = 'update_location',
                area = currentZone,
                street = currentStreet
            })
        end
    end
end)
function GetCurrentLocation()
    return currentZone, currentStreet
end

function GetStamina()
    return 100 - (GetPlayerSprintStaminaRemaining(PlayerId()) or 0)
end

RegisterNetEvent("hud:update")
AddEventHandler("hud:update", function(data)
    data.stamina = GetStamina()

    SendNUIMessage({
        type = "hud_update",
        health = data.health or 0,
        armor = data.armor or 0,
        hunger = data.hunger or 0,
        thirst = data.thirst or 0,
        stamina = data.stamina
    })
end)

RegisterNetEvent("hud:getData")
AddEventHandler("hud:getData", function()
    TriggerServerEvent("hud:getData")
end)

Citizen.CreateThread(function()
    while true do
        TriggerServerEvent("hud:getData")
        Citizen.Wait(1000)
    end
end)

AddEventHandler("playerSpawned", function()
    Citizen.Wait(5000)
    TriggerServerEvent("hud:getData")
end)

AddEventHandler("hud:admin")
RegisterNetEvent("hud:admin", function(title, text, duration)
    SendNUIMessage({
        type = "admin_announcement",
        title = title,
        message = text,
        duration = duration or 10000
    })
end)
----------------------------------COMMANDS FOR TESTING PURPOSES----------------------------------

RegisterCommand("testnoti", function()
    TriggerEvent("hud:notify", "Informatie", "Lorem Ipsum is simply dummy text", 3000)
    Citizen.Wait(1000)
    TriggerEvent("hud:notify", "Notificare", "Mesaj de test", 5000)
    Citizen.Wait(1000)
    TriggerEvent("hud:notify", "Alerta", "A treia notificare", 4000)
end, false)

RegisterCommand("testtui", function()
    ShowTextUI("Accesează meniul")
    Citizen.Wait(5000)
    HideTextUI()
end, false)

RegisterCommand("anunt", function()
    TriggerEvent("hud:admin",
        "ATENTIE JUCATORI",
        "Serverul va fi repornit in 5 minute pentru mentenanta.",10000)
end)


vRP:registerExtension(UI)       

--TriggerEvent("hud:notify", title, msg, time)