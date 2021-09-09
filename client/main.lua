local HasKey = false
local IsHotwiring = false
local IsRobbing = false
local isLoggedIn = false
local AlertSend = false
local lockpicked = false
local PlayerData = {}

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('vehiclekeys:client:SetOwner')
AddEventHandler('vehiclekeys:client:SetOwner', function(plate)
    local VehPlate = plate
    local CurrentVehPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
    if VehPlate == nil then
        VehPlate = CurrentVehPlate
    end
    TriggerServerEvent('vehiclekeys:server:SetVehicleOwner', VehPlate)
    if IsPedInAnyVehicle(PlayerPedId()) and plate == CurrentVehPlate then
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), true), true, false, true)
    end
    HasKey = true
end)

RegisterNetEvent('vehiclekeys:client:GiveKeys')
AddEventHandler('vehiclekeys:client:GiveKeys', function(target)
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
    TriggerServerEvent('vehiclekeys:server:GiveVehicleKeys', plate, target)
end)

RegisterNetEvent('vehiclekeys:client:ToggleEngine')
AddEventHandler('vehiclekeys:client:ToggleEngine', function()
    local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()))
    local veh = GetVehiclePedIsIn(PlayerPedId(), true)
    if HasKey then
        if EngineOn then
            SetVehicleEngineOn(veh, false, false, true)
        else
            SetVehicleEngineOn(veh, true, false, true)
        end
    end
end)

-- This event is to prevent you from having to /logout after restarting the vehiclekeys, will only trigger when the resource gets restarted manually or by the server, not client-side, client-side has it's own event: onClientResourceStart

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        PlayerData = QBCore.Functions.GetPlayerData()
        isLoggedIn = true
    end
end)

-- Main Thread

CreateThread(function()
    while true do
        local sleep = 100
        if isLoggedIn then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped)
            local inVeh = IsPedInAnyVehicle(ped, true)
            local entering = GetVehiclePedIsTryingToEnter(ped)
            local plate = GetVehicleNumberPlateText(entering)

            if entering ~= 0 and IsVehicleSeatFree(entering, -1) then
                if not lockpicked then
                    QBCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
                        if result == false then
                            SetVehicleDoorsLocked(entering, 2)
                        else
                            HasKey = true
                        end
                    end, plate)
                end
            end

            if inVeh and lockpicked and not IsHotwiring and not HasKey then
                sleep = 10
                local vehpos = GetEntityCoords(veh)
                SetVehicleEngineOn(veh, false, false, true)
                DrawText3D(vehpos.x, vehpos.y, vehpos.z, "~g~H~w~ - Hotwire")
                if IsControlJustPressed(0, 74) then
                    Hotwire()
                end
            end

            if not IsRobbing then
                local vehicle = GetVehiclePedIsTryingToEnter(ped)
                if vehicle ~= nil and vehicle ~= 0 then
                    local driver = GetPedInVehicleSeat(vehicle, -1)
                    if driver ~= 0 and not IsPedAPlayer(driver) then
                        if IsEntityDead(driver) then
                            IsRobbing = true
                            QBCore.Functions.Progressbar("rob_keys", "Grabbing keys..", 2500, false, true, {}, {}, {}, {}, function() -- Done
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                                HasKey = true
                                IsRobbing = false
                            end)
                        end
                    end
                end
    
                local playerid = PlayerId()
                local aiming, target = GetEntityPlayerIsFreeAimingAt(playerid)
                if aiming and (target ~= nil and target ~= 0) and PlayerData.job.name ~= 'police' then
                    if DoesEntityExist(target) and not IsEntityDead(target) and not IsPedAPlayer(target) then
                        if IsPedInAnyVehicle(target, false) and not inVeh then
                            if not IsBlacklistedWeapon() then
                                local pos = GetEntityCoords(ped, true)
                                local targetpos = GetEntityCoords(target, true)
                                local vehicle = GetVehiclePedIsIn(target, true)
                                if #(pos - targetpos) < 5.0 then
                                    RobVehicle(target)
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

-- Vehicle Locking

RegisterKeyMapping('togglelocks', 'Toggle Vehicle Locks', 'keyboard', 'L')
RegisterCommand('togglelocks', function()
    LockVehicle()
end)

function LockVehicle()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local veh = QBCore.Functions.GetClosestVehicle(pos)
    local plate = GetVehicleNumberPlateText(veh)
    local vehpos = GetEntityCoords(veh)
    if IsPedInAnyVehicle(ped) then
        veh = GetVehiclePedIsIn(ped)
    end
    if veh ~= nil and #(pos - vehpos) < 7.5 then
        QBCore.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
            if result then
                local vehLockStatus = GetVehicleDoorLockStatus(veh)
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
    
                if vehLockStatus == 1 then
                    Citizen.Wait(750)
                    ClearPedTasks(ped)
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                    SetVehicleDoorsLocked(veh, 2)
                    if(GetVehicleDoorLockStatus(veh) == 2)then
                        SetVehicleLights(veh,2)
                        Wait(250)
                        SetVehicleLights(veh,1)
                        Wait(200)
                        SetVehicleLights(veh,0)
                        QBCore.Functions.Notify("Vehicle locked!")
                    else
                        QBCore.Functions.Notify("Something went wrong with the locking system!")
                    end
                else
                    Citizen.Wait(750)
                    ClearPedTasks(ped)
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                    SetVehicleDoorsLocked(veh, 1)
                    if(GetVehicleDoorLockStatus(veh) == 1)then
                        SetVehicleLights(veh,2)
                        Wait(250)
                        SetVehicleLights(veh,1)
                        Wait(200)
                        SetVehicleLights(veh,0)
                        QBCore.Functions.Notify("Vehicle unlocked!")
                    else
                        QBCore.Functions.Notify("Something went wrong with the locking system!")
                    end
                end
            else
                QBCore.Functions.Notify('You don\'t have the keys of the vehicle..', 'error')
            end
        end, plate)
    end
end

-- Lockpicking

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    LockpickDoor(isAdvanced)
end)

function LockpickDoor(isAdvanced)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicle = QBCore.Functions.GetClosestVehicle(pos)
    if vehicle ~= nil and vehicle ~= 0 then
        local vehpos = GetEntityCoords(vehicle)
        if #(pos - vehpos) < 1.5 then
            local vehLockStatus = GetVehicleDoorLockStatus(vehicle)
            if (vehLockStatus > 0) then
                TriggerEvent('qb-lockpick:client:openLockpick', lockpickFinish)
            end
        end
    end
end

function lockpickFinish(success)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicle = QBCore.Functions.GetClosestVehicle(pos)
    local chance = math.random(1, 100)
    if success then
        SetVehicleDoorsLocked(vehicle, 0)
        SetVehicleAlarm(vehicle, false)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        lockpicked = true
        TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
        QBCore.Functions.Notify('Opened Door!', 'success')
    else
        PoliceCall()
        TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
        QBCore.Functions.Notify('Someone Called The Police!', 'error')
    end

    if chance <= 50 then
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["lockpick"], "remove")
        TriggerServerEvent("QBCore:Server:RemoveItem", "lockpick", 1)
    end
end

-- Hotwire Vehicle

function Hotwire()
    if not HasKey then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, true)
        IsHotwiring = true
        local hotwireTime = math.random(20000, 40000)
        SetVehicleAlarm(vehicle, true)
        SetVehicleAlarmTimeLeft(vehicle, hotwireTime)
        PoliceCall()
        QBCore.Functions.Progressbar("hotwire_vehicle", "Engaging the ignition switch", hotwireTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            if (math.random(0, 100) < 10) then
                lockpicked = false
                TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
                TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
                QBCore.Functions.Notify("Hotwire succeeded!")
            else
                SetVehicleEngineOn(veh, false, false, true)
                TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
                QBCore.Functions.Notify("Hotwire failed!", "error")
            end
            IsHotwiring = false
        end, function() -- Cancel
            StopAnimTask(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            SetVehicleEngineOn(veh, false, false, true)
            QBCore.Functions.Notify("Hotwire failed!", "error")
            IsHotwiring = false
        end)
    end
end

-- Alert Police

function PoliceCall()
    if not AlertSend then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local chance = 20
        if GetClockHours() >= 1 and GetClockHours() <= 6 then
            chance = 10
        end
        if math.random(1, 100) <= chance then
            local closestPed = GetNearbyPed()
            if closestPed ~= nil then
                local msg = ""
                local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                local streetLabel = GetStreetNameFromHashKey(s1)
                local street2 = GetStreetNameFromHashKey(s2)
                if street2 ~= nil and street2 ~= "" then 
                    streetLabel = streetLabel .. " " .. street2
                end
                local alertTitle = ""
                if IsPedInAnyVehicle(ped) then
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
                    if QBCore.Shared.Vehicles[modelName] ~= nil then
                        Name = QBCore.Shared.Vehicles[modelName]["brand"] .. ' ' .. QBCore.Shared.Vehicles[modelName]["name"]
                    else
                        Name = "Unknown"
                    end
                    local modelPlate = GetVehicleNumberPlateText(vehicle)
                    local msg = "Vehicle theft attempt at " ..streetLabel.. ". Vehicle: " .. Name .. ", Licenseplate: " .. modelPlate
                    local alertTitle = "Vehicle theft attempt at"
                    TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)
                else
                    local vehicle = QBCore.Functions.GetClosestVehicle()
                    local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
                    local modelPlate = GetVehicleNumberPlateText(vehicle)
                    if QBCore.Shared.Vehicles[modelName] ~= nil then
                        Name = QBCore.Shared.Vehicles[modelName]["brand"] .. ' ' .. QBCore.Shared.Vehicles[modelName]["name"]
                    else
                        Name = "Unknown"
                    end
                    local msg = "Vehicle theft attempt at " ..streetLabel.. ". Vehicle: " .. Name .. ", Licenseplate: " .. modelPlate
                    local alertTitle = "Vehicle theft attempt at"
                    TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)
                end
            end
        end
        AlertSend = true
        SetTimeout(2 * (60 * 1000), function()
            AlertSend = false
        end)
    end
end

-- Rob a vehicle

function RobVehicle(target)
    IsRobbing = true
    loadAnimDict('mp_am_hold_up')
    TaskPlayAnim(target, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
    QBCore.Functions.Progressbar("rob_keys", "Attempting Robbery..", 6000, false, true, {}, {}, {}, {}, function()
        local chance = math.random(1, 100)
        if chance > 85 then
            ClearPedTasksImmediately(target)
            TaskLeaveVehicle(target, GetVehiclePedIsUsing(target), 256)
            TaskSmartFleePed(target, PlayerPedId(), 40.0, 20000)
            local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, true))
            IsRobbing = false
            TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
            TriggerEvent('vehiclekeys:client:SetOwner', plate)
            QBCore.Functions.Notify('You Got The Keys!', 'success')
        else
            PoliceCall()
            TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
            TaskSmartFleePed(target, PlayerPedId(), 40.0, 20000)
            QBCore.Functions.Notify('They Called The Cops!', 'error')
            Wait(2000)
            IsRobbing = false
        end
    end)
end

-- Util Functions

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

function GetNearbyPed()
	local retval = nil
	local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
	local closestPed, closestDistance = QBCore.Functions.GetClosestPed(coords, PlayerPeds)
	if not IsEntityDead(closestPed) and closestDistance < 30.0 then
		retval = closestPed
	end
	return retval
end

function IsBlacklistedWeapon()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= nil then
        for _, v in pairs(Config.NoRobWeapons) do
            if weapon == GetHashKey(v) then
                return true
            end
        end
    end
    return false
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
