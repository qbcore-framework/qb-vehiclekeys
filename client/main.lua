-----------------------
----   Variables   ----
-----------------------
local QBCore = exports['qb-core']:GetCoreObject()
local KeysList = {}
local AlertSend = false
local trunkclose = true
local IsRobbing = false
local lockpicked = false
local lockpickedPlate = nil
local usingAdvanced
-----------------------
----   Thread   ----
-----------------------

CreateThread(function()
    while true do
        local sleep = 100
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local entering = GetVehiclePedIsTryingToEnter(ped)
            local driver = GetPedInVehicleSeat(entering, -1)
            local plate = QBCore.Functions.GetPlate(entering)
            
            if entering ~= 0 then
                sleep = 2000
                QBCore.Functions.TriggerCallback('qb-vehiclekeys:server:checkPlayerOwned', function(have)
                    if have then -- if not player owned
                        if driver ~= 0 and not IsPedAPlayer(driver) then
                            if Config.Rob then
                                if IsEntityDead(driver) then
                                    TriggerEvent("vehiclekeys:client:SetOwner", plate)
                                    SetVehicleDoorsLocked(entering, 1)
                                else
                                    SetVehicleDoorsLocked(entering, 2)
                                end
                            else
                                TriggerEvent("vehiclekeys:client:SetOwner", plate)
                                SetVehicleDoorsLocked(entering, 1)
                               
                            end
                        else
                            if not lockpicked and lockpickedPlate ~= plate then
                                QBCore.Functions.TriggerCallback('qb-vehiclekeys:server:GetVehicleKeys', function(have)
                                    if have == nil then
                                        SetVehicleDoorsLocked(entering, 2) 
                                    end
                                end, plate)
                            end
                        end
                    end
                end, plate)
            end
            if Config.Rob then
                if not IsRobbing then
                    local playerid = PlayerId()
                    local aiming, target = GetEntityPlayerIsFreeAimingAt(playerid)
                    if aiming and (target ~= nil and target ~= 0) then
                        if DoesEntityExist(target) and not IsEntityDead(target) and not IsPedAPlayer(target) then
                            if IsPedInAnyVehicle(target, false) then
                                local targetveh = GetVehiclePedIsIn(target)
                                if GetPedInVehicleSeat(targetveh, -1) == target then
                                    if not IsBlacklistedWeapon() then
                                        local pos = GetEntityCoords(ped, true)
                                        local targetpos = GetEntityCoords(target, true)
                                        if #(pos - targetpos) < 5.0 then
                                            RobVehicle(target)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
function RobVehicle(target)
    IsRobbing = true
    loadAnimDict('mp_am_hold_up')
    TaskPlayAnim(target, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
    QBCore.Functions.Progressbar("rob_keys", "Attempting Robbery..", 6000, false, true, {}, {}, {}, {}, function()
        local chance = math.random()
        if chance <= Config.RobberyChance then
            veh = GetVehiclePedIsUsing(target)
            TaskEveryoneLeaveVehicle(veh)
            Wait(500)
            ClearPedTasksImmediately(target)
            TaskReactAndFleePed(target, PlayerPedId())
            local plate = QBCore.Functions.GetPlate(GetVehiclePedIsIn(target, true))
            TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
            TriggerEvent('vehiclekeys:client:SetOwner', plate)
            QBCore.Functions.Notify('You Got The Keys!', 'success')
            Wait(10000)
            IsRobbing = false
        else
            AttemptPoliceAlert("carjack")
            ClearPedTasks(target)
            TaskReactAndFleePed(target, PlayerPedId())
            TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
            QBCore.Functions.Notify('They Called The Cops!', 'error')
            Wait(10000)
            IsRobbing = false
        end
    end)
end

function isBlacklistedVehicle(vehicle)
    local isBlacklisted = false
    for _,v in ipairs(Config.NoLockVehicles) do
        if GetHashKey(v) == GetEntityModel(vehicle) then
            isBlacklisted = true
            break;
        end
    end
    if Entity(vehicle).state.ignoreLocks or GetVehicleClass(vehicle) == 13 then isBlacklisted = true end
    return isBlacklisted
end

function addNoLockVehicles(model)
    Config.NoLockVehicles[#Config.NoLockVehicles+1] = model
end
exports('addNoLockVehicles', addNoLockVehicles)

function removeNoLockVehicles(model)
    for k,v in pairs(Config.NoLockVehicles) do
        if v == model then
            Config.NoLockVehicles[k] = nil
        end
    end
end
exports('removeNoLockVehicles', removeNoLockVehicles)



function addNoLockVehicles(model)
    Config.NoLockVehicles[#Config.NoLockVehicles+1] = model
end
exports('addNoLockVehicles', addNoLockVehicles)

function removeNoLockVehicles(model)
    for k,v in pairs(Config.NoLockVehicles) do
        if v == model then
            Config.NoLockVehicles[k] = nil
        end
    end
end
exports('removeNoLockVehicles', removeNoLockVehicles)

-----------------------
---- Client Events ----
-----------------------
RegisterKeyMapping('togglelocks', Lang:t("info.tlock"), 'keyboard', 'L')
RegisterCommand('togglelocks', function()
    local ped = PlayerPedId()
  if IsPedInAnyVehicle(ped, false) then
    ToggleVehicleLockswithoutnui(GetVehicle())
  else
    if Config.UseKeyfob then
        openmenu()
    else
	ToggleVehicleLockswithoutnui(GetVehicle())
    end
  end
end)
RegisterKeyMapping('engine', Lang:t("info.engine"), 'keyboard', 'G')
RegisterCommand('engine', function()
    local vehicle = GetVehicle()
    if vehicle and IsPedInVehicle(PlayerPedId(), vehicle) then
        ToggleEngine(vehicle)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() and QBCore.Functions.GetPlayerData() ~= {} then
        GetKeys()
    end
end)
-- Handles state right when the player selects their character and location.
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    GetKeys()
end)
-- Resets state on logout, in case of character change.
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    KeysList = {}
end)
RegisterNetEvent('qb-vehiclekeys:client:AddKeys', function(plate)
    KeysList[plate] = true
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped)
        local vehicleplate = QBCore.Functions.GetPlate(vehicle)
        if plate == vehicleplate then
            SetVehicleEngineOn(vehicle, false, false, false)
        end
    end
end)
RegisterNetEvent('qb-vehiclekeys:client:RemoveKeys', function(plate)
    KeysList[plate] = nil
end)
RegisterNetEvent('qb-vehiclekeys:client:ToggleEngine', function()
    local EngineOn = GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId()))
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if HasKeys(QBCore.Functions.GetPlate(vehicle)) then
        if EngineOn then
            SetVehicleEngineOn(vehicle, false, false, true)
        else
            SetVehicleEngineOn(vehicle, true, false, true)
        end
    end
end)
RegisterNetEvent('qb-vehiclekeys:client:GiveKeys', function(id)
    local targetVehicle = GetVehicle()
    if targetVehicle then
        local targetPlate = QBCore.Functions.GetPlate(targetVehicle)
        if HasKeys(targetPlate) then
            if id and type(id) == "number" then -- Give keys to specific ID
                GiveKeys(id, targetPlate)
            else
                if IsPedSittingInVehicle(PlayerPedId(), targetVehicle) then -- Give keys to everyone in vehicle
                    local otherOccupants = GetOtherPlayersInVehicle(targetVehicle)
                    for p=1,#otherOccupants do
                        TriggerServerEvent('qb-vehiclekeys:server:GiveVehicleKeys', GetPlayerServerId(NetworkGetPlayerIndexFromPed(otherOccupants[p])), targetPlate)
                    end
                else -- Give keys to closest player
                    GiveKeys(GetPlayerServerId(QBCore.Functions.GetClosestPlayer()), targetPlate)
                end
            end
        else
            QBCore.Functions.Notify(Lang:t("notify.ydhk"), 'error')
        end
    end
end)
RegisterNetEvent('lockpicks:UseLockpick', function(isAdvanced)
    LockpickDoor(isAdvanced)
end)
-- Backwards Compatibility ONLY -- Remove at some point --
RegisterNetEvent('vehiclekeys:client:SetOwner', function(plate)
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
end)
-- Backwards Compatibility ONLY -- Remove at some point --
-----------------------
----   Functions   ----
-----------------------
function openmenu()
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "key", 0.3)
    SendNUIMessage({ casemenue = 'open' })
    SetNuiFocus(true, true)
end
function isBlacklistedVehicle(vehicle)
    local isBlacklisted = false
    for _,v in ipairs(Config.NoLockVehicles) do
        if GetHashKey(v) == GetEntityModel(vehicle) then
            isBlacklisted = true
            break;
        end
    end
    if Entity(vehicle).state.ignoreLocks or GetVehicleClass(vehicle) == 13 then isBlacklisted = true end
    return isBlacklisted
end
function ToggleEngine(veh)
    if veh then
        local EngineOn = GetIsVehicleEngineRunning(veh)
        if not isBlacklistedVehicle(veh) then
            if HasKeys(QBCore.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                if EngineOn then
                    SetVehicleEngineOn(veh, false, false, true)
                else
                    SetVehicleEngineOn(veh, true, true, true)
                end
            end
        end
    end
end
function ToggleVehicleLockswithoutnui(veh)
    if veh then
        if not isBlacklistedVehicle(veh) then
            if HasKeys(QBCore.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                local ped = PlayerPedId()
                local vehLockStatus = GetVehicleDoorLockStatus(veh)

                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)

                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)

                NetworkRequestControlOfEntity(veh)
                if vehLockStatus == 1 then
                    TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 2)
                    QBCore.Functions.Notify(Lang:t("notify.vlock"), "primary")
                else
                    TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
                    QBCore.Functions.Notify(Lang:t("notify.vunlock"), "success")
                end

                SetVehicleLights(veh, 2)
                Wait(250)
                SetVehicleLights(veh, 1)
                Wait(200)
                SetVehicleLights(veh, 0)
                Wait(300)
                ClearPedTasks(ped)
            else
                QBCore.Functions.Notify(Lang:t("notify.ydhk"), 'error')
            end
        else
            TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
        end
    end
end
function GiveKeys(id, plate)
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(id))))
    if distance < 1.5 and distance > 0.0 then
        TriggerServerEvent('qb-vehiclekeys:server:GiveVehicleKeys', id, plate)
    else
        QBCore.Functions.Notify(Lang:t("notify.nonear"),'error')
    end
end
function GetKeys()
    QBCore.Functions.TriggerCallback('qb-vehiclekeys:server:GetVehicleKeys', function(keysList)
        KeysList = keysList
    end)
end
function HasKeys(plate)
    return KeysList[plate]
end
exports('HasKeys', HasKeys)
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(0)
    end
end
-- If in vehicle returns that, otherwise tries 3 different raycasts to get the vehicle they are facing.
-- Raycasts picture: https://i.imgur.com/FRED0kV.png

function GetVehicle()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    while vehicle == 0 do
        vehicle = QBCore.Functions.GetClosestVehicle()
        if #(pos - GetEntityCoords(vehicle)) > 8 then
            QBCore.Functions.Notify(Lang:t("notify.vehclose"), "error")
            return
        end
    end

    if not IsEntityAVehicle(vehicle) then vehicle = nil end
    return vehicle
end
function AreKeysJobShared(veh)
    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
    local vehPlate = QBCore.Functions.GetPlate(veh)
    local jobName = QBCore.Functions.GetPlayerData().job.name
    local onDuty = QBCore.Functions.GetPlayerData().job.onduty
    for job, v in pairs(Config.SharedKeys) do
        if job == jobName then
            if Config.SharedKeys[job].requireOnduty and not onDuty then return false end
            for _, vehicle in pairs(v.vehicles) do
                if string.upper(vehicle) == string.upper(vehName) then
                    if not HasKeys(vehPlate) then
                        TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", vehPlate)
                    end
                    return true
                end
            end
        end
    end
    return false
end
function ToggleVehicleLocks(veh)
    if veh then
        if not isBlacklistedVehicle(veh) then
            if HasKeys(QBCore.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                local ped = PlayerPedId()
                local vehLockStatus = GetVehicleDoorLockStatus(veh)
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                NetworkRequestControlOfEntity(veh)
                while NetworkGetEntityOwner(veh) ~= 128 do
                    NetworkRequestControlOfEntity(veh)
                    Wait(0)
                end
                if vehLockStatus == 1 then
                    TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 2)
                    QBCore.Functions.Notify(Lang:t("notify.vlock"), "primary")
                end
                SetVehicleLights(veh, 2)
                Wait(250)
                SetVehicleLights(veh, 1)
                Wait(200)
                SetVehicleLights(veh, 0)
                Wait(300)
                ClearPedTasks(ped)
            else
                QBCore.Functions.Notify(Lang:t("notify.ydhk"), 'error')
            end
        else
            TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
        end
    end
end
function ToggleVehicleunLocks(veh)
    if veh then
        if not isBlacklistedVehicle(veh) then
            if HasKeys(QBCore.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                local ped = PlayerPedId()
                local vehLockStatus = GetVehicleDoorLockStatus(veh)
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                NetworkRequestControlOfEntity(veh)
                if vehLockStatus == 2 then
                    TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
                    QBCore.Functions.Notify(Lang:t("notify.vunlock"), "success")
                end
                SetVehicleLights(veh, 2)
                Wait(250)
                SetVehicleLights(veh, 1)
                Wait(200)
                SetVehicleLights(veh, 0)
                Wait(300)
                ClearPedTasks(ped)
            else
                QBCore.Functions.Notify(Lang:t("notify.ydhk"), 'error')
            end
        else
            TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
        end
    end
end
function ToggleVehicleTrunk(veh)
    if veh then
        if not isBlacklistedVehicle(veh) then
            if HasKeys(QBCore.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                local ped = PlayerPedId()
                local boot = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'boot')
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                NetworkRequestControlOfEntity(veh)
                if boot ~= -1 or DoesEntityExist(veh) then
                    if trunkclose == true then
                        SetVehicleLights(veh, 2)
                        Citizen.Wait(150)
                        SetVehicleLights(veh, 0)
                        Citizen.Wait(150)
                        SetVehicleLights(veh, 2)
                        Citizen.Wait(150)
                        SetVehicleLights(veh, 0)
                        Citizen.Wait(150)
                        SetVehicleDoorOpen(veh, 5)
                        trunkclose = false
                        ClearPedTasks(ped)
                    else
                        SetVehicleLights(veh, 2)
                        Citizen.Wait(150)
                        SetVehicleLights(veh, 0)
                        Citizen.Wait(150)
                        SetVehicleLights(veh, 2)
                        Citizen.Wait(150)
                        SetVehicleLights(veh, 0)
                        Citizen.Wait(150)
                        SetVehicleDoorShut(veh, 5)
                        trunkclose = true
                        ClearPedTasks(ped)
                    end
			   end
            else
                QBCore.Functions.Notify(Lang:t("notify.ydhk"), 'error')
            end
        else
            TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
        end
    end
end
function GetOtherPlayersInVehicle(vehicle)
    local otherPeds = {}
    for seat=-1,GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))-2 do
        local pedInSeat = GetPedInVehicleSeat(vehicle, seat)
        if IsPedAPlayer(pedInSeat) and pedInSeat ~= PlayerPedId() then
            otherPeds[#otherPeds+1] = pedInSeat
        end
    end
    return otherPeds
end

function IsBlacklistedWeapon()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= nil then
        for _, v in pairs(Config.NoCarjackWeapons) do
            if weapon == GetHashKey(v) then
                return true
            end
        end
    end
    return false
end

function LockpickDoor(isAdvanced)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    if vehicle == nil or vehicle == 0 then return end
    if HasKeys(QBCore.Functions.GetPlate(vehicle)) then return end
    if #(pos - GetEntityCoords(vehicle)) > 2.5 then return end
    if GetVehicleDoorLockStatus(vehicle) <= 0 then return end

    usingAdvanced = isAdvanced
    TriggerEvent('qb-lockpick:client:openLockpick', lockpickFinish)
end
function lockpickFinish(success)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local chance = math.random()
    if success then
        TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
        lastPickedVehicle = vehicle
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', QBCore.Functions.GetPlate(vehicle))
        else
            QBCore.Functions.Notify('You managed to pick the door lock open!', 'success')
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
            SetVehicleDoorsLocked(vehicle, 1)
        end
    else
        TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
        AttemptPoliceAlert("steal")
    end
    if usingAdvanced then
        if chance <= Config.RemoveLockpickAdvanced then
            TriggerServerEvent("inventory:server:breakLockpick", "advancedlockpick")
        end
    else
        if chance <= Config.RemoveLockpickNormal then
            TriggerServerEvent("inventory:server:breakLockpick", "lockpick")
        end
    end
end

function AttemptPoliceAlert(type)
    if not AlertSend then
        local chance = Config.PoliceAlertChance
        if GetClockHours() >= 1 and GetClockHours() <= 6 then
            chance = Config.PoliceNightAlertChance
        end
        if math.random() <= chance then
           TriggerServerEvent('police:server:policeAlert', Lang:t("info.palert") .. type)
        end
        AlertSend = true
        SetTimeout(Config.AlertCooldown, function()
            AlertSend = false
        end)
    end
end

-----------------------
----   NUICallback   ----
-----------------------
RegisterNUICallback('closui', function()
	SetNuiFocus(false, false)
end)
RegisterNUICallback('unlock', function()
    ToggleVehicleunLocks(GetVehicle())
	SetNuiFocus(false, false)
end)
RegisterNUICallback('lock', function()
    ToggleVehicleLocks(GetVehicle())
	SetNuiFocus(false, false)
end)
RegisterNUICallback('trunk', function()
    ToggleVehicleTrunk(GetVehicle())
	SetNuiFocus(false, false)
end)
RegisterNUICallback('engine', function()
    ToggleEngine(GetVehicle())
	SetNuiFocus(false, false)
end)