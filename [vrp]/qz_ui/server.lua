local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

local vRP = Proxy.getInterface("vRP")

async(function()
  vRP.loadScript("qz_ui", "server_vrp")
end)
