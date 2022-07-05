Config = {}
Config.HotwireChance = 0.5 -- Chance for successful hotwire or not

Config.RemoveLockpickNormal = 0.5 -- Chance to remove lockpick on fail
Config.RemoveLockpickAdvanced = 0.2 -- Chance to remove advanced lockpick on fail

Config.CarjackingTime = 7500 -- How long it takes to carjack
Config.DelayBetweenCarjackings = 10000 -- Time before you can carjack again

Config.TimeBetweenHotwires = 5000
Config.minHotwireTime = 20000
Config.maxHotwireTime = 40000

Config.AlertCooldown = 10000 -- 10 seconds
Config.PoliceAlertChance = 0.75 -- Chance of alerting police during the day
Config.PoliceNightAlertChance = 0.50 -- Chance of alerting police at night (times:01-06)

Config.ImmuneVehicles = { -- These vehicles cannot be jacked
    'stockade'
}

Config.NoLockVehicles = {}

Config.NoCarjackWeapons = {
    "WEAPON_UNARMED",
    "WEAPON_Knife",
    "WEAPON_Nightstick",
    "WEAPON_HAMMER",
    "WEAPON_Bat",
    "WEAPON_Crowbar",
    "WEAPON_Golfclub",
    "WEAPON_Bottle",
    "WEAPON_Dagger",
    "WEAPON_Hatchet",
    "WEAPON_KnuckleDuster",
    "WEAPON_Machete",
    "WEAPON_Flashlight",
    "WEAPON_SwitchBlade",
    "WEAPON_Poolcue",
    "WEAPON_Wrench",
    "WEAPON_Battleaxe",
    "WEAPON_Grenade",
    "WEAPON_StickyBomb",
    "WEAPON_ProximityMine",
    "WEAPON_BZGas",
    "WEAPON_Molotov",
    "WEAPON_FireExtinguisher",
    "WEAPON_PetrolCan",
    "WEAPON_Flare",
    "WEAPON_Ball",
    "WEAPON_Snowball",
    "WEAPON_SmokeGrenade",
}

Config.CarjackChance = {
    ['2685387236'] = 0.0,   -- melee
    ['416676503'] = 0.5,   -- handguns
    ['337201093'] = 0.75,   -- SMG
    ['860033945'] = 0.90,   -- shotgun
    ['970310034'] = 0.90,   -- assault
    ['1159398588'] = 0.99,  -- LMG
    ['3082541095'] = 0.99,  -- sniper
    ['2725924767'] = 0.99,  -- heavy
    ['1548507267'] = 0.0,   -- throwable
    ['4257178988'] = 0.0,   -- misc
}
