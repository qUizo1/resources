local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

local vRP = Proxy.getInterface("vRP")

async(function()
  vRP.loadScript("vrp_banking", "server_vrp")
end)
