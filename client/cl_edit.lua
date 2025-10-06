lib.locale()
local N = require("config")

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

function Notify(text)
    if N.Core.Notify == "OX" then
        lib.notify({
            title = locale("NotificationTitle"),
            description = text,
            type = 'inform'
        })
    elseif N.Core.Notify == "ESX" then
        ESX.ShowNotification(text)
    elseif N.Core.Notify == "QB" then
        QBCore.Functions.Notify(text, "info")
    end
end

function Progressbar(dict, clip, model, bone, pos, rot)
    if N.Core.Progressbar == "OX-CIRCLE" then
        return lib.progressCircle({
            duration = 10000,
            label = locale("ProgressText"),
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = dict,
                clip = clip
            },
            prop = {
                model = model,
                bone = bone,
                pos = pos,
                rot = rot
            }
        })
    elseif N.Core.Progressbar == "OX-SQUARE" then 
        return lib.progressBar({
            duration = 10000,
            label = locale("ProgressText"),
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = dict,
                clip = clip
            },
            prop = {
                model = model,
                bone = bone,
                pos = pos,
                rot = rot
            }
        })
    end
    return false
end

function BreakMinigame()
    if N.Options.BreakMinigame == "OX" then 
        return lib.skillCheck({'easy', 'easy', 'easy', 'easy', {areaSize = 60, speedMultiplier = 2}}, {'1', '2', '3', '4'})
    elseif N.Options.BreakMinigame == "BL" then
        return exports.bl_ui:Progress(5, 70)
    end
    return false
end

function HackMinigame()
    if N.Options.HackMinigame == "BL" then
        return exports.bl_ui:MineSweeper(3, {
            grid = 4, 
            duration = 10000, 
            target = 4,
            previewDuration = 2000 
        })
    end
    return false
end

function PoliceAlert()
    if not N.PoliceOptions.EnablePoliceAlert then return end
    if N.PoliceOptions.PoliceAlert == "opto-dispatch" then
        for k,v in pairs(N.PoliceOptions.PoliceJobs) do
        local job = v
        local text = "Somebody is robbing an ATM!"
        local coords = GetEntityCoords(PlayerPedId()) 
        local id = GetPlayerServerId(PlayerId()) 
        local title = "ATM Robbery" 
        local panic = false 
        TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
        end
    elseif N.PoliceOptions.PoliceAlert == "aty-dispatch" then
        exports["aty_dispatch"]:SendDispatch("ATM Robbery", "10-26", 310, N.PoliceOptions.PoliceJobs)
    elseif N.PoliceOptions.PoliceAlert == "cd_dispatch" then
            local data = exports['cd_dispatch']:GetPlayerInfo()
            TriggerServerEvent('cd_dispatch:AddNotification', {
                job_table = N.PoliceOptions.PoliceJobs,
                coords = data.coords,
                title = '10-15 - ATM Robbery',
                message = ''..data.sex..' is robbing an atm!', 
                flash = 0,
                unique_id = data.unique_id,
                sound = 1,
                blip = {
                sprite = 310,
                scale = 1.2,
                colour = 1,
                flashes = false,
                text = '911 - ATM Robbery',
                time = 5,
                sound = 1,
            }
        })
    end
end
