local framework = ExterTablet.DetectFramework()
local QBCore, ESX

if framework == 'qbcore' then
    QBCore = exports[Config.FrameworkResources.qbcore]:GetCoreObject()
elseif framework == 'qbox' then
    QBCore = exports[Config.FrameworkResources.qbox]:GetCoreObject()
elseif framework == 'esx' then
    ESX = exports[Config.FrameworkResources.esx]:getSharedObject()
end

local callbackNonce = 0
local callbackResolvers = {}

local function getRequestId()
    callbackNonce = callbackNonce + 1
    return callbackNonce
end

RegisterNetEvent('exter-tablet:hasItem:response', function(requestId, payload)
    local resolver = callbackResolvers[requestId]
    if resolver then
        resolver(payload)
        callbackResolvers[requestId] = nil
    end
end)

function TriggerCallback(name, cb, ...)
    if framework == 'qbcore' or framework == 'qbox' then
        QBCore.Functions.TriggerCallback(name, cb, ...)
    elseif framework == 'esx' then
        ESX.TriggerServerCallback(name, cb, ...)
    else
        local requestId = getRequestId()
        callbackResolvers[requestId] = cb
        TriggerServerEvent(name, requestId, ...)
    end
end

function Notify(msg, msgType)
    if framework == 'qbcore' or framework == 'qbox' then
        QBCore.Functions.Notify(msg, msgType or 'primary')
    elseif framework == 'esx' then
        ESX.ShowNotification(msg)
    else
        TriggerEvent('chat:addMessage', {
            color = { 255, 255, 255 },
            multiline = false,
            args = { 'Tablet', msg }
        })
    end
end

function SavedSettings()
    Notify('Your settings were saved successfully!', 'success')
end

function GetDetectedFramework()
    return framework
end
