RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:clear')
RegisterNetEvent('__cfx_internal:serverPrint')
RegisterNetEvent("chat:addTemplate")
RegisterNetEvent("chat:addMessage")
RegisterNetEvent("chat:addSuggestion")
RegisterNetEvent("chat:removeSuggestion")
RegisterNetEvent("_chat:muitzaqmessageEntered")

local showServerPrints, chatActive = false, true
Citizen.CreateThread(function()
    SetTextChatEnabled(false)

    AddEventHandler('chatMessage', function(msg, type)
        if chatActive then
            SendNUIMessage({act = "onMessage", type = type, msg = msg})
        end
    end)

    RegisterCommand("clearchat", function()
        TriggerEvent("chat:clear")
    end)

    RegisterCommand("logserver", function()
        showServerPrints = not showServerPrints
        print("Server prints [LOGGER]: "..(showServerPrints and "ON" or "OFF"))
    end)

    RegisterCommand("togchat", function()
        chatActive = not chatActive

        if not chatActive then
            TriggerEvent("chat:clear")
        end
    end)

    AddEventHandler("chat:clear", function()
        SendNUIMessage({act = "clear"})
    end)

    RegisterNetEvent("printInClient", function(text)
        print(text)
    end)

    AddEventHandler('__cfx_internal:serverPrint', function(msg)
        if showServerPrints then
            print(msg)
        
            SendNUIMessage({act = "onMessage", type = "msg", msg = msg})
        end
    end)
end)

RegisterCommand("openchat", function()
    SetNuiFocus(true, true)

    SendNUIMessage({act = "build"})
end)

RegisterKeyMapping("openchat", "Chat with other players", "keyboard", "t")

RegisterNUICallback('chatResult', function(data, cb)
    local id = PlayerId()
    local theMessage = data[1]
    
    if theMessage:sub(1, 1) == '/' then
      ExecuteCommand(theMessage:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), theMessage)
    end
  
    cb('ok')
end)

RegisterNUICallback("setFocus", function(data, cb)
    SetNuiFocus(data[1], data[1])
    cb("ok")
end)