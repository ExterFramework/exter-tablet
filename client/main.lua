local tablet = false
local opened = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = "prop_cs_tablet"
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)


RegisterNetEvent('exter-tablet:openTablet', function()
    SetNuiFocus(true, true)
    ToggleTablet(true)

    local backG = GetResourceKvpString('exterTabletBG')

    SendNUIMessage({
        type = 'showTabletUI',
        bG = backG 
    })
    opened = true
end)

RegisterNUICallback("exter-tablet:saveSettings", function(data)
    if data.bg then
        SetResourceKvp('exterTabletBG', data.bg)
        SetNuiFocus(false, false)
        ToggleTablet(false)
        SavedSettings()
        SendNUIMessage({
            type = 'hideTabletUI'
        })
        opened = false
    end   
end)

RegisterNetEvent("exter-tablet:Notify", function(t, d, i, du)
    SendNUIMessage({
        type = 'notify',
        title = t,
        description=d,
        imgSrc=i,
        duration=du,  
    })
end)

RegisterNetEvent("exter-tablet:fB2", function()
    if opened == true then
        SetNuiFocus(true, true)
    end
end)

RegisterNetEvent("exter-tablet:fB", function()
    if opened == true then
        SetNuiFocus(true, true)
    end
end)

RegisterNUICallback("hideTab", function(data)
    SetNuiFocus(false, false)
    ToggleTablet(false)
    SendNUIMessage({
        type = 'hideTabletUI'
    })
    opened = false
end)


RegisterNUICallback("openApp", function(data)
    TriggerEvent("exter-tablet:fB")

    if data.appName == "gruppe6" then
        TriggerEvent("exter-gruppe6job:Sign")
    elseif data.appName == 'contacts' then
        TriggerEvent("exter-contacts:showTablet")
    elseif data.appName == 'groups' then 
        TriggerEvent("exter-grops:open")
    elseif data.appName == 'trucking' then 
        TriggerEvent("exter-trucking:OpenTab")
    elseif data.appName == 'underground' then 

        TriggerCallback('exter-tablet:hasItem', function(hasItem)
            if hasItem then
                TriggerEvent('exter-boosting:OpenTab')
            else
                TriggerEvent("exter-tablet:Notify", "Underground", "You need a chip to access this application.", 'assets/ug-icon.png', 5000)
            end
        end, 'ugchip')
    elseif data.appName == 'hq' then 
        TriggerCallback('exter-tablet:hasItem', function(hasItem)
            if hasItem then
                print('Player has the item.')
            else
                TriggerEvent("exter-tablet:Notify", "HQ", "You need a chip to access this application.", 'assets/hq.png', 5000)
            end
        end, 'hqchip')
    elseif data.appName == 'business' then 
        TriggerEvent("exter-tablet:Notify", "Business", "Not ready yet!", 'assets/business.png', 2000)
    else
        --App not added yet
    end
    
end)

function ToggleTablet(toggle)
    if toggle and not tablet then
        tablet = true

        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            Citizen.CreateThread(function()
                RequestAnimDict(tabletDict)

                while not HasAnimDictLoaded(tabletDict) do
                    Citizen.Wait(150)
                end

                RequestModel(tabletProp)

                while not HasModelLoaded(tabletProp) do
                    Citizen.Wait(150)
                end

                local playerPed = PlayerPedId()
                local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
                local tabletBoneIndex = GetPedBoneIndex(playerPed, tabletBone)

                SetCurrentPedWeapon(playerPed, weapon_unarmed, true)
                AttachEntityToEntity(tabletObj, playerPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
                SetModelAsNoLongerNeeded(tabletProp)

                while tablet do
                    Citizen.Wait(100)
                    playerPed = PlayerPedId()

                    if not IsEntityPlayingAnim(playerPed, tabletDict, tabletAnim, 3) then
                        TaskPlayAnim(playerPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                    end
                end

                ClearPedSecondaryTask(playerPed)

                Citizen.Wait(450)

                DetachEntity(tabletObj, true, false)
                DeleteEntity(tabletObj)
            end)
        end
    elseif not toggle and tablet then
        tablet = false
    end
end