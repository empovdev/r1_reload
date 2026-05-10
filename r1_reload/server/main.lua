local QBCore = exports['qb-core']:GetCoreObject()

-- This helper function finds the correct item name based on the weapon's ammo type
local function GetAmmoItemName(weaponHash)
    local weaponInfo = QBCore.Shared.Weapons[weaponHash]
    if not weaponInfo or not weaponInfo.ammotype then return nil end

    -- Map the AMMO_TYPE from shared/weapons.lua to your inventory item names
    local ammoMapping = {
        ["AMMO_PISTOL"]   = "pistol_ammo",
        ["AMMO_RIFLE"]    = "rifle_ammo",
        ["AMMO_SMG"]      = "smg_ammo",
        ["AMMO_SHOTGUN"]  = "shotgun_ammo",
        ["AMMO_SNIPER"]   = "sniper_ammo",
    }

    return ammoMapping[weaponInfo.ammotype]
end

-- Check if player has the ammo item
RegisterNetEvent("r1reload:server:checkInventory", function(weaponHash)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local itemName = GetAmmoItemName(weaponHash)
    
    -- Fallback to Config.Item if mapping fails (for custom items)
    if not itemName then itemName = Config.Item end

    local item = Player.Functions.GetItemByName(itemName)

    if item and item.amount >= 1 then
        TriggerClientEvent("r1reload:reload", src, true)
    else
        TriggerClientEvent("r1reload:reload", src, false)
    end
end)

-- Remove the ammo item from inventory
RegisterNetEvent("r1reload:server:removeAmmoBox", function(weaponHash)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local itemName = GetAmmoItemName(weaponHash)
    
    -- Fallback to Config.Item if mapping fails
    if not itemName then itemName = Config.Item end

    local item = Player.Functions.GetItemByName(itemName)

    if item and item.amount >= 1 then
        Player.Functions.RemoveItem(itemName, 1)
        -- Triggers the UI pop-up showing an item was removed
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], "remove")
    end
end)