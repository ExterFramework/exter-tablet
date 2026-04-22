if Config.Framework == "QBCore" then 
    QBCore = exports[Config.FrameworkFolder]:GetCoreObject()
elseif Config.Framework == "ESX" then 
    ESX = exports[Config.FrameworkFolder]:getSharedObject()
end

function Notify(msg, typ)
    if Config.Framework == 'QBCore' then
        QBCore.Functions.Notify(msg, typ)
    else
        ESX.ShowHelpNotification(msg)
    end
end


function SavedSettings()
    Notify("Your Settings was saved sucessfully !")
end
