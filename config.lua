return {
    Core = {
        Framework = "ESX", -- ESX, QB, QBX
        Inventory = "OX", -- OX, ESX, QB 
        UseNewESX = true,
        Notify = "OX", -- OX, ESX
        Progressbar = "OX-CIRCLE", -- OX-CIRCLE, OX-SQUARE
    },

    Options = {
        BreakMinigame = "BL", -- OX, BL
        BreakNeededWeapon = "WEAPON_CROWBAR",
        HackMinigame = "BL", -- BL
        HackNeededItem = "phone", 
        Cooldown = 1, -- In minutes
        Distance = 2.0, -- How far sees the target options
        MoveDistance = 3.0, -- How far can move
        RewardItem = "money",
        RewardCount = math.random(300, 500)
    },

    PoliceOptions = {
        EnablePoliceAlert = true,
        PoliceAlert = "aty-dispatch",
        PoliceNeeded = 1,
        PoliceJobs = {
            "police"
        }
    },

    AtmModels = {
        "prop_atm_01",
        "prop_atm_02",
        "prop_atm_03",
        "prop_fleeca_atm"
    }
}