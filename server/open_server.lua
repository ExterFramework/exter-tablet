if Config.Framework == 'QBCore' then 
    QBCore = exports[Config.FrameworkFolder]:GetCoreObject()

    QBCore.Functions.CreateUseableItem("tablet", function(source)
        TriggerClientEvent("exter-tablet:openTablet", source)
    end)

elseif Config.Framewework == 'ESX' then 
    ESX = exports[Config.FrameworkFolder]:getSharedObject()

    ESX.RegisterUsableItem('tablet', function(source)
        TriggerClientEvent('exter-tablet:openTablet', source)
    end)
    
elseif Config.Framework == 'Custom' then
    -- Put here your variables and your own Code.
end



RegisterCallback('exter-tablet:hasItem', function(source, cb, item)
    local player = GetPlayer(source)
    if player then
        local hasItem = GetItembyName(item, player)  
        cb(hasItem)
    else
        cb(false)
    end
end)

