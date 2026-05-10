local QBCore = exports['qb-core']:GetCoreObject()

local sleep = 5
local deepSleep = 100
local superDeepSleep = Config.SpamDelay
local antiSpam = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep)

        -- 4|2 checks for Melee and Firearms
        if IsPedArmed(PlayerPedId(), 4|2) then
            local ped = PlayerPedId()
            local _, hash = GetCurrentPedWeapon(ped, 1)
            local clipSize = GetWeaponClipSize(hash)
            local ammoInWeapon = GetAmmoInPedWeapon(ped, hash)

            -- QB-Core specific: Prevent ammo overfill
            if Config.CheckAndApplyAmmo then
                if ammoInWeapon > clipSize then
                    SetAmmoInClip(ped, hash, 0)
                    SetPedAmmo(ped, hash, clipSize)
                end
            end

            if not antiSpam then
                if IsControlJustReleased(0, 45) then -- 'R' Key
                    if Config.Framework == "QBCORE" then
                        -- We pass the hash so the server can look up the ammo type in QBCore.Shared.Weapons
                        TriggerServerEvent("r1reload:server:checkInventory", hash)
                    elseif Config.Framework == "STANDALONE" then
                        TriggerEvent("r1reload:reload")
                    end
                end
            end

            if Config.DisablePistolPunching then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end
        else
            Citizen.Wait(deepSleep)
        end
    end
end)

RegisterNetEvent("r1reload:reload")
AddEventHandler("r1reload:reload", function(hasItem)
    local ped = PlayerPedId()
    if IsPedArmed(ped, 4|2) then
        if Config.Framework == "QBCORE" then
            if hasItem then
                local _, hash = GetCurrentPedWeapon(ped, 1)
                local clipSize = GetWeaponClipSize(hash)
                local _, ammoInClip = GetAmmoInClip(ped, hash)

                if ammoInClip ~= clipSize then
                    -- Trigger server to remove the item now that client is confirmed reloading
                    TriggerServerEvent("r1reload:server:removeAmmoBox", hash)
                    
					
                    -- Visual/Mechanical reload
                    SetAmmoInClip(ped, hash, 0)
                    SetPedAmmo(ped, hash, clipSize)
                else
                    QBCore.Functions.Notify(Config.Notifications.FullClip, "error")
                    antiSpam = true
                    Citizen.Wait(superDeepSleep)
                    antiSpam = false
                end
            else
                QBCore.Functions.Notify(Config.Notifications.NotEnough, "error")
                antiSpam = true
                Citizen.Wait(superDeepSleep)
                antiSpam = false
            end
        elseif Config.Framework == "STANDALONE" then
            local _, hash = GetCurrentPedWeapon(ped, 1)
            local clipSize = GetWeaponClipSize(hash)
            local _, ammoInClip = GetAmmoInClip(ped, hash)

            if ammoInClip ~= clipSize then
                SetAmmoInClip(ped, hash, 0)
                SetPedAmmo(ped, hash, clipSize)
            else
                print(Config.Notifications.FullClip)
                antiSpam = true
                Citizen.Wait(superDeepSleep)
                antiSpam = false
            end
        end
    end
end)

-- Debug Thread
Citizen.CreateThread(function()
    while Config.Debug do
        Citizen.Wait(Config.DebugRefresh or 1000)

        local ped = PlayerPedId()
        local _, hash = GetCurrentPedWeapon(ped, 1)
        local clipSize = GetWeaponClipSize(hash)
        local ammoInWeapon = GetAmmoInPedWeapon(ped, hash)
        local _, ammoInClip = GetAmmoInClip(ped, hash)
        local ammoType = GetPedAmmoTypeFromWeapon(ped, hash)
        local _, maxAmmo = GetMaxAmmo(ped, hash)

        print("\n--- R1 RELOAD DEBUG ---")
        print("Weapon Hash   : " .. hash)
        print("Max Ammo      : " .. maxAmmo)
        print("Total Ammo    : " .. ammoInWeapon)
        print("Ammo Type     : " .. ammoType)
        print("Clip Size     : " .. clipSize)
        print("Ammo In clip  : " .. ammoInClip)
        print("-----------------------")
    end
end)
