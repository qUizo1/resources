
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)        

local QZUI = class("QZUI", vRP.Extension)

function QZUI:__construct()                         
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

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local isInVehicle = DoesEntityExist(vehicle) and IsPedInVehicle(playerPed, vehicle, false)
        
        if isInVehicle then
            local speed = GetEntitySpeed(vehicle) * 3.6
            local fuel = GetVehicleFuelLevel(vehicle)
            
            SendNUIMessage({
                type = 'update_speed',
                speed = speed,
                inVehicle = true,
                fuel = fuel
            })
        else
            SendNUIMessage({
                type = 'update_speed',
                speed = 0,
                inVehicle = false
            })
        end
        
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    local wasInVehicle = false
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local isInVehicle = DoesEntityExist(vehicle) and IsPedInVehicle(playerPed, vehicle, false)
        
        if isInVehicle ~= wasInVehicle then
            wasInVehicle = isInVehicle
            local fuel = GetVehicleFuelLevel(vehicle)
            SendNUIMessage({
                type = 'update_speed',
                speed = 0,
                inVehicle = isInVehicle,
                fuel = fuel
            })
            
            SendNUIMessage({
                type = 'update_vehicle_state',
                inVehicle = isInVehicle
            })
        end
        
        if isInVehicle then
            local speed = GetEntitySpeed(vehicle) * 3.6
            SendNUIMessage({
                type = 'update_speed',
                speed = speed,
                inVehicle = true
            })
        end
        
        Citizen.Wait(100)
    end
end)

local isProgressActive = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isProgressActive then
            if IsControlJustPressed(0, 73) then
                isProgressActive = false
                EnableControlAction(0, 30, true) -- Enable movement
                EnableControlAction(0, 31, true) -- Enable movement
                EnableControlAction(0, 24, true) -- Enable attack
                EnableControlAction(0, 257, true) -- Enable attack 2
                EnableControlAction(0, 25, true) -- Enable aim
                EnableControlAction(0, 263, true) -- Enable melee
                EnableControlAction(0, 264, true) -- Enable melee
                EnableControlAction(0, 257, true) -- Enable melee
                EnableControlAction(0, 140, true) -- Enable melee
                EnableControlAction(0, 141, true) -- Enable melee
                EnableControlAction(0, 142, true) -- Enable melee
                EnableControlAction(0, 143, true) -- Enable melee
                EnableControlAction(0, 23, true) -- Enter vehicle
                SendNUIMessage({
                    action = "hideProgress"
                })
            end
        end
    end
end)

function DisableControlActions()
    Citizen.CreateThread(function()
        while isProgressActive do
                DisableControlAction(0, 30, true) -- Disable movement
                DisableControlAction(0, 31, true) -- Disable movement
                DisableControlAction(0, 24, true) -- Disable attack
                DisableControlAction(0, 257, true) -- Disable attack 2
                DisableControlAction(0, 25, true) -- Disable aim
                DisableControlAction(0, 263, true) -- Disable melee
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                DisableControlAction(0, 143, true) -- Disable melee
                DisableControlAction(0, 23, true) -- Enter vehicle
                Citizen.Wait(0)
        end
    end)
end

RegisterNetEvent("progressBar:start")
AddEventHandler("progressBar:start", function(title, duration)
    local playerPed = PlayerPedId()
    isProgressActive = true
    DisableControlActions()
    SendNUIMessage({
        action = "showProgress",
        title = title,
        duration = duration
    })
    Citizen.SetTimeout(duration, function()
        isProgressActive = false
    end)
    return duration
end)

----------------------------------COMMANDS FOR TESTING PURPOSES----------------------------------

RegisterCommand("testnoti", function()
    TriggerEvent("hud:notify", "Informatie", "Lorem Ipsum", 3000)
    Citizen.Wait(1000)
    TriggerEvent("hud:notify", "Notificare", "Mesaj de test", 5000)
    Citizen.Wait(1000)
    TriggerEvent("hud:notify", "Alerta", "A treia notificare", 4000)
end, false)

RegisterCommand("testtui", function()
    ShowTextUI("Acceseaza meniul")
    Citizen.Wait(5000)
    HideTextUI()
end, false)

RegisterCommand("anunt", function()
    TriggerEvent("hud:admin",
        "ATENTIE JUCATORI",
        "Serverul va fi repornit in 5 minute pentru mentenanta.",10000)
end)

RegisterCommand('setfuel', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if DoesEntityExist(vehicle) then
        local fuelLevel = tonumber(args[1])
        
        if fuelLevel and fuelLevel >= 0 and fuelLevel <= 100 then
            SetVehicleFuelLevel(vehicle, fuelLevel + 0.0)
            
            local currentSpeed = GetEntitySpeed(vehicle) * 3.6
            SendNUIMessage({
                type = 'update_speed',
                speed = currentSpeed,
                inVehicle = true,
                fuel = fuelLevel
            })
            TriggerEvent("hud:notify", "Notificare", "Ai setat combustibilul la " .. fuelLevel .. "%", 5000)
        else
            TriggerEvent("hud:notify", "Notificare", "Folosire corecta: /setfuel [0-100]", 5000)
        end
    else
        TriggerEvent("hud:notify", "Notificare", "Trebuie sa fii într-un vehicul!", 5000)
    end
end, false)

RegisterCommand("testprogress", function(source, args, raw)
    TriggerEvent("progressBar:start", "Test Progress Bar", 5000)
end, false)


vRP:registerExtension(QZUI)       

--TriggerEvent("hud:notify", title, msg, time)
--TriggerEvent("hud:admin", -1, title, msg, duration)
--TriggerEvent("progressBar:start", msg, time)