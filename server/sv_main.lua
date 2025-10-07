local N = require("config")
local Webhook = "WEBHOOK HERE"

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

local Cooldowns = {}

local function GetAtmKey(coords)
    return string.format("%.3f,%.3f,%.3f", coords.x, coords.y, coords.z)
end

local function SendWebhook(message, description)
    if Webhook and Webhook ~= "" then
        local embed = {
            {
                ["title"] = "N_Atmrobbery",
                ["description"] = description,
                ["color"] = 0x00FF00,
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                ["footer"] = {
                    ["text"] = "N_AtmRobbery"
                }
            }
        }
        PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
end

local function CheckDistance(source, coords)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - coords)
    if distance > N.Options.MoveDistance then
        local playerName = GetPlayerName(source)
        local description = string.format("Player %s ID: %s were too far from ATM while robbing it (Possible cheater!) %s", playerName, source, tostring(coords))
        SendWebhook("", description)
        return false
    end
    return true
end

local function GetPoliceCount()
    local count = 0
    if N.Core.Framework == "ESX" then
        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.job and table.contains(N.PoliceOptions.PoliceJobs, xPlayer.job.name) then
                count = count + 1
            end
        end
    elseif N.Core.Framework == "QB" or N.Core.Framework == "QBX" then
        local players = QBCore.Functions.GetPlayers()
        for _, playerId in ipairs(players) do
            local Player = QBCore.Functions.GetPlayer(playerId)
            if Player and Player.PlayerData.job and table.contains(N.PoliceOptions.PoliceJobs, Player.PlayerData.job.name) then
                count = count + 1
            end
        end
    end
    return count
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

lib.callback.register('n_AtmRobbery_checkPolice', function(source)
    if not N.PoliceOptions.EnablePoliceAlert then
        return true 
    end
    local policeCount = GetPoliceCount()
    if policeCount >= N.PoliceOptions.PoliceNeeded then
        return true
    end
    return false
end)

lib.callback.register('n_AtmRobbery_canRob', function(source, coords)
    local key = GetAtmKey(coords)
    if Cooldowns[key] and os.time() < Cooldowns[key] then
        return false
    end
    return true
end)

lib.callback.register('n_AtmRobbery_giveReward', function(source, coords)
    local key = GetAtmKey(coords)
    if Cooldowns[key] and os.time() < Cooldowns[key] then
        return false
    end

    if not CheckDistance(source, coords) then
        return false
    end

    local Player
    local reward = N.Options.RewardCount

    if N.Core.Inventory == "OX" then
        exports.ox_inventory:AddItem(source, N.Options.RewardItem, reward)
    elseif N.Core.Inventory == "ESX" then
        Player = ESX.GetPlayerFromId(source)
        if Player then
            Player.addMoney(reward)
        end
    elseif N.Core.Inventory == "QB" then
        Player = QBCore.Functions.GetPlayer(source)
        if Player then
            Player.Functions.AddMoney('cash', reward)
        end
    end

    local playerName = GetPlayerName(source)
    local description = string.format("Player %s ID: %s robbed an ATM and got %d money in coords %s", playerName, source, reward, tostring(coords))
    SendWebhook("", description)

    Cooldowns[key] = os.time() + (N.Options.Cooldown * 60)
    return true
end)
