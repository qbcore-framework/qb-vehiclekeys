local VehicleList = {}

QBCore.Functions.CreateCallback('vehiclekeys:CheckOwnership', function(source, cb, plate)
    local check = VehicleList[plate]
    local retval = check ~= nil

    cb(retval)
end)

QBCore.Functions.CreateCallback('vehiclekeys:CheckHasKey', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    cb(CheckOwner(plate, Player.PlayerData.citizenid))
end)

RegisterServerEvent('vehiclekeys:server:SetVehicleOwner')
AddEventHandler('vehiclekeys:server:SetVehicleOwner', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if VehicleList ~= nil then
        local val = VehicleList[plate]
        if val ~= nil then
            VehicleList[plate].owners[Player.PlayerData.citizenid] = true
        else
            VehicleList[plate] = {
                owners = {}
            }
            VehicleList[plate].owners[Player.PlayerData.citizenid] = true
        end
    else
        VehicleList = {}
        VehicleList[plate] = {
            owners = {}
        }
        VehicleList[plate].owners[Player.PlayerData.citizenid] = true
    end
end)

RegisterServerEvent('vehiclekeys:server:GiveVehicleKeys')
AddEventHandler('vehiclekeys:server:GiveVehicleKeys', function(plate, target)
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

QBCore.Commands.Add("engine", "Toggle Engine", {}, false, function(source, args)
	TriggerClientEvent('vehiclekeys:client:ToggleEngine', source)
end)

QBCore.Commands.Add("givecarkeys", "Give Car Keys", {{name = "id", help = "Player id"}}, true, function(source, args)
	local src = source
    local target = tonumber(args[1])
    TriggerClientEvent('vehiclekeys:client:GiveKeys', src, target)
end)

function DoesPlateExist(plate)
    local retval = false
    if VehicleList ~= nil then
        local found = VehicleList[plate]
        retval = found ~= nil
    end
    return retval
end

function CheckOwner(plate, identifier)
    local retval = false
    if VehicleList ~= nil then
        local found = VehicleList[plate]
        if found ~= nil then
            retval = found.owners[identifier] ~= nil or found.owners[identifier] == true
        end
    end

    return retval
end

QBCore.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

QBCore.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
end)
