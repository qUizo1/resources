-- init vRP server context
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
-- load script in vRP context
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)

local cfg = module("vrp_loading", "cfg/loading")
local Loading = class("Loading", vRP.Extension)

function Loading:__construct()
    vRP.Extension.__construct(self)
end

function Loading:close()
	Citizen.Wait(0)
	DoScreenFadeOut(0)
	
	-- Shut down the game's loading screen (this is NOT the NUI loading screen).
	ShutdownLoadingScreen()
	
	-- Shut down the NUI loading screen.
	ShutdownLoadingScreenNui()
	
	if not cfg.loading then
    DoScreenFadeIn(500)  -- Fade in smoothly
  end

	Citizen.Wait(0)
	TriggerServerEvent("Multi:open")
end

Loading.event = {}
Loading.tunnel = {}

Loading.tunnel.close = Loading.close

vRP:registerExtension(Loading)