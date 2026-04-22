RegisterUsableItem(Config.TabletItem, function(source)
    TriggerClientEvent('exter-tablet:openTablet', source)
end)

RegisterCallback('exter-tablet:hasItem', function(source, cb, itemName)
    local player = GetPlayer(source)
    cb(PlayerHasItem(source, player, itemName))
end)

exports('GetDetectedAdapters', function()
    return {
        framework = GetFrameworkName(),
        inventory = GetInventoryName(),
        fuel = GetFuelName()
    }
end)
