ExterTablet = ExterTablet or {}

local function isStarted(resource)
    return resource and GetResourceState(resource) == 'started'
end

local function pickFromAuto(typeName, configured, map, orderedKeys)
    if configured and configured ~= 'auto' then
        return configured
    end

    for _, key in ipairs(orderedKeys) do
        local resource = map[key]
        if isStarted(resource) then
            return key
        end
    end

    return 'standalone'
end

function ExterTablet.DetectFramework()
    return pickFromAuto('framework', Config.Framework, Config.FrameworkResources, { 'qbox', 'qbcore', 'esx' })
end

function ExterTablet.DetectInventory()
    return pickFromAuto('inventory', Config.Inventory, Config.InventoryResources, {
        'ox_inventory',
        'qb-inventory',
        'esx_inventory',
        'qs-inventory'
    })
end

function ExterTablet.DetectFuel()
    return pickFromAuto('fuel', Config.Fuel, Config.FuelResources, {
        'ox_fuel',
        'cdn-fuel',
        'qb-fuel',
        'LegacyFuel'
    })
end

function ExterTablet.DebugPrint(message)
    if Config.Debug then
        print(('[exter-tablet] %s'):format(message))
    end
end
