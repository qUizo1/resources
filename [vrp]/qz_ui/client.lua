-- init vRP client context
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
-- load script in vRP context
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)

local cfg = module("qz_ui", "cfg/cfg")            -- Optional, Change vrp_Test to match folder name

local UI = class("UI", vRP.Extension)            -- Class Name, Can be changed to anything (match with server class name to make things easier

function UI:__construct()                            -- Change test to match Class Name
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

vRP:registerExtension(UI)       