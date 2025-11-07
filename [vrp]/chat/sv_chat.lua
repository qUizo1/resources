local QZChat = class("QZChat", vRP.Extension)

function QZChat:__construct()
    vRP.Extension.__construct(self)
end
RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

local lastMessage = {}
AddEventHandler('_chat:messageEntered', function(author, message)
    if not message or not author then
        return
    end
    if not WasEventCanceled() then
        local user = vRP.users_by_source[source]

        local colorData = {
            color = "ffde5c",
            prefix = "Jucator",
        }

        -- Always check permissions fresh for each message
        if user then
            if user:hasPermission("owner.title") then
                colorData.color = "b86500"
                colorData.prefix = "Fondator"
            elseif user:hasPermission("admin.title") then
                colorData.color = "ff0000"
                colorData.prefix = "Administrator"
            else
                colorData.color = "ffde5c"
                colorData.prefix = "Jucator"
            end
        end

        -- Send the message to all clients
        TriggerClientEvent('chatMessage', -1, author, message, colorData.prefix, colorData.color)
    end
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
		local user = vRP.users_by_source[source]
		local author = "(ID: "..user..") "..name
		message = "/"..command
    end

    CancelEvent()
end)

RegisterCommand("nc", function(player)
	local user = vRP.users_by_source[source]
	if User:hasPermission("player.noclip") then
		self.remote._SetNoclipActive(user)
	else
		TriggerClientEvent("chatMessage", source, "^5Eroare^0: Nu ai acces la aceasta comanda.")
	end
end)


RegisterCommand('say', function(source, args, rawCommand)
	if not (source == 0) then return vRPclient["noAccess"](source,{}) end;
	TriggerClientEvent('chatMessage', -1, "[^3Consola^0] "..rawCommand:sub(5))
end)
