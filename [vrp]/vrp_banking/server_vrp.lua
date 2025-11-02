local QZBanking = class("QZBanking", vRP.Extension)

function QZBanking:__construct()
    vRP.Extension.__construct(self)
end

function QZBanking:formatMoney(amount)
  local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

RegisterServerEvent("banking:getInfo", function()
    local user = vRP.users_by_source[source]
    if not user then return end
    local balance = QZBanking:formatMoney(user:getBank())
    TriggerClientEvent("banking:sendInfo", source, {
        name = GetPlayerName(source),
        balance = balance
    })
end)

RegisterServerEvent("banking:getBalance", function()
    local user = vRP.users_by_source[source]
    if not user then return end
    local balance = QZBanking:formatMoney(user:getBank())
    TriggerClientEvent("banking:sendBalance", source, balance)
end)

RegisterServerEvent("banking:action", function(data)
    local user = vRP.users_by_source[source]
    if not user or not type(data) == "table" then return end
    if data.type == "deposit" then
        if not data.amount then return end
        local suma = tonumber(data.amount)
        if user:tryPayment(suma) then
            user:giveBank(suma)
            vRP.EXT.Base.remote._notify(source, {"You have deposited $"..QZBanking:formatMoney(suma)})
        else
            vRP.EXT.Base.remote._notify(source, {"You don't have enough cash!"})
        end
    elseif data.type == "withdraw" then
        if not data.amount then return end
        local suma = tonumber(data.amount)
        if user:tryWithdraw(suma) then
            vRP.EXT.Base.remote._notify(source, {"You have withdrawn $"..QZBanking:formatMoney(suma)})
        else
            vRP.EXT.Base.remote._notify(source, {"You don't have enough money in your bank!"})
        end
    elseif data.type == "transfer" then
        if not data.id then return end
        local target_id = tonumber(data.id)
        local target_src = vRP.users_by_source[target_id]
        if not target_src then
            vRP.EXT.Base.remote._notify(source, {"The player is not online!"})
            return
        end
        if target_id == user.id then
            vRP.EXT.Base.remote._notify(source, {"You cannot transfer money to yourself!"})
            return
        end
        if not data.amount then return end
        local suma = tonumber(data.amount)
        local banca = user:getBank()
        if banca >= suma then
            user:setBank(banca - suma)
            target_src:giveBank(suma)
            vRP.EXT.Base.remote._notify(source, {"You have transferred $"..QZBanking:formatMoney(suma).." to "..GetPlayerName(target_src)})
            vRP.EXT.Base.remote._notify(target_src, {"You have received $"..QZBanking:formatMoney(suma).." from "..GetPlayerName(source)})
        else
            vRP.EXT.Base.remote._notify(source, {"You don't have enough money in your bank!"})
        end
    end
end)

vRP:registerExtension(QZBanking)