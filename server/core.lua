local Core = {
    framework = ExterTablet.DetectFramework(),
    inventory = ExterTablet.DetectInventory(),
    fuel = ExterTablet.DetectFuel()
}

local QBCore, ESX

local function bootFramework()
    if Core.framework == 'qbcore' then
        QBCore = exports[Config.FrameworkResources.qbcore]:GetCoreObject()
    elseif Core.framework == 'qbox' then
        QBCore = exports[Config.FrameworkResources.qbox]:GetCoreObject()
    elseif Core.framework == 'esx' then
        ESX = exports[Config.FrameworkResources.esx]:getSharedObject()
    end

    ExterTablet.DebugPrint(('framework=%s inventory=%s fuel=%s'):format(Core.framework, Core.inventory, Core.fuel))
end

bootFramework()

function GetFrameworkName()
    return Core.framework
end

function GetInventoryName()
    return Core.inventory
end

function GetFuelName()
    return Core.fuel
end

function GetPlayer(src)
    if Core.framework == 'qbcore' or Core.framework == 'qbox' then
        return QBCore.Functions.GetPlayer(src)
    elseif Core.framework == 'esx' then
        return ESX.GetPlayerFromId(src)
    end

    return nil
end

function RegisterCallback(name, handler)
    if Core.framework == 'qbcore' or Core.framework == 'qbox' then
        QBCore.Functions.CreateCallback(name, handler)
    elseif Core.framework == 'esx' then
        ESX.RegisterServerCallback(name, handler)
    else
        RegisterNetEvent(name, function(requestId, ...)
            local src = source
            local function cb(payload)
                TriggerClientEvent(('%s:response'):format(name), src, requestId, payload)
            end

            handler(src, cb, ...)
        end)
    end
end

function Notify(src, message, msgType)
    if Core.framework == 'qbcore' or Core.framework == 'qbox' then
        TriggerClientEvent('QBCore:Notify', src, message, msgType or 'primary')
    elseif Core.framework == 'esx' then
        TriggerClientEvent('esx:showNotification', src, message)
    else
        TriggerClientEvent('chat:addMessage', src, {
            color = { 255, 255, 255 },
            multiline = false,
            args = { 'Tablet', message }
        })
    end
end

local function hasItemQb(player, itemName)
    local item = player and player.Functions.GetItemByName(itemName)
    return item ~= nil
end

local function hasItemOx(src, itemName)
    local count = exports.ox_inventory:Search(src, 'count', itemName)
    return (count or 0) > 0
end

local function hasItemEsx(player, itemName)
    local item = player and player.getInventoryItem(itemName)
    return item and (item.count or 0) > 0
end

local function hasItemQs(src, itemName)
    local item = exports['qs-inventory']:GetItemByName(src, itemName)
    return item ~= nil and (item.amount or item.count or 0) > 0
end

function PlayerHasItem(src, player, itemName)
    if not itemName or itemName == '' then
        return false
    end

    if Core.inventory == 'ox_inventory' then
        return hasItemOx(src, itemName)
    elseif Core.inventory == 'qb-inventory' then
        return hasItemQb(player, itemName)
    elseif Core.inventory == 'esx_inventory' then
        return hasItemEsx(player, itemName)
    elseif Core.inventory == 'qs-inventory' then
        return hasItemQs(src, itemName)
    end

    if Core.framework == 'qbcore' or Core.framework == 'qbox' then
        return hasItemQb(player, itemName)
    elseif Core.framework == 'esx' then
        return hasItemEsx(player, itemName)
    end

    return false
end

function RegisterUsableItem(itemName, cb)
    if Core.framework == 'qbcore' or Core.framework == 'qbox' then
        QBCore.Functions.CreateUseableItem(itemName, function(source)
            cb(source)
        end)
    elseif Core.framework == 'esx' then
        ESX.RegisterUsableItem(itemName, function(source)
            cb(source)
        end)
    else
        ExterTablet.DebugPrint(('standalone mode: usable item "%s" cannot auto-register'):format(itemName))
    end
end

function GetCoreObject()
    return QBCore or ESX
end

CreateThread(function()
    print(('[exter-tablet] started | framework=%s | inventory=%s | fuel=%s'):format(Core.framework, Core.inventory, Core.fuel))
end)
