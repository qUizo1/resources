

if not vRP.modules.admin then return end

local Admin = class("Admin", vRP.Extension)

-- METHODS

function Admin:__construct()
	vRP.Extension.__construct(self)

	self.noclip = false
	self.noclip_speed = 1.0
	self.noclip_speed_fast = 5.0  
	self.permission = false

  -- noclip task
  Citizen.CreateThread(function()
    local Base = vRP.EXT.Base

    while true do
      Citizen.Wait(0)
      if self.noclip then
        local x,y,z = Base:getPosition()
        local dx,dy,dz = Base:getCamDirection()
        local speed = self.noclip_speed
  
        -- change speed
	    if IsControlPressed(1, 21) and IsControlPressed(0,32) then
		  speed = self.noclip_speed_fast
	    else
		  speed = self.noclip_speed
	    end	
		
        -- reset velocity
        SetEntityVelocity(PlayerPedId(), 0.0001, 0.0001, 0.0001)

        -- forward
        if IsControlPressed(0,32) then -- MOVE UP
          x = x+speed*dx
          y = y+speed*dy
          z = z+speed*dz
        end

        -- backward
        if IsControlPressed(0,269) then -- MOVE DOWN
          x = x-speed*dx
          y = y-speed*dy
          z = z-speed*dz
        end
        SetEntityCoordsNoOffset(PlayerPedId(),x,y,z,true,true,true)
      else
	  Citizen.Wait(1000)
	  end
    end
  end)
end

function Admin:toggleNoclip()
  self.noclip = not self.noclip

  if self.noclip then -- set
    SetEntityInvincible(PlayerPedId(), true)
    SetEntityVisible(PlayerPedId(), false, false)
  else -- unset
    SetEntityInvincible(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true, false)
  end
end

-- ref: https://github.com/citizenfx/project-lambdamenu/blob/master/LambdaMenu/teleportation.cpp#L301
function Admin:teleportToMarker()
  local ped = GetPlayerPed(-1)

  -- find GPS blip

  local it = GetBlipInfoIdIterator()
  local blip = GetFirstBlipInfoId(it)
  local ok, done
  repeat
    ok = DoesBlipExist(blip)
    if ok then
      if GetBlipInfoIdType(blip) == 4 then
        ok = false
        done = true
      else
        blip = GetNextBlipInfoId(it)
      end
    end
  until not ok

  if done then
    local x,y = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())) -- GetBlipInfoIdCoord fix

    local gz, ground = 0, false
    for z=0,800,50 do
      SetEntityCoordsNoOffset(ped, x+0.001, y+0.001, z+0.001, 0, 0, 1);
      ground, gz = GetGroundZFor_3dCoord(x,y,z+0.001)
      if ground then break end
    end

    if ground then
      vRP.EXT.Base:teleport(x,y,gz+3)
    else
      vRP.EXT.Base:teleport(x,y,1000)
      GiveDelayedWeaponToPed(ped, 0xFBAB5776, 1, 0)
    end
  end
end



-------------------------------------------------NOCLIP NOU-----------------------------------------------------
local NoclipActive = false
local MovingSpeed = 0
local Scale = -1
local FollowCamMode = true


local speeds = 
{
	"Foarte Incet",
	"Incet",
	"Normal",
	"Rapid",
	"Foarte rapid",
	"Extrem de rapid",
	"Extrem de rapid v2.0",
	"SASUKE"
}

local vehEntity = nil

function Admin:SetNoclipActive()
    NoclipActive = not NoclipActive
	
	if NoclipActive then
		TriggerEvent('hud:notify', 'Notificare' , 'Noclip ON! Asteapta sa porneasca!')
		if IsPedInAnyVehicle(PlayerPedId(), true) then
			vehEntity = GetVehiclePedIsIn(PlayerPedId(), false)
		end
	else
		TriggerEvent('hud:notify', 'Notificare' , 'Noclip OFF!')
		if vehEntity ~= nil then
		Citizen.Wait(15)
		SetPedIntoVehicle(PlayerPedId(), vehEntity, -1)
		end
		Citizen.Wait(2000)
		vehEntity = nil
	end
	
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if NoclipActive then
			Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
			while not HasScaleformMovieLoaded(Scale) do
				Citizen.Wait(0)
			end
		end
		
		while NoclipActive do
			NoClipFunction() 
		end
		
	end
end)

function NoClipFunction()
	while not HasScaleformMovieLoaded(Scale) do
		Citizen.Wait(0)
	end
	BeginScaleformMovieMethod(Scale, "CLEAR_ALL")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(0)
	PushScaleformMovieMethodParameterString("~INPUT_SPRINT~")
	PushScaleformMovieMethodParameterString("Schimba Viteza [" .. tostring(speeds[MovingSpeed + 1]) .. "]")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(1)
	PushScaleformMovieMethodParameterString("~INPUT_MOVE_LR~")
	PushScaleformMovieMethodParameterString("Stanga/Dreapta")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(2)
	PushScaleformMovieMethodParameterString("~INPUT_MOVE_UD~")
	PushScaleformMovieMethodParameterString("Mergi")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(3)
	PushScaleformMovieMethodParameterString("~INPUT_MULTIPLAYER_INFO~")
	PushScaleformMovieMethodParameterString("Jos")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(4)
	PushScaleformMovieMethodParameterString("~INPUT_COVER~")
	PushScaleformMovieMethodParameterString("Sus")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(5)
	PushScaleformMovieMethodParameterString("~INPUT_VEH_HEADLIGHT~")
	PushScaleformMovieMethodParameterString("Mod Control")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(6)
	PushScaleformMovieMethodParameterString("~INPUT_REPLAY_START_STOP_RECORDING_SECONDARY~")
	PushScaleformMovieMethodParameterString("Activeaza/Dezactiveaza")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS")
	ScaleformMovieMethodAddParamInt(0)
	EndScaleformMovieMethod()

	DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0)

	local noclipEntity = GetPlayerPed(-1)

	FreezeEntityPosition(noclipEntity, true)
	SetEntityInvincible(noclipEntity, true)
	
	FreezeEntityPosition(vehEntity, true)
	SetEntityInvincible(vehEntity, true)

	local newPos
	DisableControlAction(0, 32, 1)
	DisableControlAction(0, 268, 1)
	DisableControlAction(0, 269, 1)
	DisableControlAction(0, 33, 1)
	DisableControlAction(0, 266, 1)
	DisableControlAction(0, 63, 1)
	DisableControlAction(0, 267, 1)
	DisableControlAction(0, 35, 1)
	DisableControlAction(0, 44, 1)
	DisableControlAction(0, 20, 1)
	DisableControlAction(0, 74, 1)
	DisableControlAction(0, 85, 1)

	local yoff = 0.0
	local zoff = 0.0

	if IsControlJustPressed(0, 21) then
		MovingSpeed = MovingSpeed + 1
		if MovingSpeed == #speeds then
			MovingSpeed = 0
		end
	end

	if IsDisabledControlPressed(0, 32) then
		yoff = 0.5
	end
	if IsDisabledControlPressed(0, 33) then
		yoff = -0.5
	end
	if not FollowCamMode and IsDisabledControlPressed(0,34) then
		SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 3)
	end
	if not FollowCamMode and IsDisabledControlPressed(0,35) then
		SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 3)
	end
	if IsDisabledControlPressed(0, 44) then
		zoff = 0.21
	end
	if IsDisabledControlPressed(0, 20) then
		zoff = -0.21
	end
	if IsDisabledControlJustPressed(0, 74) then
		FollowCamMode = not FollowCamMode
	end

	moveSpeed = MovingSpeed
	if (MovingSpeed > #speeds / 2) then
		moveSpeed = moveSpeed * 1.8
	end

	moveSpeed = moveSpeed / (1 / GetFrameTime()) * 60;
	newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0, yoff * (moveSpeed + 0.3), zoff * (moveSpeed + 0.3))

	local heading = GetEntityHeading(noclipEntity)
	SetEntityVelocity(noclipEntity, 0, 0, 0)
	SetEntityRotation(noclipEntity, 0, 0, 0, 0, false)
	if FollowCamMode then
		SetEntityHeading(noclipEntity, GetGameplayCamRelativeHeading())
	else
		SetEntityHeading(noclipEntity, heading)
	end
	local sHeading = GetGameplayCamRelativeHeading()
	SetEntityCollision(noclipEntity, false, false)
	SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)
	SetEntityVelocity(vehEntity, 0, 0, 0)
	SetEntityRotation(vehEntity, 0, 0, 0, 0, false)
	if FollowCamMode then
		SetEntityHeading(vehEntity, sHeading)
	else
		SetEntityHeading(vehEntity, heading)
	end
	SetEntityCollision(vehEntity, false, false)
	SetEntityCoordsNoOffset(vehEntity, newPos.x, newPos.y, newPos.z, true, true, true)
	
	
	SetEntityVisible(noclipEntity, false, false)
	SetLocalPlayerVisibleLocally(true)
	SetEntityAlpha(noclipEntity, math.ceil(255 * 0.2), 0)
	SetEntityVisible(vehEntity, false, false)
	SetEntityLocallyVisible(vehEntity)
	SetEntityAlpha(vehEntity, math.ceil(255 * 0.2), 0)
	

	SetEveryoneIgnorePlayer(PlayerPedId(), true)
	SetPoliceIgnorePlayer(PlayerPedId(), true)

	Citizen.Wait(0)
	
	FreezeEntityPosition(noclipEntity, false)
	SetEntityInvincible(noclipEntity, false)
	SetEntityCollision(noclipEntity, true, true)
	FreezeEntityPosition(vehEntity, false)
	SetEntityInvincible(vehEntity, false)
	SetEntityCollision(vehEntity, true, true)

	SetEntityVisible(noclipEntity, true, false)
	SetLocalPlayerVisibleLocally(true)
	ResetEntityAlpha(noclipEntity)
	SetEntityVisible(vehEntity, true, false)
	SetEntityLocallyVisible(vehEntity)
	ResetEntityAlpha(vehEntity)
	
	SetEveryoneIgnorePlayer(PlayerPedId(), false)
	SetPoliceIgnorePlayer(PlayerPedId(), false)

end

---------------------------------------------------GODMODE---------------------------------------------------

local godMode = false

function Admin:toggleGodmode()
	godMode = not godMode
	
	if godMode then
		TriggerEvent('hud:notify', 'Notificare' , 'Godmode ON!')
	end
	
	if not godMode then
		TriggerEvent('hud:notify', 'Notificare' , 'Godmode OFF!')
	end
end

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1)
		if godMode then
			local ped = PlayerPedId()
			SetEntityInvincible(ped, true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(ped, false)
			ClearPedBloodDamage(ped)
			ResetPedVisibleDamage(ped)
			ClearPedLastWeaponDamage(ped)
			SetEntityProofs(ped, true, true, true, true, true, true, true, true)
			SetEntityOnlyDamagedByPlayer(ped, false)
			SetEntityCanBeDamaged(ped, false)
		else
			local ped = PlayerPedId()
			SetEntityInvincible(ped, false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(ped, true)
			ClearPedLastWeaponDamage(ped)
			SetEntityProofs(ped, false, false, false, false, false, false, false, false)
			SetEntityOnlyDamagedByPlayer(ped, false)
			SetEntityCanBeDamaged(ped, true)
			Citizen.Wait(5000)
		end
	end
end)



-- TUNNEL

Admin.tunnel = {}
Admin.tunnel.toggleNoclip = Admin.toggleNoclip
Admin.tunnel.teleportToMarker = Admin.teleportToMarker

Admin.tunnel.SetNoclipActive = Admin.SetNoclipActive
Admin.tunnel.toggleGodmode = Admin.toggleGodmode

vRP:registerExtension(Admin)
