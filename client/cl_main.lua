lib.locale()
local N = require("config")
local AtmModels = N.AtmModels

if N.Core.Framework == "ESX" then
    if N.Core.UseNewESX then
        ESX = exports["es_extended"]:getSharedObject()
    else
        ESX = nil
        CreateThread(function()
            while ESX == nil do
                TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
                Wait(100)
            end
        end)
    end
elseif N.Core.Framework == "QB" then
    QBCore = exports["qb-core"]:GetCoreObject()
elseif N.Core.Framework == "QBX" then
    QBCore = exports["qbx-core"]:GetCoreObject()
end

for _, model in pairs(AtmModels) do
    exports.ox_target:addModel(model, {
        {
            name = 'atm_robbery',
            icon = 'fas fa-sack-dollar',
            label = locale("BreakTarget"),
            distance = N.Options.Distance,
            canInteract = function(entity, distance, coords, name)
                return GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(N.Options.BreakNeededWeapon)
            end,
            onSelect = function(data)
                local atmCoords = GetEntityCoords(data.entity)
                local hasEnoughPolice = lib.callback.await('n_AtmRobbery_checkPolice', false)
                if not hasEnoughPolice then
                    Notify(locale("NotEnoughPolice"))
                    return
                end
                local canRob = lib.callback.await('n_AtmRobbery_canRob', false, atmCoords)
                if not canRob then
                    Notify(locale("Cooldown"))
                    return
                end
                local success = BreakMinigame()
                if success then
                    PoliceAlert() 
                    if Progressbar('anim@heists@ornate_bank@grab_cash', 'grab', `p_ld_heist_bag_s`, 40269, vec3(0.0454, 0.2131, -0.1887), vec3(66.4762, 7.2424, -71.9051)) then
                        local rewardSuccess = lib.callback.await('n_AtmRobbery_giveReward', false, atmCoords)
                        if rewardSuccess then
                            Notify(locale("Success"))
                        end
                    end
                else
                    PoliceAlert()
                    Notify(locale("Failed"))
                end
            end
        },
        {
            name = 'atm_hack',
            icon = 'fas fa-laptop',
            label = locale("HackTarget"),
            distance = N.Options.Distance,
            items = N.Options.HackNeededItem,
            onSelect = function(data)
                local atmCoords = GetEntityCoords(data.entity)
                local hasEnoughPolice = lib.callback.await('n_AtmRobbery_checkPolice', false)
                if not hasEnoughPolice then
                    Notify(locale("NotEnoughPolice"))
                    return
                end
                local canRob = lib.callback.await('n_AtmRobbery_canRob', false, atmCoords)
                if not canRob then
                    Notify(locale("Cooldown"))
                    return
                end
                local success = HackMinigame()
                if success then
                    PoliceAlert()
                    if Progressbar('anim@heists@ornate_bank@grab_cash', 'grab', `p_ld_heist_bag_s`, 40269, vec3(0.0454, 0.2131, -0.1887), vec3(66.4762, 7.2424, -71.9051)) then
                        local rewardSuccess = lib.callback.await('n_AtmRobbery_giveReward', false, atmCoords)
                        if rewardSuccess then
                            Notify(locale("Success"))
                        end
                    end
                else
                    PoliceAlert()
                    Notify(locale("Failed"))
                end
            end
        }
    })
end
