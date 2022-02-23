-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local VehicleList = {}

-- Functions

local function CheckOwner(plate, identifier)
    local retval = false
    if VehicleList then
        local found = VehicleList[plate]
        if found then
            retval = found.owners[identifier] ~= nil and found.owners[identifier]
        end
    end

    return retval
end

-- Events

RegisterNetEvent('vehiclekeys:server:SetVehicleOwner', function(plate)
    if plate then
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if VehicleList then
            -- VehicleList exists so check for a plate
            local val = VehicleList[plate]
            if val then
                -- The plate exists
                VehicleList[plate].owners[Player.PlayerData.citizenid] = true
            else
                -- Plate not currently tracked so store a new one with one owner
                VehicleList[plate] = {
                    owners = {}
                }
                VehicleList[plate].owners[Player.PlayerData.citizenid] = true
            end
        else
            -- Initialize new VehicleList
            VehicleList = {}
            VehicleList[plate] = {
                owners = {}
            }
            VehicleList[plate].owners[Player.PlayerData.citizenid] = true
        end
    else
        print('vehiclekeys:server:SetVehicleOwner - plate argument is nil')
    end
end)

RegisterNetEvent('vehiclekeys:server:GiveVehicleKeys', function(plate, target)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if CheckOwner(plate, Player.PlayerData.citizenid) then
        if QBCore.Functions.GetPlayer(target) ~= nil then
            TriggerClientEvent('vehiclekeys:client:SetOwner', target, plate)
            TriggerClientEvent('QBCore:Notify', src, "You gave the keys!")
            TriggerClientEvent('QBCore:Notify', target, "You got the keys!")
        else
            TriggerClientEvent('QBCore:Notify', source,  "Player Not Online", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source,  "You Dont Own This Vehicle", "error")
    end
end)

-- callback

QBCore.Functions.CreateCallback('vehiclekeys:server:CheckOwnership', function(source, cb, plate)
    local check = VehicleList[plate]
    local retval = check ~= nil

    cb(retval)
end)

QBCore.Functions.CreateCallback('vehiclekeys:server:CheckHasKey', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    cb(CheckOwner(plate, Player.PlayerData.citizenid))
end)

-- command

QBCore.Commands.Add("engine", "Toggle Engine", {}, false, function(source, args)
	TriggerClientEvent('vehiclekeys:client:ToggleEngine', source)
end)

QBCore.Commands.Add("givecarkeys", "Give Car Keys", {{name = "id", help = "Player id"}}, true, function(source, args)
	local src = source
    local target = tonumber(args[1])
    TriggerClientEvent('vehiclekeys:client:GiveKeys', src, target)
end)


-- remove keys
local function removeKeys(plate, citizenid)
    local car = MySQL.single.await('SELECT * FROM player_vehicles WHERE citizenid = ? AND player = ?', {citizenid, plate})

    if not car then return false, "failed_not_found" end

    local removeKeys = MySQL.update.await('UPDATE player_vehicles SET citizenid = NULL, license = null WHERE id = ?', {car.id})
    VehicleList[plate] = {}
    return true, "success"
end

RegisterNetEvent('vehiclekeys:server:RemoveKeys', function(plate, citizenid)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData
    local isPrincipal = IsPlayerAceAllowed(src, 'removekeys')
    local isGod = QBCore.Functions.HasPermission(src, 'god')
    local isAdmin = QBCore.Functions.HasPermission(src, 'admin')

    if isPrincipal or isGod or isAdmin or citizenid == PlayerData.citizenid then
        local result, message = removeKeys(plate, citizenid)

        if not result then
            if message == "failed_not_found" then
                TriggerClientEvent('QBCore:Notify', src,  "Vehicle is not found.", "error")
            end
            return false
        end

        TriggerClientEvent('QBCore:Notify', src,  ("You have removed the keys of vehicle %s"):format(plate), "success")

    else
        TriggerClientEvent('QBCore:Notify', src,  "You do not own this vehicle or lack the permissions.", "error")
    end
end)

exports('RemoveKeys', removeKeys)