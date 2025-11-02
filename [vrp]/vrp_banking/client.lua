Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)
local cfg = module("vrp_banking", "cfg/cfg")

RegisterNetEvent("banking:sendInfo")
AddEventHandler("banking:sendInfo", function(data)
    SendNUIMessage({
        action = "bankingUI",
        name = data.name,
        balance = data.balance
    })
end)

RegisterNetEvent("banking:sendBalance")
AddEventHandler("banking:sendBalance", function(balance)
end)

local QZBanking = class("QZBanking", vRP.Extension)

function QZBanking:__construct()                         
    vRP.Extension.__construct(self)
end

function ShowHelpNotification(msg)
    AddTextEntry(GetCurrentResourceName(), msg)
    DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
end

local inMenu = false

Citizen.CreateThread(function()
    local ticks = 1000
    local inZone, shown = false, false
    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for i = 1, #cfg.Banks do
            local coordo = cfg.Banks[i].coords
            if #(coordo - pedCoords) <=5 then
                ticks = 0
                if cfg.Setari.Marker then
                    r,g,b,a=table.unpack(cfg.Setari.Culori)
                    DrawMarker(21, coordo, 0,0,0, 0,0,0, 0.6,0.6,0.6, r,g,b,a, 1,0,0,1)
                end
                if #(coordo - pedCoords) <=2 then
                    inZone = true
                    if IsControlJustPressed(0,38) then
                        OpenMenu()
                    end
                end
            end
        end
        if cfg.Setari.TextUI then
            if inZone and not shown and not inMenu then
                exports.qz_ui:ShowTextUI("Open the banking menu")
                shown = true
            elseif not inZone and shown or inMenu then
                exports.qz_ui:HideTextUI()
                shown = false
            end
        else
            ShowHelpNotification("Press ~INPUT_CONTEXT~ to open the banking menu.")
        end
        Wait(ticks)
        ticks = 1000
        inZone= false
    end
end)

if cfg.Setari.Blip then
    Citizen.CreateThread(function()
        for i = 1, #cfg.Banks do
            local blipd = cfg.Banks[i]
            blip = AddBlipForCoord(blipd.coords)
            SetBlipSprite(blip, blipd.blipid)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, blipd.blipscale)
            SetBlipColour(blip, blipd.blipcolor)
            SetBlipAsShortRange(blip, true)
    		BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipd.bliptext)
            EndTextCommandSetBlipName(blip)
        end
    end)
end

function OpenMenu()
    inMenu = true
    SetNuiFocus(true, true)
    TriggerServerEvent("banking:getInfo")
end

function CloseMenu()
    inMenu = false
    SetNuiFocus(false,false)
end

RegisterNUICallback("close", function()
    CloseMenu()
end)

local pendingBalanceCallback = nil

RegisterNUICallback("getBalance", function(_,cb)
    pendingBalanceCallback = cb
    TriggerServerEvent("banking:getBalance")
end)

RegisterNetEvent("banking:sendBalance")
AddEventHandler("banking:sendBalance", function(balance)
    if pendingBalanceCallback then
        pendingBalanceCallback(balance)
        pendingBalanceCallback = nil
    end
end)

RegisterNUICallback("bank", function(data)
    TriggerServerEvent("banking:action", data)
end)

vRP:registerExtension(QZBanking)