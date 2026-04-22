local tablet = {
    active = false,
    uiOpen = false,
    object = nil,
    dict = 'amb@code_human_in_bus_passenger_idles@female@tablet@base',
    anim = 'base',
    prop = 'prop_cs_tablet',
    bone = 60309,
    offset = vector3(0.03, 0.002, 0.0),
    rot = vector3(10.0, 160.0, 0.0)
}

local function safeFocus(enable)
    SetNuiFocus(enable, enable)
    SetNuiFocusKeepInput(enable)
end

local function stopTabletAnimation()
    local ped = PlayerPedId()

    if tablet.object and DoesEntityExist(tablet.object) then
        DetachEntity(tablet.object, true, false)
        DeleteEntity(tablet.object)
        tablet.object = nil
    end

    StopAnimTask(ped, tablet.dict, tablet.anim, 2.0)
    ClearPedSecondaryTask(ped)
end

local function playTabletAnimationLoop()
    CreateThread(function()
        RequestAnimDict(tablet.dict)
        while not HasAnimDictLoaded(tablet.dict) do
            Wait(0)
        end

        RequestModel(tablet.prop)
        while not HasModelLoaded(tablet.prop) do
            Wait(0)
        end

        local ped = PlayerPedId()
        tablet.object = CreateObject(tablet.prop, GetEntityCoords(ped), true, true, false)
        AttachEntityToEntity(
            tablet.object,
            ped,
            GetPedBoneIndex(ped, tablet.bone),
            tablet.offset.x,
            tablet.offset.y,
            tablet.offset.z,
            tablet.rot.x,
            tablet.rot.y,
            tablet.rot.z,
            true,
            false,
            false,
            false,
            2,
            true
        )

        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)

        while tablet.active do
            ped = PlayerPedId()

            if not IsEntityPlayingAnim(ped, tablet.dict, tablet.anim, 3) then
                TaskPlayAnim(ped, tablet.dict, tablet.anim, 3.0, 3.0, -1, 49, 0, false, false, false)
            end

            Wait(300)
        end

        stopTabletAnimation()
        SetModelAsNoLongerNeeded(tablet.prop)
        RemoveAnimDict(tablet.dict)
    end)
end

local function setTabletState(enable)
    if enable == tablet.active then
        return
    end

    tablet.active = enable

    if enable then
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            playTabletAnimationLoop()
        end
    else
        stopTabletAnimation()
    end
end

local function closeTabletUI()
    safeFocus(false)
    setTabletState(false)
    SendNUIMessage({ type = 'hideTabletUI' })
    tablet.uiOpen = false
end

local function openTabletUI()
    local backG = GetResourceKvpString('exterTabletBG') or Config.Defaults.background

    safeFocus(true)
    setTabletState(true)
    SendNUIMessage({
        type = 'showTabletUI',
        bG = backG
    })

    tablet.uiOpen = true
end

local function notifyLockedApp(title, description, image, duration)
    SendNUIMessage({
        type = 'notify',
        title = title,
        description = description,
        imgSrc = image,
        duration = duration
    })
end

RegisterNetEvent('exter-tablet:openTablet', openTabletUI)

RegisterNetEvent('exter-tablet:Notify', function(title, description, image, duration)
    notifyLockedApp(title, description, image, duration)
end)

RegisterNetEvent('exter-tablet:fB', function()
    if tablet.uiOpen then
        safeFocus(true)
    end
end)

RegisterNetEvent('exter-tablet:fB2', function()
    if tablet.uiOpen then
        safeFocus(true)
    end
end)

RegisterNUICallback('hideTab', function(_, cb)
    closeTabletUI()
    cb('ok')
end)

RegisterNUICallback('exter-tablet:saveSettings', function(data, cb)
    if data and data.bg and data.bg ~= '' then
        SetResourceKvp('exterTabletBG', data.bg)
        SavedSettings()
    end

    closeTabletUI()
    cb('ok')
end)

RegisterNUICallback('openApp', function(data, cb)
    TriggerEvent('exter-tablet:fB')

    local appName = data and data.appName or nil
    if not appName then
        cb('ok')
        return
    end

    if appName == 'gruppe6' then
        TriggerEvent('exter-gruppe6job:Sign')
    elseif appName == 'contacts' then
        TriggerEvent('exter-contacts:showTablet')
    elseif appName == 'groups' then
        TriggerEvent('exter-grops:open')
    elseif appName == 'trucking' then
        TriggerEvent('exter-trucking:OpenTab')
    elseif appName == 'underground' then
        TriggerCallback('exter-tablet:hasItem', function(hasItem)
            if hasItem then
                TriggerEvent('exter-boosting:OpenTab')
            else
                notifyLockedApp('Underground', 'You need a chip to access this application.', 'assets/ug-icon.png', 5000)
            end
        end, Config.RequiredItems.underground)
    elseif appName == 'hq' then
        TriggerCallback('exter-tablet:hasItem', function(hasItem)
            if not hasItem then
                notifyLockedApp('HQ', 'You need a chip to access this application.', 'assets/hq.png', 5000)
            end
        end, Config.RequiredItems.hq)
    elseif appName == 'business' then
        notifyLockedApp('Business', 'Not ready yet!', 'assets/business.png', 2000)
    end

    cb('ok')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    closeTabletUI()
end)
