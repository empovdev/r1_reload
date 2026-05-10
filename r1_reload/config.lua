Config = {}

Config.Framework = "QBCORE"             --"QBCORE", "ESX", or "STANDALONE"

Config.Debug = false                    -- Displays information about the current weapon (prints to console).
Config.DebugRefresh = 5000              -- How often should it refresh.

-- This is used as a fallback if the script can't find a specific ammo type
Config.Item = "pistol_ammo"             -- Default item name from your qb-core/shared/items.lua

Config.SpamDelay = 1500                 -- If trigger and error; How long delay until next trigger.
Config.CheckAndApplyAmmo = true         -- Weapons that have ammo beyond the clip get ammo automatically removed.
Config.DisablePistolPunching = true     -- Remove melee hits while wielding a weapon.

Config.NotificationStyle = "QBCORE"     --"QBCORE", "ESX", or "CONSOLE"

Config.Notifications = {
    FullClip = "You have a fully loaded clip in your weapon",
    NotEnough = "You don't have any ammo for this weapon", 
}

-- Add this section to make it easier to manage different ammo items
Config.AmmoMapping = {
    ["AMMO_PISTOL"]   = "pistol_ammo",
    ["AMMO_RIFLE"]    = "rifle_ammo",
    ["AMMO_SMG"]      = "smg_ammo",
    ["AMMO_SHOTGUN"]  = "shotgun_ammo",
    ["AMMO_SNIPER"]   = "sniper_ammo",
}